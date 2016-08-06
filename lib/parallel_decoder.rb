require "./lib/stream_decoder"

module ParaMorse

  class ParallelDecoder
    attr_reader :decoders,
                :filenames,
                :decoded_contents

    def initialize
      @decoders = Array.new
      @filenames = Array.new
      @decoded_contents = Array.new
    end

    def decode_from_files(num_of_decoders, encoded_filename, decode_filename)
      generate_encoded_filenames(encoded_filename, num_of_decoders)
      generate_decoders(num_of_decoders)
      read_files_contents
      write_decoded_file(decode_filename)
    end

    def join_decoded_contents
      contents = Array.new
      decoded_contents[0].length.times do |counter|
        contents << extract_contents(counter)
      end
      contents.flatten.join
    end

    def extract_contents(index)
      decoded_contents.map do |content|
        content[index]
      end
    end

    def read_files_contents
      filenames.each_with_index do |filename, index|
        load_contents_into_decoder(filename, index)
      end
      decode_contents
    end

    def decode_contents
      @decoded_contents = decoders.map do |decoder|
        decoder.decode.chars
      end
    end

    def load_contents_into_decoder(filename, index)
      contents = File.read(filename)
      contents.chars.each do |character|
        decoders[index].receive(character)
      end
    end

    def generate_decoders(num_of_decoders)
      num_of_decoders.times do
        decoders << ParaMorse::StreamDecoder.new
      end
    end

    def generate_encoded_filenames(filename, num_of_decoders)
      filename.chomp!("*.txt")
      num_of_decoders.times do |counter|
        filenames << "./encoded_files/#{filename}#{counter}.txt"
      end
    end

    def write_decoded_file(filename)
      File.open("./decoded_files/#{filename}", "w") do |file|
        file.write(join_decoded_contents)
      end
    end
  end

end

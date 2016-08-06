require "./lib/decoder"

module ParaMorse

  class FileDecoder
    attr_reader :decoder

    def initialize
      @decoder = ParaMorse::Decoder.new
    end

    def decode(encoded_filename, decoded_output_filename)
      contents = decode_file_contents(encoded_filename)
      write_file(decoded_output_filename, contents)
    end

    def decode_file_contents(encoded_filename)
      contents = read_file_to_be_decoded(encoded_filename)
      decoder.decode(contents)
    end

    def read_file_to_be_decoded(encoded_filename)
      File.read("./encoded_files/#{encoded_filename}")
    end

    def write_file(filename, contents)
      File.open("./decoded_files/#{filename}", "w") do |file|
        file.write(contents)
      end
    end
  end

end

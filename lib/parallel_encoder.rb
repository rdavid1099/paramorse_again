require "./lib/stream_encoder"

module ParaMorse

  class ParallelEncoder
    attr_reader :encoders,
                :filenames

    def initialize
      @encoders = Array.new
      @filenames = Array.new
    end

    def encode_from_file(file_to_encode, num_of_encoders, output_filename)
      generate_encoders(num_of_encoders)
      generate_output_filenames(output_filename, num_of_encoders)
      assign_characters_to_encoders(file_to_encode)
      write_files
    end

    def assign_characters_to_encoders(filename)
      counter = 0
      file_contents(filename).chars. each do |character|
        encoders[counter].receive(character)
        counter = update_counter(counter)
      end
    end

    def file_contents(filename)
      File.read("./original_files/#{filename}")
    end

    def generate_encoders(num_of_encoders)
      num_of_encoders.times do
        encoders << ParaMorse::StreamEncoder.new
      end
    end

    def generate_output_filenames(filename, num_of_encoders)
      filename.chomp!("*.txt")
      num_of_encoders.times do |counter|
        filenames << "./encoded_files/#{filename}#{counter}.txt"
      end
    end

    def write_files
      filenames.each_with_index do |filename, index|
        File.open(filename, "w") do |file|
          file.write(encoders[index].encode)
        end
      end
    end

    def update_counter(counter)
      return counter += 1 unless counter + 1 == encoders.length
      counter = 0
    end
  end

end

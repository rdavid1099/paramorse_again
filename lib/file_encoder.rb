require "./lib/encoder"

module ParaMorse

  class FileEncoder
    attr_reader :encoder

    def initialize
      @encoder = ParaMorse::Encoder.new
    end

    def encode(origin_filename, encoded_filename)
      contents = encode_file_contents(origin_filename)
      write_file(encoded_filename, contents)
    end

    def encode_file_contents(origin_filename)
      contents = read_file_to_be_encoded(origin_filename)
      encoder.encode(contents)
    end

    def read_file_to_be_encoded(origin_filename)
      File.read("./original_files/#{origin_filename}")
    end

    def write_file(filename, contents)
      File.open("./encoded_files/#{filename}", "w") do |file|
        file.write(contents)
      end
    end
  end

end

require './lib/translator'

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
        decoders << StreamDecoder.new
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
        encoders << StreamEncoder.new
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

  class StreamDecoder
    attr_reader :queue,
                :decoder,
                :morse_words

    def initialize
      @queue = Queue.new
      @decoder = Decoder.new
      @morse_words = Array.new
    end

    def receive(digit)
      queue.push(digit.to_s[0])
    end

    def decode
      split_white_space
      morse_words.reduce("") do |result, morse_word|
        result += decoder.decode(morse_word)
      end
    end

    def split_white_space
      result = String.new
      until queue.count == 0
        result = convert_morse_to_white_space(result)
      end
      morse_words << result unless result.empty?
    end

    def convert_morse_to_white_space(result)
      if queue.peek(4) == ["0","0","0","0"]
        inject_morse_space_into_morse_words(result)
      elsif queue.peek == "\n"
        inject_new_line_into_morse_words(result)
      else
        result += queue.pop
      end
    end

    def inject_morse_space_into_morse_words(result)
      if result.empty?
        morse_words << queue.pop(7)
      else
        morse_words << result
        morse_words << queue.pop(7)
      end
      result = ""
    end

    def inject_new_line_into_morse_words(result)
      if result.empty?
        morse_words << queue.pop
      else
        morse_words << result
        morse_words << queue.pop
      end
      result = ""
    end
  end

  class StreamEncoder
    attr_reader :queue,
                :encoder,
                :words

    def initialize
      @queue = Queue.new
      @encoder = Encoder.new
      @words = Array.new
    end

    def receive(letter)
      queue.push(letter.to_s[0])
    end

    def encode
      split_words
      words.reduce("") do |result, word|
        result += evaluate_word_to_encode(word)
      end
    end

    def evaluate_word_to_encode(word)
      if word == "0000000" || word == "\n"
        word
      else
        encoder.encode(word)
      end
    end

    def split_words
      last_word = queue.pop_all.chars.reduce("") do |result, character|
        result = convert_white_space_to_morse(result, character)
      end
      words << last_word unless last_word.empty?
    end

    def convert_white_space_to_morse(result, character)
      if character == " "
        inject_space_into_words(result)
      elsif character == "\n"
        inject_new_line_into_words(result)
      else
        result += character
      end
    end

    def inject_space_into_words(result)
      if result.empty?
        words << "0000000"
      else
        words << result
        words << "0000000"
      end
      result = ""
    end

    def inject_new_line_into_words(result)
      if result.empty?
        words << "\n"
      else
        words << result
        words << "0000000"
      end
      result = ""
    end
  end

  class Decoder
    attr_reader :letter_decoder

    def initialize
      @letter_decoder = LetterDecoder.new
    end

    def decode(morse)
      morse_segments = split_morse_lines(morse)
      morse_words = split_morse_segments(morse_segments)
      morse_words.map do |word|
        decode_morse_words(word)
      end.join
    end

    def decode_morse_words(morse)
      morse_letters = split_morse_letters(morse)
      morse_letters.map do |morse_letter|
        letter_decoder.decode(morse_letter)
      end.join
    end

    def split_morse_lines(morse)
      return [morse] if morse == "\n" || !morse.include?("\n")
      morse.split("\n").reduce([]) do |result, word|
        result << word
        result << "\n"
      end
    end

    def split_morse_segments(morse_segments)
      morse_segments.map do |segment|
        split_morse_words(segment)
      end.flatten
    end

    def split_morse_words(words)
      return [words] if words == "0000000" || !words.include?("0000000")
      words.split("0000000").reduce([]) do |result, word|
        result << word
        result << "0000000"
      end
    end

    def split_morse_letters(morse)
      unless morse == "0000000"
        morse.split("000")
      else
        [morse]
      end
    end
  end

  class Encoder
    attr_reader :letter_encoder

    def initialize
      @letter_encoder = LetterEncoder.new
    end

    def encode(statement)
      segments = split_statement_by_new_lines(statement)
      words = split_segments(segments)
      words.map do |word|
        encode_word(word)
      end.join
    end

    def encode_word(word)
      letters = split_into_letters(word)
      letters.map.with_index do |letter, index|
        encode_letter_with_placement(letter, index, letters)
      end.join
    end

    def encode_letter_with_placement(letter, index, word)
      unless index == word.length - 1
       "#{letter_encoder.encode(letter)}000"
      else
       letter_encoder.encode(letter)
      end
    end

    def split_statement_by_new_lines(statement)
      return [statement] unless statement.include?("\n")
      return ["\n"] if statement.include?("\n") && statement.length == 1
      statement.split("\n").reduce([]) do |result, words|
        result << words
        result << "\n"
      end
    end

    def split_segments(segments)
      segments.map do |segment|
        split_words(segment)
      end.flatten
    end

    def split_words(words)
      return [words] unless words.include?(" ")
      words.split(" ").reduce([]) do |result, word|
        result << word
        result << " "
      end
    end

    def split_into_letters(word)
      word.chars
    end
  end

  class LetterEncoder
    include Translator

    def encode(letter)
      if valid_letter?(letter)
        eng_to_morse_translator[letter.downcase]
      else
        letter
      end
    end

    def valid_letter?(letter)
      !eng_to_morse_translator[letter.downcase].nil?
    end
  end

  class LetterDecoder
    include Translator

    def decode(morse)
      if valid_morse?(morse)
        morse_to_eng_translator[morse]
      else
        morse.gsub(/[10]/,"")
      end
    end

    def valid_morse?(morse)
      morse.chars.all? do |character|
        character == "0" || character == "1"
      end
    end
  end

  class FileDecoder
    attr_reader :decoder

    def initialize
      @decoder = Decoder.new
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

  class FileEncoder
    attr_reader :encoder

    def initialize
      @encoder = Encoder.new
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

  class Queue
    attr_reader :queue

    def initialize
      @queue = Array.new
    end

    def push(digit)
      queue << digit
    end

    def pop(amount = 1)
      if amount == 1
        queue.shift
      else
        pop_multiple(amount).join
      end
    end

    def pop_multiple(amount)
      popped_elements = Array.new
      amount.times do
        popped_elements << queue.shift
      end
      popped_elements.reverse
    end

    def pop_all
      elements = queue.join
      clear
      elements
    end

    def peek(amount = 1)
      if amount == 1
        queue[0]
      else
        queue[0..amount - 1]
      end
    end

    def tail(amount = 1)
      if amount == 1
        queue[-1]
      else
        queue.reverse[0..amount - 1]
      end
    end

    def count
      queue.length
    end

    def clear
      @queue = Array.new
    end
  end
end

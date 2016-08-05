require './lib/translator'

module ParaMorse

  class StreamDecoder
    attr_reader :queue,
                :decoder

    def initialize
      @queue = Queue.new
      @decoder = Decoder.new
    end

    def receive(digit)
      queue.push(digit.to_s[0])
    end

    def decode
      morse_to_decode = queue.pop_all
      decoder.decode(morse_to_decode)
    end
  end

  class StreamEncoder
    attr_reader :queue,
                :encoder

    def initialize
      @queue = Queue.new
      @encoder = Encoder.new
    end

    def receive(letter)
      queue.push(letter.to_s[0])
    end

    def encode
      words_to_encode = queue.pop_all
      encoder.encode(words_to_encode)
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
      return [morse] unless morse.include?("\n")
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
      return [words] unless words.include?("0000000")
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
        pop_multiple(amount)
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

require './lib/translator'

module ParaMorse

  class Decoder
    attr_reader :letter_decoder

    def initialize
      @letter_decoder = LetterDecoder.new
    end

    def decode(morse)
      morse_words = split_morse_words(morse)
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
      words = split_words(statement)
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

require "./lib/queue"
require "./lib/encoder"

module ParaMorse

  class StreamEncoder
    attr_reader :queue,
                :encoder,
                :words

    def initialize
      @queue = ParaMorse::Queue.new
      @encoder = ParaMorse::Encoder.new
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
        words << "\n"
      end
      result = ""
    end
  end

end

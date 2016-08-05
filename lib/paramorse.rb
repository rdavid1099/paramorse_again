require './lib/translator'

module ParaMorse

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

end

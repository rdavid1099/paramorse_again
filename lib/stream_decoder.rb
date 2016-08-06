require "./lib/queue"
require "./lib/decoder"

module ParaMorse

  class StreamDecoder
    attr_reader :queue,
                :decoder,
                :morse_words

    def initialize
      @queue = ParaMorse::Queue.new
      @decoder = ParaMorse::Decoder.new
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

end

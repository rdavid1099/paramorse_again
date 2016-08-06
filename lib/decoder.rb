require "./lib/letter_decoder"

module ParaMorse

  class Decoder
    attr_reader :letter_decoder

    def initialize
      @letter_decoder = ParaMorse::LetterDecoder.new
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

end

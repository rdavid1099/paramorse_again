require "./lib/letter_encoder"

module ParaMorse

  class Encoder
    attr_reader :letter_encoder

    def initialize
      @letter_encoder = ParaMorse::LetterEncoder.new
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
      return [statement] if statement == "\n" || !statement.include?("\n")
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
      return [words] if words == " " || !words.include?(" ")
      words.split(" ").reduce([]) do |result, word|
        result << word
        result << " "
      end
    end

    def split_into_letters(word)
      word.chars
    end
  end

end

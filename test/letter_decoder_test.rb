require "./lib/paramorse"
require "./test/test_helper"

class TestLetterDecoder < Minitest::Test
  def test_decoder_exists
    letter_decoder = ParaMorse::LetterDecoder.new

    assert_instance_of ParaMorse::LetterDecoder, letter_decoder
  end

  def test_decoder_can_decode_basic_letters
    letter_decoder = ParaMorse::LetterDecoder.new

    assert_equal "a", letter_decoder.decode("10111")
    assert_equal "r", letter_decoder.decode("1011101")
  end

  def test_decoder_handles_known_special_characters
    letter_decoder = ParaMorse::LetterDecoder.new

    assert_equal ".", letter_decoder.decode("10111010111010111")
    assert_equal ",", letter_decoder.decode("1110111010101110111")
  end

  def test_decoder_recognizes_morse_that_has_chars_other_than_1_and_0
    letter_decoder = ParaMorse::LetterDecoder.new

    assert_equal true, letter_decoder.valid_morse?("10111")
    assert_equal false, letter_decoder.valid_morse?("000>000")
    assert_equal false, letter_decoder.valid_morse?("!")
  end

  def test_decoder_decyphers_unknown_special_characters_surrounded_by_zeros
    letter_decoder = ParaMorse::LetterDecoder.new

    assert_equal "!", letter_decoder.decode("001101000!0000000")
    assert_equal "<", letter_decoder.decode("<")
    assert_equal ">", letter_decoder.decode("000>000")
  end
end

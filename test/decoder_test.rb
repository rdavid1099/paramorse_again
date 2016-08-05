require "./lib/paramorse"
require "./test/test_helper"

class TestDecoder < Minitest::Test
  def test_decoder_exists
    decoder = ParaMorse::Decoder.new

    assert_instance_of ParaMorse::Decoder, decoder
  end

  def test_decoder_properly_splits_letters
    decoder = ParaMorse::Decoder.new
    word = "1011101110001110111011100010111010001110101"
    expected = ["101110111", "11101110111", "1011101", "1110101"]
    actual = decoder.split_morse_letters(word)

    assert_equal expected, actual
  end

  def test_decoder_splits_larger_words
    decoder = ParaMorse::Decoder.new
    word = "11101110001000111000101110001011101010001011101010001010001110101110100010111000!"
    expected = ["1110111", "1", "111", "10111", "101110101", "101110101", "101", "11101011101", "10111", "!"]
    actual = decoder.split_morse_letters(word)

    assert_equal expected, actual
  end

  def test_decoder_decodes_entire_word
    decoder = ParaMorse::Decoder.new

    assert_equal "word", decoder.decode("1011101110001110111011100010111010001110101")
  end

  def test_decoder_can_handle_more_complex_words
    decoder = ParaMorse::Decoder.new
    word = "11101110001000111000101110001011101010001011101010001010001110101110100010111000!"
    expected = "metallica!"
    actual = decoder.decode(word)

    assert_equal expected, actual
  end

end

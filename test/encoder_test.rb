require "./lib/encoder"
require "./test/test_helper"

class TestEncoder < Minitest::Test
  def test_encoder_exists
    encoder = ParaMorse::Encoder.new

    assert_instance_of ParaMorse::Encoder, encoder
  end

  def test_encoder_splits_simple_strings_into_letters
    encoder = ParaMorse::Encoder.new

    assert_equal ["h","i"], encoder.split_into_letters("hi")
    assert_equal ["H","I"], encoder.split_into_letters("HI")
  end

  def test_encoder_can_encode_a_simple_word
    encoder = ParaMorse::Encoder.new

    assert_equal "1010101000101", encoder.encode("hi")
    assert_equal "1010101000101", encoder.encode("HI")
  end

  def test_encoder_can_handle_a_more_complicated_word
    encoder = ParaMorse::Encoder.new

    assert_equal "11101110001000111000101110001011101010001011101010001010001110101110100010111000!", encoder.encode("MeTaLlIcA!")
  end

  def test_encoder_splits_multiple_words_into_array_of_words
    encoder = ParaMorse::Encoder.new
    expected = ["Pink"," ","Floyd", " "]
    actual = encoder.split_words("Pink Floyd")

    assert_equal expected, actual
  end

  def test_encoder_splits_multiple_words_with_spec_chars_into_array_of_words
    encoder = ParaMorse::Encoder.new
    expected = ["Welcome,"," ","my"," ","friend,"," ","welcome"," ","to"," ","the"," ","machine!"," "]
    actual = encoder.split_words("Welcome, my friend, welcome to the machine!")

    assert_equal expected, actual
  end

  def test_encoder_can_encode_multiple_words
    encoder = ParaMorse::Encoder.new
    expected = "1011101110100010100011101000111010111000000010101110100010111010100011101110111000111010111011100011101010000000"
    actual = encoder.encode("pink floyd")

    assert_equal expected, actual
  end

  def test_encoder_handles_words_with_grammar
    encoder = ParaMorse::Encoder.new
    expected = "101110111000100010111010100011101011101000111011101110001110111000100011101110101011101110000000111011100011101011101110000000101011101000101110100010100010001110100011101010001110111010101110111000000010111011100010001011101010001110101110100011101110111000111011100010000000111000111011101110000000111000101010100010000000111011100010111000111010111010001010101000101000111010001000!0000000"
    actual = encoder.encode("Welcome, my friend, welcome to the machine!")

    assert_equal expected, actual
  end

  def test_encoder_splits_new_lines
    encoder = ParaMorse::Encoder.new
    sentence = "This sentence,
has a lot
of new
lines."
    expected = ["This sentence,","\n","has a lot","\n","of new","\n","lines.","\n"]
    actual = encoder.split_statement_by_new_lines(sentence)

    assert_equal expected, actual
  end

  def test_encoder_can_handle_a_single_new_line
    encoder = ParaMorse::Encoder.new
    sentence = "\n"
    expected = ["\n"]
    actual = encoder.split_statement_by_new_lines(sentence)

    assert_equal expected, actual
  end

  def test_encoder_can_handle_sentence_with_new_lines
    encoder = ParaMorse::Encoder.new
    expected = "1011101110001000101110101000111010111010001110111011100011101110001000111011101010111011100000001110111000111010111011100000001010111010001011101000101000100011101000111010100011101110101011101110000000\n10111011100010001011101010001110101110100011101110111000111011100010000000111000111011101110000000111000101010100010000000111011100010111000111010111010001010101000101000111010001000!0000000\n"
    actual = encoder.encode("Welcome, my friend,\nwelcome to the machine!")

    assert_equal expected, actual
  end
end

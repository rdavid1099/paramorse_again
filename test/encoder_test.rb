require "./lib/paramorse"
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

  def test_encoder_returns_correct_character_depending_on_character_position_in_string
    encoder = ParaMorse::Encoder.new
    word1 = ["h","e","l","l","o"]

    assert_equal "1010101000", encoder.encode_letter_with_placement("h", 0, word1)
    assert_equal "1000", encoder.encode_letter_with_placement("e", 1, word1)
    assert_equal "11101110111", encoder.encode_letter_with_placement("o", 4, word1)
  end

  def test_encoder_analyzes_correct_character_placement_for_longer_word
    encoder = ParaMorse::Encoder.new
    word2 = ["m","e","t","a","l","l","i","c","a"]

    assert_equal "111000", encoder.encode_letter_with_placement("T", 2, word2)
    assert_equal "1000", encoder.encode_letter_with_placement("e", 1, word2)
    assert_equal "10111000", encoder.encode_letter_with_placement("a", 3, word2)
    assert_equal "10111", encoder.encode_letter_with_placement("a", 8, word2)
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

end

require "./lib/paramorse"
require "./test/test_helper"

class TestLetterEncoder < Minitest::Test
  def test_encoder_exists
    letter_encoder = ParaMorse::LetterEncoder.new

    assert_instance_of ParaMorse::LetterEncoder, letter_encoder
  end

  def test_encoder_can_receive_a_letter_to_encode
    letter_encoder = ParaMorse::LetterEncoder.new

    assert_equal "10111", letter_encoder.encode("a")
  end

  def test_encoder_can_receive_a_different_letter_to_encode
    letter_encoder = ParaMorse::LetterEncoder.new

    assert_equal "10111", letter_encoder.encode("a")
    assert_equal "1110111010111", letter_encoder.encode("q")
  end

  def test_encoder_is_case_insensitive
    letter_encoder = ParaMorse::LetterEncoder.new

    assert_equal "111010101", letter_encoder.encode("B")
    assert_equal "1011101", letter_encoder.encode("R")
  end

  def test_encoder_can_handle_special_characters
    letter_encoder = ParaMorse::LetterEncoder.new

    assert_equal "10111010111010111", letter_encoder.encode(".")
    assert_equal "1110111010101110111", letter_encoder.encode(",")
    assert_equal "1011101110111011101", letter_encoder.encode("'")
  end

  def test_encoder_evaluates_valid_and_invalid_letters
    letter_encoder = ParaMorse::LetterEncoder.new

    assert_equal true, letter_encoder.valid_letter?("a")
    assert_equal true, letter_encoder.valid_letter?("R")
    assert_equal true, letter_encoder.valid_letter?(".")
    assert_equal false, letter_encoder.valid_letter?("ä")
  end

  def test_encoder_returns_character_if_it_is_not_understood
    letter_encoder = ParaMorse::LetterEncoder.new

    assert_equal "<", letter_encoder.encode("<")
    assert_equal ">", letter_encoder.encode(">")
    assert_equal "ä", letter_encoder.encode("ä")
  end

end

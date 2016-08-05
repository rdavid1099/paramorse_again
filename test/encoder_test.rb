require "./lib/paramorse"
require "./test/test_helper"

class TestEncoder < Minitest::Test
  def test_encoder_exists
    letter_encoder = ParaMorse::Encoder.new

    assert_instance_of ParaMorse::Encoder, letter_encoder
  end

  def test_encoder_can_receive_a_letter_to_encode
    letter_encoder = ParaMorse::Encoder.new

    assert_equal "10111", letter_encoder.encode("a")
  end

  def test_encoder_can_receive_a_different_letter_to_encode
    letter_encoder = ParaMorse::Encoder.new

    assert_equal "10111", letter_encoder.encode("a")
    assert_equal "1110111010111", letter_encoder.encode("q")
  end

  def test_encoder_is_case_insensitive
    letter_encoder = ParaMorse::Encoder.new

    assert_equal "111010101", letter_encoder.encode("B")
    assert_equal "1011101", letter_encoder.encode("R")
  end

end

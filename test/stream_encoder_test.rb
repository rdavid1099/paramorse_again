require "./lib/stream_encoder"
require "./test/test_helper"

class TestStreamEncoder < Minitest::Test
  def test_stream_encoder_exists
    stream = ParaMorse::StreamEncoder.new

    assert_instance_of ParaMorse::StreamEncoder, stream
  end

  def test_stream_encoder_can_receive_a_letter
    stream = ParaMorse::StreamEncoder.new
    stream.receive("a")

    assert_equal 1, stream.queue.count
    assert_equal "a", stream.queue.peek
  end

  def test_stream_encoder_can_receive_more_than_one_letter
    stream = ParaMorse::StreamEncoder.new
    stream.receive("a")
    stream.receive("p")
    stream.receive("p")
    stream.receive("l")
    stream.receive("e")

    assert_equal 5, stream.queue.count
    assert_equal "a", stream.queue.peek
    assert_equal "apple", stream.queue.peek(5).join
  end

  def test_stream_only_takes_first_element_if_more_than_one_is_given
    stream = ParaMorse::StreamEncoder.new
    stream.receive("aklfd;s")

    assert_equal "a", stream.queue.peek
  end

  def test_integers_are_converted_to_strings
    stream = ParaMorse::StreamEncoder.new
    stream.receive(7)

    assert_equal "7", stream.queue.peek
  end

  def test_stream_encoder_can_receive_multiple_words
    stream = ParaMorse::StreamEncoder.new
    stream.receive("e")
    stream.receive("a")
    stream.receive("t")
    stream.receive(" ")
    stream.receive("a")
    stream.receive("p")
    stream.receive("p")
    stream.receive("l")
    stream.receive("e")

    assert_equal 9, stream.queue.count
    assert_equal "e", stream.queue.peek
    assert_equal "eat apple", stream.queue.peek(9).join
  end

  def test_stream_can_be_encoded_when_told_to_do_so
    stream = ParaMorse::StreamEncoder.new
    stream.receive("P")
    stream.receive("i")
    stream.receive("n")
    stream.receive("k")
    stream.receive(" ")
    stream.receive("F")
    stream.receive("l")
    stream.receive("o")
    stream.receive("y")
    stream.receive("d")
    expected = "101110111010001010001110100011101011100000001010111010001011101010001110111011100011101011101110001110101"

    assert_equal expected, stream.encode
  end

  def test_stream_encoder_detects_multiple_white_spaces
    stream = ParaMorse::StreamEncoder.new

    assert_equal "", stream.convert_white_space_to_morse("pink"," ")
    assert_equal ["pink","0000000"], stream.words
    assert_equal "floyd", stream.convert_white_space_to_morse("floy","d")
  end

  def test_stream_can_encode_awkward_amounts_of_white_space
    stream = ParaMorse::StreamEncoder.new
    stream.receive("P")
    stream.receive("i")
    stream.receive("n")
    stream.receive("k")
    stream.receive(" ")
    stream.receive(" ")
    stream.receive("F")
    stream.receive("l")
    stream.receive("o")
    stream.receive("y")
    stream.receive("d")
    stream.receive(" ")
    stream.receive(" ")
    expected = "101110111010001010001110100011101011100000000000000101011101000101110101000111011101110001110101110111000111010100000000000000"

    assert_equal expected, stream.encode
  end

  def test_stream_can_encode_strange_characters_and_new_lines
    stream = ParaMorse::StreamEncoder.new
    stream.receive(" ")
    stream.receive(" ")
    stream.receive("\n")
    stream.receive("P")
    stream.receive("i")
    stream.receive("n")
    stream.receive("k")
    stream.receive(" ")
    stream.receive(" ")
    stream.receive("F")
    stream.receive("l")
    stream.receive("o")
    stream.receive("y")
    stream.receive("d")
    stream.receive(" ")
    stream.receive(" ")
    expected = "00000000000000\n101110111010001010001110100011101011100000000000000101011101000101110101000111011101110001110101110111000111010100000000000000"

    assert_equal expected, stream.encode
  end

  def test_stream_can_encode_several_new_lines
    stream = ParaMorse::StreamEncoder.new
    stream.receive("\n")
    stream.receive("\n")
    stream.receive("\n")
    expected = "\n\n\n"

    assert_equal expected, stream.encode
  end

end

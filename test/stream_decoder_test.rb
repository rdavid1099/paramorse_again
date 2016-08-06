require "./lib/stream_decoder"
require "./test/test_helper"

class TestStreamDecoder < Minitest::Test
  def test_stream_decoder_exists
    stream = ParaMorse::StreamDecoder.new

    assert_instance_of ParaMorse::StreamDecoder, stream
  end

  def test_stream_decoder_can_receive_a_digit
    stream = ParaMorse::StreamDecoder.new
    stream.receive("1")

    assert_equal 1, stream.queue.count
    assert_equal "1", stream.queue.peek
  end

  def test_stream_decoder_can_receive_more_than_one_digit
    stream = ParaMorse::StreamDecoder.new
    stream.receive("1")
    stream.receive("1")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("1")
    stream.receive("1")

    assert_equal 7, stream.queue.count
    assert_equal ["1","1","1","0"], stream.queue.peek(4)
  end

  def test_stream_uses_only_first_digit_if_string_is_longer_than_one
    stream = ParaMorse::StreamDecoder.new
    stream.receive("100011101")

    assert_equal 1, stream.queue.count
    assert_equal "1", stream.queue.peek
  end

  def test_stream_can_handle_integers
    stream = ParaMorse::StreamDecoder.new
    stream.receive(1)
    stream.receive(1)
    stream.receive("0")

    assert_equal 3, stream.queue.count
    assert_equal ["1","1","0"], stream.queue.peek(3)
  end

  def test_stream_decodes_all_elements_when_told
    stream = ParaMorse::StreamDecoder.new
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")

    assert_equal "hi", stream.decode
  end

  def test_stream_decodes_spaces
    stream = ParaMorse::StreamDecoder.new
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")


    assert_equal "hi ", stream.decode
  end

  def test_stream_decoder_splits_white_space
    stream = ParaMorse::StreamDecoder.new
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.split_white_space

    assert_equal ["0000000","1010101000101","0000000"], stream.morse_words
  end

  def test_stream_decoder_splits_white_space_and_new_lines
    stream = ParaMorse::StreamDecoder.new
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("\n")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("\n")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.split_white_space

    assert_equal ["0000000","\n","1010101000101","\n","0000000"], stream.morse_words
  end

  def test_stream_decoder_decodes_white_space_and_new_lines
    stream = ParaMorse::StreamDecoder.new
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("\n")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("1")
    stream.receive("0")
    stream.receive("1")
    stream.receive("\n")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")
    stream.receive("0")

    assert_equal "\s\nhi\n\s", stream.decode
  end
end

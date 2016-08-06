require "./lib/paramorse"
require "./test/test_helper"

class TestParallelDecoder < Minitest::Test
  def test_encoder_exists
    parallel_decoder = ParaMorse::ParallelDecoder.new

    assert_instance_of ParaMorse::ParallelDecoder, parallel_decoder
  end

  def test_parallel_decoder_can_take_three_arguments
    parallel_decoder = ParaMorse::ParallelDecoder.new

    assert parallel_decoder.decode_from_files(4, "test_output*.txt", "test_decoded.txt")
  end

  def test_parallel_decoder_generates_stream_decoders
    parallel_decoder = ParaMorse::ParallelDecoder.new
    parallel_decoder.generate_decoders(4)

    assert_equal 4, parallel_decoder.decoders.length
    assert_instance_of ParaMorse::StreamDecoder, parallel_decoder.decoders[0]
  end

  def test_parallel_decoder_generates_input_filenames
    parallel_decoder = ParaMorse::ParallelDecoder.new
    parallel_decoder.generate_encoded_filenames("test_output*.txt", 4)

    assert_equal "./encoded_files/test_output0.txt", parallel_decoder.filenames[0]
    assert_equal "./encoded_files/test_output1.txt", parallel_decoder.filenames[1]
    assert_equal "./encoded_files/test_output2.txt", parallel_decoder.filenames[2]
    assert_equal "./encoded_files/test_output3.txt", parallel_decoder.filenames[3]
  end

  def test_encoded_file_contents_are_loaded_into_respective_decoder_stream
    parallel_decoder = ParaMorse::ParallelDecoder.new
    parallel_decoder.generate_decoders(4)
    parallel_decoder.generate_encoded_filenames("test_output*.txt", 4)
    parallel_decoder.read_files_contents

    assert_equal "111000000010111".chars, parallel_decoder.decoders[0].queue.peek(15)
    assert_equal "101010100010100".chars, parallel_decoder.decoders[1].queue.peek(15)
    assert_equal "101000101010001".chars, parallel_decoder.decoders[2].queue.peek(15)
    assert_equal "101010000000100".chars, parallel_decoder.decoders[3].queue.peek(15)
  end

end

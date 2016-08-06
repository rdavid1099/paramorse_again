require "./lib/parallel_decoder"
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

  def test_encoded_file_contents_are_decoding_properly
    parallel_decoder = ParaMorse::ParallelDecoder.new
    parallel_decoder.generate_decoders(4)
    parallel_decoder.generate_encoded_filenames("test_output*.txt", 4)
    parallel_decoder.read_files_contents

    assert_equal "t as", parallel_decoder.decoders[0].decode[0..3]
    assert_equal "hi t", parallel_decoder.decoders[1].decode[0..3]
    assert_equal "ist ", parallel_decoder.decoders[2].decode[0..3]
    assert_equal "s ef", parallel_decoder.decoders[3].decode[0..3]
  end

  def test_parallel_decoder_decodes_streams_into_2d_array
    parallel_decoder = ParaMorse::ParallelDecoder.new
    parallel_decoder.generate_decoders(4)
    parallel_decoder.generate_encoded_filenames("test_output*.txt", 4)
    parallel_decoder.read_files_contents

    assert_equal 4, parallel_decoder.decoded_contents.length
    assert_equal "t as".chars, parallel_decoder.decoded_contents[0][0..3]
    assert_equal "hi t".chars, parallel_decoder.decoded_contents[1][0..3]
    assert_equal "ist ".chars, parallel_decoder.decoded_contents[2][0..3]
    assert_equal "s ef".chars, parallel_decoder.decoded_contents[3][0..3]
  end

  def test_parallel_decoder_combines_decoded_content
    parallel_decoder = ParaMorse::ParallelDecoder.new
    parallel_decoder.generate_decoders(4)
    parallel_decoder.generate_encoded_filenames("test_output*.txt", 4)
    parallel_decoder.read_files_contents
    expected = "this is a test file.  if you have found this, then you have found the test file."
    actual = parallel_decoder.join_decoded_contents[0..79]

    assert_equal expected, actual
  end

  def test_parallel_decoder_file_is_the_same_as_the_original
    parallel_decoder = ParaMorse::ParallelDecoder.new
    parallel_decoder.decode_from_files(4, "test_output*.txt", "test_decoded.txt")
    expected = "this is a test file.  if you have found this, then you have found the test file."
    actual = File.read("./decoded_files/test_decoded.txt")[0..79]

    assert_equal true, File.exist?("./decoded_files/test_decoded.txt")
    assert_equal expected, actual
    assert_equal File.read("./original_files/test_plain.txt").downcase, File.read("./decoded_files/test_decoded.txt")
  end
end

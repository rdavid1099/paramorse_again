require "./lib/paramorse"
require "./test/test_helper"

class TestParallelEncoder < Minitest::Test
  def test_encoder_exists
    parallel_encoder = ParaMorse::ParallelEncoder.new

    assert_instance_of ParaMorse::ParallelEncoder, parallel_encoder
  end

  def test_parallel_encoder_can_take_three_arguments_encoding_from_file
    parallel_encoder = ParaMorse::ParallelEncoder.new

    assert parallel_encoder.encode_from_file("test_plain.txt", 4, "test_output*.txt")
  end

  def test_parallel_encoder_generates_array_given_number_of_encoders
    parallel_encoder = ParaMorse::ParallelEncoder.new
    parallel_encoder.generate_encoders(4)

    assert_equal 4, parallel_encoder.encoders.length
    assert_instance_of ParaMorse::StreamEncoder, parallel_encoder.encoders[0]
  end

  def test_parallel_encoder_generates_output_filenames
    parallel_encoder = ParaMorse::ParallelEncoder.new
    parallel_encoder.generate_output_filenames("test_output*.txt", 4)

    assert_equal 4, parallel_encoder.filenames.length
    assert_equal "./encoded_files/test_output0.txt", parallel_encoder.filenames[0]
    assert_equal "./encoded_files/test_output1.txt", parallel_encoder.filenames[1]
  end

  def test_parallel_encoder_saves_files_using_generated_filenames
    parallel_encoder = ParaMorse::ParallelEncoder.new
    parallel_encoder.generate_output_filenames("test_output*.txt", 4)
    parallel_encoder.generate_encoders(4)
    parallel_encoder.write_files

    assert_equal true, File.exist?("./encoded_files/test_output0.txt")
    assert_equal true, File.exist?("./encoded_files/test_output1.txt")
    assert_equal true, File.exist?("./encoded_files/test_output2.txt")
    assert_equal true, File.exist?("./encoded_files/test_output3.txt")
    assert_equal false, File.exist?("./encoded_files/test_output4.txt")
  end

  def test_parallel_encoder_reads_contents_from_files
    parallel_encoder = ParaMorse::ParallelEncoder.new

    assert_equal "This is a test", parallel_encoder.file_contents("test_plain.txt")[0..13]
  end

  def test_parallel_encoder_divides_file_content_characters_into_encoders
    parallel_encoder = ParaMorse::ParallelEncoder.new
    parallel_encoder.generate_encoders(4)
    parallel_encoder.assign_characters_to_encoders("test_plain.txt")

    assert_equal "T asi ".chars, parallel_encoder.encoders[0].queue.peek(6)
    assert_equal "hi t".chars, parallel_encoder.encoders[1].queue.peek(4)
    assert_equal "ist ".chars, parallel_encoder.encoders[2].queue.peek(4)
    assert_equal "s ef".chars, parallel_encoder.encoders[3].queue.peek(4)
  end

  def test_parallel_encoder_saves_encoded_files_to_directory
    parallel_encoder = ParaMorse::ParallelEncoder.new
    assert parallel_encoder.encode_from_file("test_plain.txt", 4, "test_output*.txt")

    assert_equal true, File.exist?("./encoded_files/test_output0.txt")
    assert_equal "111000000010111000101010001010000000", File.read("./encoded_files/test_output0.txt")[0..35]
  end

end

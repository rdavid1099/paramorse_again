require "./test/test_helper"
require "./lib/parallel_encoder"
require "./lib/parallel_decoder"

class TestParaMorseFunctionality < Minitest::Test
  def test_parallel_encoder_and_decoder_work_with_large_files_encodes_large_news_file
    parallel_encoder = ParaMorse::ParallelEncoder.new
    parallel_decoder = ParaMorse::ParallelDecoder.new
    parallel_encoder.encode_from_file('test_large_news_file.txt', 8, 'test_large_news_file_output*.txt')

    8.times do |number|
      assert_equal true, File.exist?("./encoded_files/test_large_news_file_output#{number}.txt")
    end

    parallel_decoder.decode_from_files(8, 'test_large_news_file_output*.txt', 'test_large_news_file_decoded.txt')
    expected = File.read("./original_files/test_large_news_file.txt").downcase
    actual = File.read("./decoded_files/test_large_news_file_decoded.txt")

    assert_equal expected, actual
  end

  def test_parallel_encoder_and_decoder_can_handle_HAMLET
    parallel_encoder = ParaMorse::ParallelEncoder.new
    parallel_decoder = ParaMorse::ParallelDecoder.new
    parallel_encoder.encode_from_file('hamlet.txt', 8, 'hamlet_output*.txt')

    8.times do |number|
      assert_equal true, File.exist?("./encoded_files/hamlet_output#{number}.txt")
    end

    parallel_decoder.decode_from_files(8, 'hamlet_output*.txt', 'hamlet_decoded.txt')
    expected = File.read("./original_files/hamlet.txt").downcase
    actual = File.read("./decoded_files/hamlet_decoded.txt")

    assert_equal expected, actual
  end

  def test_edge_case_of_more_encoders_and_decoders_than_characters_in_file
    parallel_encoder = ParaMorse::ParallelEncoder.new
    parallel_decoder = ParaMorse::ParallelDecoder.new
    parallel_encoder.encode_from_file('small_file.txt', 15, 'small_output*.txt')
    parallel_decoder.decode_from_files(15, 'small_output*.txt', 'small_decoded.txt')
    expected = File.read("./original_files/small_file.txt").downcase
    actual = File.read("./decoded_files/small_decoded.txt")

    assert_equal expected, actual
  end
end

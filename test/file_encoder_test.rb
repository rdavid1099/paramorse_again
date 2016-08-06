require "./lib/file_encoder"
require "./test/test_helper"

class TestFileEncoder < Minitest::Test
  def test_file_encoder_exists
    file_enc = ParaMorse::FileEncoder.new

    assert_instance_of ParaMorse::FileEncoder, file_enc
  end

  def test_file_encoder_writes_files
    file_enc = ParaMorse::FileEncoder.new
    file_enc.write_file("test_encoded.txt", "test")

    assert_equal true, File.exist?("./encoded_files/test_encoded.txt")
    file_enc.encode("test_plain.txt", "test_encoded.txt")
  end

  def test_file_encoder_can_receive_name_of_original_file_and_name_of_new_file
    file_enc = ParaMorse::FileEncoder.new

    assert file_enc.encode("test_plain.txt", "test_encoded.txt")
  end

  def test_file_encoder_saves_file_by_filename_given
    file_enc = ParaMorse::FileEncoder.new
    file_enc.encode("test_plain.txt", "test_encoded.txt")

    assert_equal true, File.exist?("./encoded_files/test_encoded.txt")
  end

  def test_file_encoder_reads_filename_given
    file_enc = ParaMorse::FileEncoder.new
    original_filename = "test_plain.txt"
    expected = "This is a test file.  If you have found this, then you have found the test file.\nCongratulations!  You get to see how I am testing grammar... new lines... and\nall those cr@zy character$ that mäkēs the english language so unique.\n\nI think that I will need more lines... so, here are some of my favorite bands:\n- MeTaLlIcA\n- Rise Against\n- Pink Floyd\n- Trampled By Turtles\n- Led Zeppelin\n\nRock on you guys... shine on you crazy diamonds.\n"
    actual = file_enc.read_file_to_be_encoded(original_filename)

    assert_equal expected, actual
  end

  def test_file_encoder_encodes_contents_of_given_filename
    file_enc = ParaMorse::FileEncoder.new
    original_filename = "test_plain.txt"
    actual = file_enc.encode_file_contents(original_filename)
    expected = "1110001010101000101000101010000000"

    assert_equal expected, actual[0..33]
  end

  def test_file_encoder_writes_encoded_contents_to_given_filename
    file_enc = ParaMorse::FileEncoder.new
    file_enc.encode("test_plain.txt", "test_encoded.txt")
    expected = "1110001010101000101000101010000000"

    assert_equal true, File.exist?("./encoded_files/test_encoded.txt")
    assert_equal expected, File.read("./encoded_files/test_encoded.txt")[0..33]
  end

  def test_file_encoder_returns_length_of_the_written_file
    file_enc = ParaMorse::FileEncoder.new

    assert_kind_of Integer, file_enc.encode("test_plain.txt", "test_encoded.txt")
    assert_equal true, file_enc.encode("test_plain.txt", "test_encoded.txt") > 100
  end
end

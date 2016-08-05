require "./lib/translator"
require "./test/test_helper"

class TestTranslator < Minitest::Test
  include Translator
  def test_translator_converts_english_letters_to_morse
    assert_equal "10111",         eng_to_morse_translator["a"]
    assert_equal "1",             eng_to_morse_translator["e"]
    assert_equal "1110111010111", eng_to_morse_translator["q"]
  end

  def test_translator_converts_morse_to_english
    assert_equal "b", morse_to_eng_translator["111010101"]
    assert_equal "h", morse_to_eng_translator["1010101"]
    assert_equal "l", morse_to_eng_translator["101110101"]
  end

end

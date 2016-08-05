module Translator
  def eng_to_morse_translator
    {
      "a" => "10111",
      "b" => "111010101",
      "c" => "11101011101",
      "d" => "1110101",
      "e" => "1",
      "f" => "101011101",
      "g" => "111011101",
      "h" => "1010101",
      "i" => "101",
      "j" => "1011101110111",
      "k" => "111010111",
      "l" => "101110101",
      "m" => "1110111",
      "n" => "11101",
      "o" => "11101110111",
      "p" => "10111011101",
      "q" => "1110111010111",
      "r" => "1011101",
      "s" => "10101",
      "t" => "111",
      "u" => "1010111",
      "v" => "101010111",
      "w" => "101110111",
      "x" => "11101010111",
      "y" => "1110101110111",
      "z" => "11101110101",
      " " => "0000000",
      "1" => "10111011101110111",
      "2" => "101011101110111",
      "3" => "1010101110111",
      "4" => "10101010111",
      "5" => "101010101",
      "6" => "11101010101",
      "7" => "1110111010101",
      "8" => "111011101110101",
      "9" => "11101110111011101",
      "0" => "1110111011101110111",
      "." => "10111010111010111",
      "," => "1110111010101110111",
      "?" => "101011101110101",
      ":" => "11101110111010101",
      "'" => "1011101110111011101"
      }
  end

  def morse_to_eng_translator
    {
     "10111"=>"a",
     "111010101"=>"b",
     "11101011101"=>"c",
     "1110101"=>"d",
     "1"=>"e",
     "101011101"=>"f",
     "111011101"=>"g",
     "1010101"=>"h",
     "101"=>"i",
     "1011101110111"=>"j",
     "111010111"=>"k",
     "101110101"=>"l",
     "1110111"=>"m",
     "11101"=>"n",
     "11101110111"=>"o",
     "10111011101"=>"p",
     "1110111010111"=>"q",
     "1011101"=>"r",
     "10101"=>"s",
     "111"=>"t",
     "1010111"=>"u",
     "101010111"=>"v",
     "101110111"=>"w",
     "11101010111"=>"x",
     "1110101110111"=>"y",
     "11101110101"=>"z",
     "0000000"=>" ",
     "10111011101110111"=>"1",
     "101011101110111"=>"2",
     "1010101110111"=>"3",
     "10101010111"=>"4",
     "101010101"=>"5",
     "11101010101"=>"6",
     "1110111010101"=>"7",
     "111011101110101"=>"8",
     "11101110111011101"=>"9",
     "1110111011101110111"=>"0",
     "10111010111010111" => ".",
     "1110111010101110111" => ",",
     "101011101110101" => "?",
     "11101110111010101" => ":",
     "1011101110111011101" => "'"
   }
  end
end

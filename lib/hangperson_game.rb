class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  def initialize(word)
    @word = word
    self.guesses = ''
    self.wrong_guesses = ''
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def word_with_guesses
    copy = self.word.dup
    if(self.guesses.length.zero?)
      copy.gsub!(/[a-z]/,'-')
    else
      copy.split('').each_with_index do |word_letter, index|
        copy[index] = '-' unless self.guesses.include? word_letter
      end
    end
    copy #+ self.word
  end

  def guess(letter)
    raise ArgumentError.new("Guess cannot be empty") if letter.equal?('') || letter.nil?
    raise ArgumentError.new("Guess must be a letter") unless letter.match(/^[A-z]/)

    letter.downcase!
    return false unless (!self.guesses.include? letter) && (!self.wrong_guesses.include? letter)
    if @word.include? letter
      self.guesses << letter
    else
      self.wrong_guesses << letter
    end
    true
  end

  def check_win_or_lose
    if self.word_with_guesses.include? '-'
      if(wrong_guesses.length > 6)
        return :lose
      else
        return :play
      end
    else
      :win
    end
  end
end

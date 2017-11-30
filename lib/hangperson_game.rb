class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_reader :word
  attr_reader :guesses
  attr_reader :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
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
  
  def guess(letter)
    #letter = letter.to_s[0]
    if letter != '' and letter != nil and letter =~ /[[:alpha:]]/
      letter.downcase!
      if @guesses.include? letter or @wrong_guesses.include? letter
        return false
      elsif @word.include? letter
        @guesses = @guesses + letter
        return true
      else
        @wrong_guesses = @wrong_guesses + letter
        return true
      end
    else
      raise ArgumentError
    end
    #return false
  end
  
  def word_with_guesses
    display = ''
    @word.split("").each{|e|
      if @guesses.include? e
        display = display + e
      else 
        display = display + "-"
      end
    }
    return display
  end  
  
  def check_win_or_lose
    gword = self.word_with_guesses
    if gword == @word
      return :win
    elsif @wrong_guesses.length == 7
      return :lose
    else 
      return :play
    end
  end
end

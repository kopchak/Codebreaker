require '../lib/codebreaker/game'

class Interface
  include Codebreaker

  def new_game
    get_player_name
    get_attempts_quantity
    @game = Game.new(@player_name, @attempts_quantity)
  end

  def get_player_name
    p 'Welcome! Please enter your name: '
    @player_name = gets.chomp
    get_player_name if @player_name.empty?
  end

  def get_attempts_quantity
    p 'Please enter attempts quantity: '
    @attempts_quantity = gets.to_i
    get_attempts_quantity if @attempts_quantity.zero?
  end

  def get_player_input
    p "Please enter the 4 digits from 1 to 6 or 'hint': "
    @user_input = gets.chomp
  end

  def display_game_over
    p 'Game over!' if @game.lose?
  end

  def display_you_win
    p 'You win!' if @game.victory?
  end

  def play_again
    p 'You want play again (y/n)? : '
    answer = gets.chomp
    launch if answer == 'y'
  end

  def save_result
    p 'You want save result (y/n)? : '
    answer = gets.chomp
    @game.save_result(@player_name, @game.count, @game.player_arr) if answer == 'y'
  end

  def try
    loop do
      get_player_input
      if @user_input == 'hint'
        result = @game.check_hint(@user_input)
      else
        result = @game.guess(@user_input)
        break if display_you_win
      end
      result = 'Invalid data' unless result
      break if @game.attempts_quantity == 0
      p result
      p @game
    end
    display_game_over
    save_result
    play_again
  end

  def launch
    interface = Interface.new
    interface.new_game
    interface.try
  end

end

interface = Interface.new
interface.launch
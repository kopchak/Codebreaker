require_relative 'game'

module Codebreaker
  class Interface

    def new_game
      @game = Codebreaker::Game.new(@player_name, @attempts_quantity)
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
      p 'Game over! You lose' if @game.lose? && !@game.victory?
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

    def attempt
      loop do
        get_player_input
        result = @game.guess(@user_input)
        result = 'Invalid data' unless result
        p result
        break if display_you_win
        break if @game.attempts_quantity == 0
      end
      display_game_over
      save_result
      play_again
    end

    def launch
      get_player_name
      get_attempts_quantity
      new_game
      attempt
    end

  end
end
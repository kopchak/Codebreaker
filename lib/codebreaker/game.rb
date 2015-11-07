require_relative 'version'

module Codebreaker
  class Game
    def new_game
      @attempts_quantity = 10
      @player_name = ''
      @player_answer = ''
      @secret_code = []
      @player_code = []
      @hint = 1
      @count = 0
    end

    def start_game
      new_game
      generate_code!
      p "Secret code: #{@secret_code}"
      get_player_name
      @attempts_quantity.times do |i|
        @count = i+1
        p "Attempt: #{@count}"
        get_player_input!
        check_input
        if valid_data?
          comparison_of_the_values
          if check_for_victory?
            p "Congrats #{@player_name}! You win!"
            break
          end
        else
          p "Invalid data"
        end
      end
      you_lose
      p "#{@player_name} you want the play again (y/n)?"
      @player_answer = gets.chomp
      start_game if @player_answer == 'y'
    end

    def get_player_name
      p "Welcome to the game 'Codebreaker', please enter your name: "
      @player_name = gets.chomp
    end

    def get_player_input!
      p "#{@player_name} please enter four digits between 1 to 6, format: 'xxxx' or input 'hint'"
      @player_code = gets.chomp
    end

    def select_only_digits!
      @player_code = /[1-6]{4}/.match(@player_code).to_s
    end

    def player_input_to_arr!
      @player_code = @player_code.split('').map(&:to_i)
    end

    def generate_code!
      4.times { |i| @secret_code << rand(1..6) }
    end

    def comparison_of_the_values
      tmp_arr = []
      @secret_code.each_index do |i| 
        if @secret_code[i] == @player_code[i]
          tmp_arr << '+'
        elsif @secret_code.include? @player_code[i]
          tmp_arr << '-'
        end
      end
      p tmp_arr
    end

    def you_lose
      p "I'm sorry #{@player_name} you lose" if @count == 10
    end

    def check_input
      if @player_code == 'hint' && @hint == 1
        @hint -= 1
        get_hint
      elsif @player_code == 'hint' && @hint == 0
        p "#{@player_name} you have used a hint!"
      else
        select_only_digits!
        player_input_to_arr!
      end
    end

    def check_for_victory?
      @player_code == @secret_code ? true : false
    end

    def valid_data?
      @player_code.size == @secret_code.size ? true : false
    end

    def get_hint
      hint_arr = ['*','*','*','*']
      random = rand(0..3)
      hint_arr[random] = @secret_code[random]
      p hint_arr
    end

    def save_result
      File.open("#{@player_name}_file.txt", "w") do |file|
        file.write("player name: #{@player_name}, attempts quantity: #{@count}, winning combination: #{@player_code}")
      end
    end
  end

  game = Game.new
  game.start_game
  # game.save_result
end
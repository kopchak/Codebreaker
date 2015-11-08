require_relative 'version'
require_relative 'interface'

module Codebreaker
  class Game
    include Interface
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
      get_player_name
      @attempts_quantity.times do |i|
        @count = i+1
        p_attempt_qantity
        get_player_input!
        check_input
        if valid_data?
          comparison_of_the_values
          if check_for_victory?
            p_you_win
            break
          end
        else
          p_invalid_data
        end
      end
      you_lose
      p_play_again
      @player_answer = gets.chomp
      start_game if @player_answer == 'y'
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
      tmp_secret_arr = Array.new(@secret_code)
      tmp_player_arr = Array.new(@player_code)
      tmp_result_arr = []
      tmp_secret_arr.each_index do |i|
        if tmp_player_arr[i] == tmp_secret_arr[i]
          tmp_result_arr[i] = '+'
          tmp_secret_arr[i] = nil
          tmp_player_arr[i] = nil
        end
      end
      tmp_secret_arr.compact!
      tmp_player_arr.compact!
      tmp_secret_arr.each_index do |i|
        if tmp_secret_arr.include?(tmp_player_arr[i])
          if tmp_result_arr.include?(nil)
            index_of_nil = tmp_result_arr.find_index(nil)
            tmp_result_arr[index_of_nil] = '-'
          else
            if tmp_secret_arr.include?(tmp_player_arr[i])
              index = tmp_secret_arr.find_index(tmp_player_arr[i])
              tmp_secret_arr[index] = nil
              tmp_result_arr << '-'
            end
          end
        end
      end
      tmp_result_arr.compact!
      p tmp_result_arr
    end

    def check_input
      if @player_code == 'hint' && @hint == 1
        @hint -= 1
        get_hint
        get_player_input!
        select_only_digits!
        player_input_to_arr!
      elsif @player_code == 'hint' && @hint == 0
        p_have_used_hint
      else
        select_only_digits!
        player_input_to_arr!
      end
    end

    def check_for_victory?
      @player_code == @secret_code ? true : false
    end

    def valid_data?
      @player_code.is_a?(Array) && @player_code.size == @secret_code.size ? true : false
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
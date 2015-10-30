require '../spec_helper'
 
module Codebreaker
  describe Game do

    let(:game) { Game.new }

    before do
      game.new_game
      game.generate_code!
    end

    context '#player_input_to_arr!' do
      it 'get array from player input' do
        player_code = game.instance_variable_set(:@player_code, '1 1 1 1')
        game.player_input_to_arr!
        expect(player_code) == [1,2,3,4]
      end
    end

    context '#generate_code!' do
      it 'get secret code' do
        expect(:@secret_code).not_to be_empty
      end

      it 'secret code have 4 items' do
        secret_code = game.instance_variable_get(:@secret_code)
        expect(secret_code.size) == 4
      end

      it 'secret code with numbers from 1 to 6' do
        secret_code = game.instance_variable_get(:@secret_code)
        expect("#{secret_code}").to match(/[1-6]+/)
      end
    end

    context '#comparison_of_the_values' do
      it 'all items in tmp array be [- - - -]' do
        game.instance_variable_set(:@player_code, [0,0,0,0])
        game.instance_variable_get(:@secret_code)
        # p "comparison_of_the_values: #{game.comparison_of_the_values}"
        expect(['-','-','-','-']) == game.comparison_of_the_values
      end

      it 'all items in tmp array be [+ + + +]' do
        game.instance_variable_set(:@player_code, [1,1,1,1])
        game.instance_variable_set(:@secret_code, [1,1,1,1])
        # p "comparison_of_the_values: #{game.comparison_of_the_values}"
        expect(['+','+','+','+']) == game.comparison_of_the_values
      end

      it 'in array has items be [+ + - -]' do
        game.instance_variable_set(:@player_code, [1,1,0,0])
        game.instance_variable_set(:@secret_code, [1,1,2,2])
        # p "comparison_of_the_values: #{game.comparison_of_the_values}"
        expect(['+','+','-','-']) == game.comparison_of_the_values
      end
    end

    context '#you_lose' do
      it 'print you_lose when ended the last attempt' do
        game.instance_variable_set(:@count, 10)
        game.instance_variable_set(:@player_code, [0,0,0,0])
        expect("I'm sorry #{@player_name} you lose") == game.you_lose
      end
    end

    context '#play_again' do
      it 'when attempts quantity end' do
        game.instance_variable_set(:@count, 10)
        game.instance_variable_set(:@player_answer, 'y')
        expect(game.start_game) == game.play_again
      end

      # it 'when answer "n" stop game' do
      #   game.instance_variable_set(:@count, 10)
      #   game.instance_variable_set(:@player_answer, 'n')
      #   expect()
      # end
    end

    context '#check_input' do
      it 'if player has hint' do
        game.instance_variable_set(:@player_code, 'hint')
        # game.instance_variable_get(:@hint)
        game.check_input
        expect(:@hint) == 0
      end

      it 'if player not has hint' do
        game.instance_variable_set(:@player_code, 'hint')
        game.instance_variable_set(:@hint, 0)
        game.check_input
        expect("#{@player_name} you have used a hint!") == game.check_input
      end

      it 'player input a sting of digits' do
        game.instance_variable_set(:@player_code, '1 1 1 1')
        game.check_input
        expect([1,1,1,1]) == :@player_code
      end
    end

    context '#check_for_victory' do
      it 'when player win' do
        player_code = game.instance_variable_set(:@player_code, [1,1,1,1])
        secret_code = game.instance_variable_set(:@secret_code, [1,1,1,1])
        game.check_for_victory
        expect(player_code) == secret_code
      end
    end

    context 'valid_data?' do
      it 'expect true player input with secret code' do
        player_code = game.instance_variable_set(:@player_code, [1,1,1,1])
        secret_code = game.instance_variable_get(:@secret_code)
        expect(player_code.size) == secret_code.size
      end

      it 'expect false player input with secret code' do
        player_code = game.instance_variable_set(:@player_code, [1,1,1])
        secret_code = game.instance_variable_get(:@secret_code)
        expect(player_code.size).not_to eq secret_code.size
      end
    end

    # context 'save_result' do
    # end
  end
end

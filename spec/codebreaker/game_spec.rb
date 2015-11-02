require '../spec_helper'
 
module Codebreaker
  describe Game do

    let(:game) { Game.new }

    before do
      game.new_game
      game.generate_code!
    end

    context '#select_only_digits!' do
      it 'get string with letters' do
        game.instance_variable_set(:@player_code, 'aaaa1234aaaa')
        game.select_only_digits!
        player_code = game.instance_variable_get(:@player_code)
        expect(player_code).to eq '1234'
      end
    end

    context '#player_input_to_arr!' do
      it 'get array from player input' do
        game.instance_variable_set(:@player_code, '1234')
        game.player_input_to_arr!
        player_code = game.instance_variable_get(:@player_code)
        expect(player_code).to eq [1,2,3,4]
      end
    end

    context '#generate_code!' do
      it 'get secret code' do
        expect(:@secret_code).not_to be_empty
      end

      it 'secret code have 4 items' do
        secret_code = game.instance_variable_get(:@secret_code)
        expect(secret_code.size).to eq 4
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
        expect(['-','-','-','-']).to eq game.comparison_of_the_values
      end

      it 'all items in tmp array be [+ + + +]' do
        game.instance_variable_set(:@player_code, [1,1,1,1])
        game.instance_variable_set(:@secret_code, [1,1,1,1])
        expect(['+','+','+','+']).to eq game.comparison_of_the_values
      end

      it 'in array has items be [+ + - -]' do
        game.instance_variable_set(:@player_code, [1,1,0,0])
        game.instance_variable_set(:@secret_code, [1,1,2,2])
        expect(['+','+','-','-']).to eq game.comparison_of_the_values
      end
    end

    context '#you_lose' do
      it 'print you_lose when ended the last attempt' do
        game.instance_variable_set(:@player_name, 'den')
        game.instance_variable_set(:@count, 10)
        game.instance_variable_set(:@player_code, [0,0,0,0])
        expect(game.you_lose).to eq ("I'm sorry den you lose")
      end
    end

    # context '#play_again' do
    #   it 'when attempts quantity end' do
    #     game.instance_variable_set(:@count, 10)
    #     game.play_again
    #     expect(game.play_again).to eq " you want the play again (y/n)?"
    #   end
    # end

    context '#check_input' do
      it 'if player has hint' do
        game.instance_variable_set(:@player_code, 'hint')
        game.check_input
        hint = game.instance_variable_get(:@hint)
        expect(hint).to eq 0
      end

      it 'if player not has hint' do
        game.instance_variable_set(:@player_code, 'hint')
        game.instance_variable_set(:@hint, 0)
        game.check_input
        expect("#{@player_name} you have used a hint!").to eq game.check_input
      end

      it 'player input a sting of digits' do
        game.instance_variable_set(:@player_code, '1111')
        game.check_input
        player_code = game.instance_variable_get(:@player_code)
        expect(player_code).to eq [1,1,1,1]
      end
    end

    context '#check_for_victory' do
      it 'when player win' do
        player_code = game.instance_variable_set(:@player_code, [1,1,1,1])
        secret_code = game.instance_variable_set(:@secret_code, [1,1,1,1])
        game.check_for_victory
        expect(game.check_for_victory).to eq "Congrats ! You win!"
      end
    end

    context 'valid_data?' do
      it 'expect true player input with secret code' do
        player_code = game.instance_variable_set(:@player_code, [1,1,1,1])
        secret_code = game.instance_variable_get(:@secret_code)
        expect(player_code.size).to eq secret_code.size
      end

      it 'expect false player input with secret code' do
        player_code = game.instance_variable_set(:@player_code, [1,1,1])
        secret_code = game.instance_variable_get(:@secret_code)
        expect(player_code.size).not_to eq secret_code.size
      end
    end
  end
end

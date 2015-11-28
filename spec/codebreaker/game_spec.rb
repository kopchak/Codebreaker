require '../spec_helper'
 
module Codebreaker
  describe Game do
  
  SECRET_CODE_SIZE = 4

  let(:game) { Game.new }

    context '#guess' do

      before { game.instance_variable_set(:@secret_arr, [1,2,3,4]) }

      it { expect(game.guess('aaaaaa')).to eq false }
      it { expect(game.guess('1234')).to eq '++++' }
      it { expect(game.guess('4321')).to eq '----' }

      it 'decreases attempts quantity' do
        SECRET_CODE_SIZE.times { game.guess('1111') }
        attempts_quantity = game.instance_variable_get(:@attempts_quantity)
        expect(attempts_quantity).to eq 6
      end

      it 'count work' do
        SECRET_CODE_SIZE.times { game.guess('1111') }
        count = game.instance_variable_get(:@count)
        expect(count).to eq SECRET_CODE_SIZE
      end

      it 'called method select_only_digits' do
        pending
        expect(game.guess('a1111a')).to receive(:select_only_digits).with('a1111a')
      end

      it 'called method str_to_arr' do
        pending
        game.stub(:str_to_arr).and_return('1111')
        expect(game.guess('a1111a')).to receive(:str_to_arr).with('1111')
      end

      it 'called method valid_data?' do
        pending
        # game.instance_variable_set(:@player_arr, [1,1,1,1])
        expect(game.guess('a1111a')).to receive(:valid_data?).once
      end

      it 'called method compare_of_value' do
        pending
        # game.instance_variable_set(:@player_arr, [1,1,1,1])
        expect(game.guess('a1111a')).to receive(:compare_of_value).with([1,1,1,1])
      end
    end

    context '#select_only_digits' do
      it 'get string without letters' do
        player_str = game.select_only_digits('str1234str')
        expect(player_str).to eq '1234'
      end

      it 'player string have four items' do
        player_str = game.select_only_digits('str1234str')
        expect(player_str.size).to eq SECRET_CODE_SIZE
      end
    end

    context '#str_to_arr' do
      it 'get array from player string' do
        player_arr = game.str_to_arr('1234')
        expect(player_arr).to eq [1,2,3,4]
      end

      it 'array have SECRET_CODE_SIZE items count' do
        player_arr = game.str_to_arr('1234')
        expect(player_arr.size).to eq SECRET_CODE_SIZE
      end
    end

    context '#generate_code!' do
      it 'get secret code' do
        expect(:@secret_arr).not_to be_empty
      end

      it 'secret code have 4 items' do
        secret_code = game.instance_variable_get(:@secret_arr)
        expect(secret_code.size).to eq SECRET_CODE_SIZE
      end

      it 'secret code with numbers from 1 to 6' do
        secret_code = game.instance_variable_get(:@secret_arr)
        expect("#{secret_code}").to match(/[1-6]+/)
      end
    end

    context '#compare_of_value' do

      before { game.instance_variable_set(:@secret_arr, [1,2,3,4]) }

      it 'received empty string' do
        result_str = game.compare_of_value([5,5,5,5])
        expect(result_str).to eq ''
      end

      it 'received string result "+"' do
        result_str = game.compare_of_value([5,5,5,4])
        expect(result_str).to eq '+'
      end

      it 'received string result "++"' do
        result_str = game.compare_of_value([5,5,3,4])
        expect(result_str).to eq '++'
      end

      it 'received string result "+++"' do
        result_str = game.compare_of_value([5,2,3,4])
        expect(result_str).to eq '+++'
      end

      it 'received string result "++++"' do
        result_str = game.compare_of_value([1,2,3,4])
        expect(result_str).to eq '++++'
      end

      it 'received string result "++--"' do
        result_str = game.compare_of_value([2,1,3,4])
        expect(result_str).to eq '++--'
      end

      it 'received string result "+---"' do
        result_str = game.compare_of_value([3,1,2,4])
        expect(result_str).to eq '+---'
      end

      it 'received string result "----"' do
        result_str = game.compare_of_value([4,3,2,1])
        expect(result_str).to eq '----'
      end

      it 'received string result "---"' do
        result_str = game.compare_of_value([4,3,2,5])
        expect(result_str).to eq '---'
      end

      it 'received string result "--"' do
        result_str = game.compare_of_value([4,3,5,5])
        expect(result_str).to eq '--'
      end

      it 'received string result "-"' do
        result_str = game.compare_of_value([4,5,5,5])
        expect(result_str).to eq '-'
      end
    end

    context '#check_hint' do
      it 'player have 1 hint ' do
        hint_quantity = game.instance_variable_get(:@hint_quantity)
        expect(hint_quantity).to eq 1
      end

      it 'return 0 if player has been used "hint"' do
        game.check_hint
        hint_quantity = game.instance_variable_get(:@hint_quantity)
        expect(hint_quantity).to eq 0
      end

      it 'return false if hint quantity eq 0' do
        game.instance_variable_set(:@hint_quantity, 0)
        expect(game.check_hint).to eq false
      end
    end

    context '#victory?' do

      before { game.instance_variable_set(:@secret_arr, [1,2,3,4]) }

      it 'return true if player_arr eq secret_arr' do
        game.instance_variable_set(:@player_arr, [1,2,3,4])
        expect(game.victory?).to eq true
      end

      it 'return false if player_arr not eq secret_arr' do
        game.instance_variable_set(:@player_arr, [1,1,1,1])
        expect(game.victory?).to eq false
      end
    end

    context '#lose?' do
      it 'return true if attempts count eq 0' do
        game.stub(:victory?).and_return(false)
        game.instance_variable_set(:@attempts_quantity, 0)
        expect(game.lose?).to eq true
      end

      it 'return false if attempts count eq 5' do
        game.instance_variable_set(:@attempts_quantity, 5)
        expect(game.lose?).to eq false
      end
    end

    context '#valid_data?' do
      it 'return true if player input eq array and size = 4' do
        game.instance_variable_set(:@player_arr, [1,1,1,1])
        expect(game.valid_data?).to eq true
      end

      it 'return false if player input eq array and size = 3' do
        game.instance_variable_set(:@player_arr, [1,1,1])
        expect(game.valid_data?).to eq false
      end

      it 'return false if player input eq string and size = 4' do
        game.instance_variable_set(:@player_arr, 'aaaa')
        expect(game.valid_data?).to eq false
      end
    end

    context '#save_result' do
      it 'exist file if save result' do
        game.save_result(:@player_name, :@count, :@player_arr)
        expect(File.exist?("#{:@player_name}_file.txt")).to eq true
      end

      it 'not exist file if save result' do
        game.save_result(:@player_name, :@count, :@player_arr)
        expect(File.exist?("#{:@player_name}")).to eq false
      end
    end
  end
end

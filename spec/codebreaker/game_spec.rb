require '../spec_helper'
 
module Codebreaker
  describe Game do

  let(:game) { Game.new }

    context '#guess' do

      before { game.instance_variable_set(:@secret_arr, [1,2,3,4]) }

      it { expect(game.guess('aaaa')).to eq nil }
      it { expect(game.guess('1234')).to eq '++++' }
      it { expect(game.guess('4321')).to eq '----' }

      it 'count work' do
        5.times { game.guess('aaaa') }
        count = game.instance_variable_get(:@count)
        expect(count).to eq 5
      end
    end

    context '#select_only_digits' do
      it 'get string without letters' do
        game.select_only_digits('str1234str')
        player_str = game.instance_variable_get(:@player_str)
        expect(player_str).to eq '1234'
      end

      it 'player string have four items' do
        game.select_only_digits('str1234str')
        player_str = game.instance_variable_get(:@player_str)
        expect(player_str.size).to eq 4
      end

      it 'player string with numbers from 1 to 6' do
        game.select_only_digits('str12348888str')
        player_str = game.instance_variable_get(:@player_str)
        expect(player_str).to match(/[1-6]+/)
      end
    end

    context '#str_to_arr' do
      it 'get array from player string' do
        game.str_to_arr('1234')
        player_arr = game.instance_variable_get(:@player_arr)
        expect(player_arr).to eq [1,2,3,4]
      end
    end

    context '#generate_code!' do
      it 'get secret code' do
        expect(:@secret_arr).not_to be_empty
      end

      it 'secret code have 4 items' do
        secret_code = game.instance_variable_get(:@secret_arr)
        expect(secret_code.size).to eq 4
      end

      it 'secret code with numbers from 1 to 6' do
        secret_code = game.instance_variable_get(:@secret_arr)
        expect("#{secret_code}").to match(/[1-6]+/)
      end
    end

    context '#compare_of_value' do

      before { game.instance_variable_set(:@secret_arr, [1,2,3,4]) }

      it 'received empty string' do
        game.compare_of_value([5,5,5,5])
        result_str = game.instance_variable_get(:@result_str)
        expect(result_str).to eq ''
      end

      it 'received string result "+"' do
        game.compare_of_value([5,5,5,4])
        result_str = game.instance_variable_get(:@result_str)
        expect(result_str).to eq '+'
      end

      it 'received string result "++"' do
        game.compare_of_value([5,5,3,4])
        result_str = game.instance_variable_get(:@result_str)
        expect(result_str).to eq '++'
      end

      it 'received string result "+++"' do
        game.compare_of_value([5,2,3,4])
        result_str = game.instance_variable_get(:@result_str)
        expect(result_str).to eq '+++'
      end

      it 'received string result "++++"' do
        game.compare_of_value([1,2,3,4])
        result_str = game.instance_variable_get(:@result_str)
        expect(result_str).to eq '++++'
      end

      it 'received string result "++--"' do
        game.compare_of_value([2,1,3,4])
        result_str = game.instance_variable_get(:@result_str)
        expect(result_str).to eq '++--'
      end

      it 'received string result "+---"' do
        game.compare_of_value([3,1,2,4])
        result_str = game.instance_variable_get(:@result_str)
        expect(result_str).to eq '+---'
      end

      it 'received string result "----"' do
        game.compare_of_value([4,3,2,1])
        result_str = game.instance_variable_get(:@result_str)
        expect(result_str).to eq '----'
      end

      it 'received string result "----"' do
        game.compare_of_value([4,3,2,1])
        result_str = game.instance_variable_get(:@result_str)
        expect(result_str).to eq '----'
      end

      it 'received string result "---"' do
        game.compare_of_value([4,3,2,5])
        result_str = game.instance_variable_get(:@result_str)
        expect(result_str).to eq '---'
      end

      it 'received string result "--"' do
        game.compare_of_value([4,3,5,5])
        result_str = game.instance_variable_get(:@result_str)
        expect(result_str).to eq '--'
      end

      it 'received string result "-"' do
        game.compare_of_value([4,5,5,5])
        result_str = game.instance_variable_get(:@result_str)
        expect(result_str).to eq '-'
      end
    end

    context '#check_hint' do
      it 'player have 1 hint ' do
        hint_quantity = game.instance_variable_get(:@hint_quantity)
        expect(hint_quantity).to eq 1
      end

      it 'return 0 if player has been used "hint"' do
        game.check_hint('hint')
        hint_quantity = game.instance_variable_get(:@hint_quantity)
        expect(hint_quantity).to eq 0
      end

      it 'return false if hint quantity eq 0' do
        game.instance_variable_set(:@hint_quantity, 0)
        expect(game.check_hint('hint')).to eq false
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
        expect(File.exist?("#{@player_name}_file.txt")).to eq true
      end

      it 'not exist file if save result' do
        game.save_result(:@player_name, :@count, :@player_arr)
        expect(File.exist?("#{@player_name}")).to eq false
      end
    end
  end
end

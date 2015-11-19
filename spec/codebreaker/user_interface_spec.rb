require '../spec_helper'

module Codebreaker
  describe Interface do

    before do 
      interface.instance_variable_set(:@game, game)
    end

    let(:interface) { Codebreaker::Interface.new }
    let(:game) { Codebreaker::Game.new('d', 1) }

    context '#new_game' do
      it 'exist @game, and owned to Codebreaker::Game' do
        interface.new_game
        game = interface.instance_variable_get(:@game)
        expect(game).to be_a(Game)
      end
    end

    context '#get_player_name' do
      it 'received the message to enter the name' do
        interface.stub(:gets).and_return('den')
        expect(interface).to receive(:p).with("Welcome! Please enter your name: ")
        interface.get_player_name
      end
    end

    context '#get_attempts_quantity' do
      it 'received the message to enter attempts quantity' do
        interface.stub(:gets).and_return(10)
        expect(interface).to receive(:p).with("Please enter attempts quantity: ")
        interface.get_attempts_quantity
      end
    end

    context '#get_player_input' do
      it 'received the message to user input' do
        interface.stub(:gets).and_return('1234')
        expect(interface).to receive(:p).with("Please enter the 4 digits from 1 to 6 or 'hint': ")
        interface.get_player_input
      end
    end

    context '#display_game_over' do
      it 'received message "Game over! You lose"' do
        game.stub(:lose?).and_return(true)
        game.stub(:victory?).and_return(false)
        expect(interface.display_game_over).to eq 'Game over! You lose'
      end
    end

    context '#display_you_win' do
      it 'received the message you win' do
        game.stub(:victory?).and_return(true)
        expect(interface.display_you_win).to eq "You win!"
      end
    end

    context '#play_again' do
      it 'received the message to play again' do
        expect(interface).to receive(:p).with("You want play again (y/n)? : ")
        interface.play_again
      end
    end

    context '#save_result' do
      it 'received the message to save result' do
        expect(interface).to receive(:p).with("You want save result (y/n)? : ")
        interface.save_result
      end
    end

    context '#attempt' do
      before {
        game.stub(:lose?).and_return(false)
        interface.stub(:save_result).and_return('n')
        interface.stub(:play_again).and_return('n')
      }

      it 'received the message to "Invalid data"' do
        interface.stub(:get_player_input).and_return('aaaaaa')
        expect(interface).to receive(:p).with("Invalid data")
        interface.attempt
      end

      it 'received the message to get hint' do
        game.stub(:check_hint).and_return('*2**')
        interface.stub(:get_player_input).and_return('hint')
        interface.instance_variable_set(:@user_input, 'hint')
        expect(interface).to receive(:p).with("*2**")
        interface.attempt
      end
    end

  end
end
module Interface
  def p_attempt_qantity
    p "Attempt: #{@count}"
  end

  def p_you_win
    p "Congrats #{@player_name}! You win!"
  end

  def p_invalid_data
    p "Invalid data"
  end

  def p_play_again
    p "#{@player_name} you want the play again (y/n)?"
  end

  def p_have_used_hint
    p "#{@player_name} you have used a hint!"
  end

  def get_player_name
    p "Welcome to the game 'Codebreaker', please enter your name: "
    @player_name = gets.chomp
  end

  def get_player_input!
    p "#{@player_name} please enter four digits between 1 to 6, format: 'xxxx' or input 'hint'"
    @player_code = gets.chomp
  end

  def you_lose
    p "I'm sorry #{@player_name} you lose" if @count == 10
  end
end
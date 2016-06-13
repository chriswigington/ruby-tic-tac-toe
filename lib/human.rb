class Human
  # Humans have names!
  attr_accessor :name

  # Human takes turn when passed a board
  def take_turn(board, player)
    input = gets.strip
    if board.valid_move?(input)
      board.move(input, player)
    else
      puts "Please enter valid move:"
      take_turn(board, player)
    end
    board.display
  end
end
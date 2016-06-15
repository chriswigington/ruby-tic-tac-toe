class Human
  # Humans have names!
  attr_accessor :name, :player
  attr_reader :board

  def initialize(board)
    @board = board
  end

  # Human takes turn when passed a board
  def take_turn
    puts "#{player.name}'s turn. Enter 0-9:"
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
class Computer
  attr_accessor :name
  # Computer is just named computer
  def initialize
    @name = "Computer"
  end
  # Computer takes turn when passed a board
  def take_turn(board, player)
    input = Random.rand(9)
    if board.valid_move?(input)
      board.move(input, player)
    else
      take_turn(board, player)
    end
    board.display
  end
end
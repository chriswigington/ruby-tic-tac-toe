class Board
  # attribute accessors and readers
  attr_reader :grid

  def initialize
    clear
  end

  # establish winning combinations
    WIN_COMBINATIONS = [
    [0,1,2], # top row
    [0,3,6], # first column
    [0,4,8], # down diagonal
    [1,4,7], # middle column
    [6,4,2], # up diagonal
    [2,5,8], # last column
    [3,4,5], # middle row
    [6,7,8]  # bottom row
  ]

  def clear
    @grid = Array.new(9)
  end

  def marks
    grid.map do |spot|
      if spot.nil?
        " "
      else
        spot.mark
      end
    end
  end

  def display
    puts " #{marks[0]} | #{marks[1]} | #{marks[2]} "
    puts "-----------"
    puts " #{marks[3]} | #{marks[4]} | #{marks[5]} "
    puts "-----------"
    puts " #{marks[6]} | #{marks[7]} | #{marks[8]} "
  end

  def turn_count
    which_turn = 0
    @grid.each do |spot|
      if !spot.nil?
        which_turn += 1
      end
    end
    which_turn 
  end

  def position_taken?(position)
    !(@grid[position].nil? || @grid[position] == " ")
  end

  def valid_move?(position)
    position.to_i.between?(0,8) && !position_taken?(position.to_i)
  end

  def won?
    WIN_COMBINATIONS.detect do |combo|
      x_win = marks[combo[0]] == "X" && marks[combo[1]] == "X" && marks[combo[2]] == "X"
      y_win = marks[combo[0]] == "O" && marks[combo[1]] == "O" && marks[combo[2]] == "O"
      x_win || y_win
    end
  end

  def full?
    grid.none? do |location|
      location == nil
    end
  end

  def draw?
    won? == nil && full?
  end

  def over?
    won? || full?
  end

  def winner
    if won?
      grid[won?[0]]
    else
      nil
    end
  end

  def move(location, current_player)
    @grid[location.to_i] = current_player
  end
end
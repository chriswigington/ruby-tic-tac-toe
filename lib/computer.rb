class Computer
  attr_accessor :name, :player
  attr_reader :move_methods, :board

  # Name computer "Computer" and set difficulty
  def initialize(board)
    @name = "Computer"
    @move_methods = [:winning_move, :block_win, :fork_move, :empty_center, :empty_corner, :empty_side]
    @board = board
  end

  # Computer takes turn when passed a board
  def take_turn
    puts "#{player.name}'s turn."
    input = make_smart_move
    if board.valid_move?(input)
      board.move(input, player)
    else
      take_turn
    end
    board.display
  end

  ## Choose the right move to make

  # Find the move that returns a value
  def find_correct_method
    move_methods.find do |method|
      send(method)
    end
  end

  # Return the position that works
  def make_smart_move
    send(find_correct_method)
  end

  ## HELPER METHODS

  # original winning_move method
  # def winning_move(board)
  #   # puts "DEBUG: running #winning_move"
  #   position = nil
  #   # iterate through the winning combinations
  #   Board::WIN_COMBINATIONS.each do |combo|
  #     mark_count = 0
  #     nil_count = 0
  #     nil_spot = nil
  #     # iterate through the values of the specific combination
  #     combo.each do |spot|
  #       if board.grid[spot] == player
  #         mark_count += 1
  #       elsif board.grid[spot] == nil
  #         nil_count += 1
  #         nil_spot = spot
  #       end
  #     end
  #     # if you have two marks in a row and the other spot is empty
  #     if mark_count == 2 && nil_count == 1
  #       position = nil_spot
  #     end
  #   end
  #   # return the winning move or nil
  #   position
  # end

  # refactored winning_move method
  def winning_move
    # puts "DEBUG: running #winning_move"
    position = nil
    Board::WIN_COMBINATIONS.each do |combo|
      position ||= two_marks_in_a_row(count_marks_and_nils(combo))
    end
    position
  end

  # refactored block_win method
  def block_win
    # puts "DEBUG: running #block_win"
    position = nil
    Board::WIN_COMBINATIONS.each do |combo|
      position ||= two_marks_in_a_row(count_marks_and_nils(combo, false))
    end
    position
  end

  # two marks in a row and other nil
  def two_marks_in_a_row(hash)
    if hash[:mark_count] == 2 && hash[:nil_count] == 1
      # return integer of index with nil value
      hash[:nil_spot]
    end
  end

  # one mark in a row and other two nil
  def one_mark_in_a_row(hash)
    if hash[:mark_count] == 1 && hash[:nil_count] == 2
      # return array of indices with nil values
      hash[:nil_spots]
    end
  end

  def empty_info_tracker
    {
      mark_count:0,
      mark_indices:[],
      nil_count:0,
      nil_index:nil,
      nil_indices:[]
    }
  end

  # returns three values? array? hash?
  def count_marks_and_nils(combo, is_player=true)
    # check indices in winning combination and return info hash
    combo.each_with_object(empty_info_tracker) do |index, new_hash|
      if board.grid[index].nil?
        new_hash[:nil_count] += 1
        new_hash[:nil_index] = index
        new_hash[:nil_indices] << index
      elsif players_mark?(board.grid[index]) == is_player
        new_hash[:mark_count] += 1
        new_hash[:mark_indices] << index
      end
    end 
  end

  def players_mark?(player_at_index)
    player_at_index == player
  end

  # first attempt at refactoring
  def fork_move
    position = nil
    # iterate through the winning combinations
    Board::WIN_COMBINATIONS.each do |outer_combo|
      # store nil values for inner combo  
      outer_nil_spots = one_mark_in_a_row(count_marks_and_nils(outer_combo))
      if outer_nil_spots
        # iterate through the combinations again for comparison
        Board::WIN_COMBINATIONS.each do |inner_combo|
          # don't compare if it's the same combo
          if inner_combo != outer_combo
            # store nil values for inner combo
            inner_nil_spots = one_mark_in_a_row(count_marks_and_nils(inner_combo))
            position = (outer_nil_spots & inner_nil_spots)[0]
          end
        end
      end      
    end
    #return the fork position or nil
    position
  end

  # hasn't been refactored, needs the logic fixed as well
  # def fork_move
  #   # puts "DEBUG: running #fork_move"
  #   position = nil
  #   # iterate through the winning combinations
  #   Board::WIN_COMBINATIONS.each do |out_combo|
  #     # initiate the variables
  #     mark_count = 0
  #     nil_count = 0
  #     nil_spots = []
  #     # iterate through the combination to count
  #     # marks and nils
  #     out_combo.each do |spot|
  #       if board.grid[spot] == player
  #         mark_count += 1
  #       elsif board.grid[spot] == nil
  #         nil_count += 1
  #         nil_spots << spot
  #       end
  #     end
  #     # check to see if there is one mark and two nils
  #     if mark_count == 1 && nil_count == 2
  #       # iterate through the combinations again for comparison
  #       Board::WIN_COMBINATIONS.each do |in_combo|
  #         # don't compare if it's the same combo
  #         if in_combo != out_combo
  #           # initiate the variables
  #           mark_count_in = 0
  #           nil_count_in = 0
  #           nil_spots_in = []
  #           # iterate through the combination to count
  #           # marks and nils
  #           in_combo.each do |spot|
  #             if board.grid[spot] == player
  #               mark_count_in += 1
  #             elsif board.grid[spot] == nil
  #               nil_count_in += 1
  #               nil_spots_in << spot
  #             end
  #           end
  #           # check to see if there is one mark and two nils
  #           if mark_count_in == 1 && nil_count_in == 2
  #             # compare the two combos and return their
  #             # overlapping value
  #             position = (in_combo & out_combo)[0]
  #           end
  #         end
  #       end
  #     end      
  #   end
  #   #return the fork position or nil
  #   position
  # end

  # haven't worked this one out yet
  def block_fork
    # puts "DEBUG: running #block_fork"
    position = nil
    # iterate through the winning combinations
    Board::WIN_COMBINATIONS.each do |out_combo|
      # check to see if there is one mark and two open spots
      mark_count = 0
      nil_count = 0
      nil_spots = []

        # if there is, iterate through the combinations again for comparison
        Board::WIN_COMBINATIONS.each do |in_combo|
          # compare and find fork
        end
    end
    #return the fork block or nil
    position
  end

  def empty_center
    # puts "DEBUG: running #empty_center"
    if board.valid_move?(Board::CENTER[0])
      Board::CENTER[0]
    end
  end

  def empty_corner
    # puts "DEBUG: running #empty_corner"
    Board::CORNERS.find do |corner|
      board.valid_move?(corner)
    end
  end

  def empty_side
    # puts "DEBUG: running #empty_side"
    Board::SIDES.find do |side|
      board.valid_move?(side)
    end
  end

end
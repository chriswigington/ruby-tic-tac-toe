class Computer
  attr_accessor :name, :player
  attr_reader :move_methods, :board

  # Name computer "Computer" and set difficulty
  def initialize(board)
    @name = "Computer"
    @move_methods = [:winning_move, :block_win, :fork_move, :block_fork, :empty_center, :empty_corner, :empty_side]
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

  ## LOGIC METHODS

  # refactored winning_move method
  def winning_move
    puts "DEBUG: running #winning_move"
    position = nil
    Board::WIN_COMBINATIONS.each do |combo|
      position ||= two_marks_in_a_row(count_marks_and_nils(combo))
    end
    position
  end

  # refactored block_win method
  def block_win
    puts "DEBUG: running #block_win"
    position = nil
    Board::WIN_COMBINATIONS.each do |combo|
      position ||= two_marks_in_a_row(count_marks_and_nils(combo, false))
    end
    position
  end

  # partially refactored fork_move
  def fork_move
    puts "DEBUG: running #fork_move"
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

  # partially refactored block_fork
  def block_fork
    puts "DEBUG: running #block_fork"
    position = nil
    # iterate through the winning combinations
    Board::WIN_COMBINATIONS.each do |outer_combo|
      # store nil values for inner combo  
      outer_nil_spots = one_mark_in_a_row(count_marks_and_nils(outer_combo, false))
      if outer_nil_spots
        # iterate through the combinations again for comparison
        Board::WIN_COMBINATIONS.each do |inner_combo|
          # don't compare if it's the same combo
          if inner_combo != outer_combo
            # store nil values for inner combo
            inner_nil_spots = one_mark_in_a_row(count_marks_and_nils(inner_combo, false))
            position = (outer_nil_spots & inner_nil_spots)[0]
          end
        end
      end      
    end
    #return the fork position or nil
    position
  end

  def empty_center
    puts "DEBUG: running #empty_center"
    if board.valid_move?(Board::CENTER[0])
      Board::CENTER[0]
    end
  end

  def empty_corner
    puts "DEBUG: running #empty_corner"
    Board::CORNERS.find do |corner|
      board.valid_move?(corner)
    end
  end

  def empty_side
    puts "DEBUG: running #empty_side"
    Board::SIDES.find do |side|
      board.valid_move?(side)
    end
  end

  ## HELPER METHODS

  # I could combine mark_count and mark_indices by just using mark_indices.length
  # in those places where mark_count was used. Same for nil_index and nil_indices.
  # I might also be able to just use nil_indices[0] instead of nil_index.
  # Maybe this should actually be an object? I don't really like that idea that 
  # much, but it might be worth it if it were something other than just a hash.
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

  # check to see if a mark is the player's
  def players_mark?(player_at_index)
    player_at_index == player
  end

end
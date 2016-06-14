class TicTacToe

  # Attribute accessors and readers
  attr_reader :board

  # this is the main runner class, which it will stay in until exit
  def run
    # Welcome statement
    puts "Welcome to Tic-Tac-Toe!"

    # Initialize board
    @board = Board.new

    # Run game loop
    game_loop
  end

  # primary game loop
  def game_loop
    while true
      answer = options
      if answer == "X"
        exit_tictactoe
        break
      elsif answer == "L"
        leaderboard
      elsif answer == "N"
        play
      else
        puts "Please enter a valid command"
      end
    end
  end

  # These are our primary menu commands
  def options
    # Enter options for what to do
    puts "Please enter a command:"
    puts "- N: New game"
    puts "- L: Leaderboard"
    puts "- X: Exit"
    gets.chomp
  end

  # Where actual game logic goes
  def play
    # Clear the board for a new game
    board.clear

    # establish players
    ## create player one
    puts "What is your name?"
    name = gets.chomp

    # if the player exists, assign it to Player One
    player_one = Player.players.find do |player|
      player.name == name
    end

    # if it does not exist, create it
    player_one ||= Player.new(Human.new)
    player_one.name ||= name
    player_one.mark = "X"

    ## create player two
    player_two = Player.new(Computer.new)
    player_two.mark = "O"

    # keep taking turns until game is over
    until board.over?
      # whose turn is it?
      player = current_player(player_one, player_two)
      # turn method goes here
      puts "#{player.name}'s turn. Enter 0-9:"
      player.take_turn(board)
      if board.draw?
        puts "Its a draw!"
        player_one.draw
        player_two.draw
        break
      end
    end

    # deliver the results of the game
    # increment the players' win stats
    if board.won?
      # congratulate the winner
      puts "Congratulations #{board.winner.name}!"
      board.winner.won
    end
  end

  # Print out a sorted list of the players and their scores
  def leaderboard
    if Player.players.length == 0
      puts "No games have been played"
    else
      Player.players.each do |player|
        puts "#{player.name}: #{player.wins}"
      end
    end
  end

  def current_player(player_one, player_two)
    if board.turn_count % 2 == 0
      player_one
    else
      player_two
    end
  end

  # issue goodbye message
  def exit_tictactoe
    puts "Play again soon!"
  end
end
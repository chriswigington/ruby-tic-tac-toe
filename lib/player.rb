class Player
  # Only using readers because we'll always want to 
  # set these using a particular method
  attr_reader :wins, :losses, :draws, :agent
  attr_accessor :mark
  @@players = []

  def initialize(agent)
    # Player has zero wins, losses, and draws at start
    @wins = 0
    @losses = 0
    @draws = 0

    # Pass an instance of computer or human to the class
    # so that it can use the appropriate methods
    @agent = agent

    # Add the player to the master list of players if 
    # they're not already present
    @@players << self
  end

  def take_turn(board)
    agent.take_turn(board, self)
    board.display
  end

  def won
    @wins += 1
  end

  def lost
    @losses += 1
  end

  def draw
    @draws += 1
  end

  def self.players
    @@players
  end

  def name=(name)
    @agent.name=(name)
  end

  def name
    @agent.name
  end
end
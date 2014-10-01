require 'fastercsv'
require 'csv'

class Player

  @@players = []

# playerID,  yearID, league, teamID, G, AB, R, H, 2B, 3B, HR, RBI, SB, CS
# accarje01, 2011,   AL,     BAL,    1, 0,  0, 0, 0,  0,  0,  0,   0,  0
  ATTRIBUTES = [:playerID, :yearID, :league, :teamID, :G, :AB, :R, :H, :B2, :B3, :HR, :RBI, :SB, :CS]
  ATTRIBUTES.each { |attribute| attr_accessor attribute }  

  def initialize csv
    raise "Don't use the first line of a CSV file to initialize a player" if csv[ 0 ] == 'playerID'
    raise "The argment to new should be an array of size #{ ATTRIBUTES.size }" unless csv.size == ATTRIBUTES.size
    csv.size.times do |t|
      value = csv[ t ]
      value = '0' if value.nil? 
      send( (ATTRIBUTES[ t ].to_s + '=').to_sym, value )
    end
    @@players << self
  end

  def add csv
    raise "The argment to add should be an array of size #{ ATTRIBUTES.size }" unless csv.size == ATTRIBUTES.size
    player = Player.find csv
    ab = player.AB.to_i
    ab += csv[ 5 ].to_i
    player.AB = ab.to_s 
  end

  def at_bats
    self.AB.to_i 
  end

  def most_improved_batting_average( range )
    100
  end

  def least_improved_batting_average( range )
    20
  end

  def Player.find( csv )
    players = Player.all.select { |player| player.playerID == csv[ 0 ] }
    players[ 0 ]
  end

  def Player.initialize
    csvs = CSV.read( File.expand_path( '../Batting-07-12.csv', __FILE__ ))
    csvs.each do |csv|
      next if csv[0] == 'playerID'
      player = Player.find( csv )
      if player.nil?
        player = Player.new( csv )
        @@players << player unless @@players.include?( player )
      else
        player.add( csv )
      end
    end
  end

  def Player.all
    @@players
  end 

  def eql?(other)
    other.instance_of?(self.class) && self.playerID == other.playerID 
  end

  def ==(other)
    self.eql?(other)
  end

end



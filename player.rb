require 'fastercsv'
require 'csv'

class Player

  @@players = []

  ATTRIBUTES = [:playerID, :yearID, :league, :teamID, :G, :AB, :R, :H, :B2, :B3, :HR, :RBI, :SB, :CS]
  ATTRIBUTES.each { |attribute| attr_accessor attribute }  
# accarje01,2012,AL,CLE,26,0,0,0,0,0,0,0,0,0
# accarje01,2012,AL,OAK,1,,,,,,,,,
# accarje01,2011,AL,BAL,1,0,0,0,0,0,0,0,0,0
# accarje01,2009,AL,TOR,26,0,0,0,0,0,0,0,0,0
# accarje01,2008,AL,TOR,16,,,,,,,,,

  def initialize csv
    raise "Don't use the first line of a CSV file to initialize a player" if csv[ 0 ] == 'playerID'
    csv.size.times do |t|
      value = csv[ t ]
      value = '0' if value.nil? # see empty data above ... TOR,16,,,,,,,,,
      send( (ATTRIBUTES[ t ].to_s + '=').to_sym, value )
    end
  end

  def add csv
    ab = self.AB.to_i
    ab += csv[ 5 ].to_i
    self.AB = ab.to_s 
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
    @@players.each do |player|
      return player if csv[0] == player.playerID
    end
    nil
  end

  def Player.all
    csvs = CSV.read( File.expand_path( '../Batting-07-12.csv', __FILE__ ))
    csvs.each do |csv|
      next if csv[0] == 'playerID'
      player = Player.find( csv )
      if player.nil?
        player = Player.new( csv )
        @@players << player
      else
        player.add( csv )
      end
    end
    @@players 
  end

  def eql?(other)
    other.instance_of?(self.class) && self.playerID == other.playerID 
  end

  def ==(other)
    self.eql?(other)
  end

end



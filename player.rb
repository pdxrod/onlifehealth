require 'fastercsv'
require 'csv'

class Player

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
 
  end

  def Player.all
    csvs = CSV.read( File.expand_path( '../Batting-07-12.csv', __FILE__ ))
    players = []
    csvs.each do |csv|
      next if csv[0] == 'playerID'
      player = Player.find( csv )
      if player.nil?
        player = Player.new( csv )
        players << player
      else
        player.add( csv )
      end
    end
    players
  end

  def eql?(other)
    other.instance_of?(self.class) && self.playerID == other.playerID 
  end

  def ==(other)
    self.eql?(other)
  end

end



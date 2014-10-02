require 'fastercsv'
require 'csv'

class Player

  @@players = {} 

# playerID,  yearID, league, teamID, G, AB, R, H, 2B, 3B, HR, RBI, SB, CS
# accarje01, 2011,   AL,     BAL,    1, 0,  0, 0, 0,  0,  0,  0,   0,  0
# abercre01, 2008,   NL,     HOU,    34,55,10,17, 5,  0,  2,  5,   5,  2
# abercre01, 2007,   NL,     FLO,    35,76,16,15, 3,  0,  2,  5,   7,  1
  ATTRIBUTES = {playerID: nil, yearID: nil, league: nil, teamID: nil, G: nil, AB: nil, R: nil, H: nil, B2: nil, B3: nil, HR: nil, RBI: nil, SB: nil, CS: nil}

  attr_accessor :attributes_array

  def initialize csv

# puts "Player initalize: csv is #{csv}" if csv.join( '' ) =~ /accar/

    raise "Don't use the first line of a CSV file to initialize a player" if csv[ 0 ] == 'playerID'
    raise "The argument to new should be an array of size #{ ATTRIBUTES.size }" unless csv.size == ATTRIBUTES.size
    @attributes_array = []
    attributes = ATTRIBUTES.dup
    csv.size.times do |t|
      value = csv[ t ]
      value = value[0..7] if t == 0
      value = '0' if value.nil? 
      attributes[ ATTRIBUTES.keys[ t ] ] = value 
    end
    @attributes_array << attributes
    @@players[ self.playerID ] = self 
    self
  end

  def AB
    sum = 0
    @attributes_array.each do |arr|
      sum += arr[:AB].to_i
    end
    sum 
  end

  def playerID
    @attributes_array[ 0 ][ :playerID ]
  end

  def most_improved_batting_average( range )
    (self.AB > 199 ? 100 : 1)
  end

  def Player.add csv
    raise "The argument to add should be an array of size #{ ATTRIBUTES.size }" unless csv.size == ATTRIBUTES.size
    Player.new csv
  end

  def Player.find csv
    Player.all.each do |playerID, player|
      return player if playerID == csv[ 0 ][ 0..7 ]
    end
    nil
  end

  def Player.initialize
    return unless @@players.empty?
    file = '../Batting-07-12.csv'
    file = "../#{ ENV['FILE'] }" if ENV['FILE']
    csvs = CSV.read( File.expand_path( file, __FILE__ ))
    csvs.each do |csv|
      next if csv[ 0 ] == 'playerID'
      Player.new( csv )
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


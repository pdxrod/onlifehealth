require 'fastercsv'

class Player

# playerID,yearID,league,teamID,G,AB,R,H,2B,3B,HR,RBI,SB,CS
# accarje01,2012,AL,CLE,26,0,0,0,0,0,0,0,0,0
# accarje01,2012,AL,OAK,1,,,,,,,,,
# accarje01,2011,AL,BAL,1,0,0,0,0,0,0,0,0,0
# accarje01,2009,AL,TOR,26,0,0,0,0,0,0,0,0,0
# accarje01,2008,AL,TOR,16,,,,,,,,,


  def initialize csv
puts csv
  end

  def Player.all
    csvs = CSV.read( File.expand_path( '../Batting-07-12.csv', __FILE__ ))
    players = []
    csvs.each do |csv|
      players << Player.new csv
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



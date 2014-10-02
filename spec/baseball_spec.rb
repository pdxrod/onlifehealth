require File.expand_path( '../../player.rb', __FILE__ )

RANGE = ( 2009 .. 2010 )

describe 'baseball' do
  
  context 'basic methods' do

    before do
      Player.initialize
    end

    it 'should not allow duplicates' do
      players = Player.all.collect { |p| p.playerID }
      expect(players.uniq.sort).to eq players.sort
    end  

    it 'include? should work' do
      n = Player.all.size
      csv = ['foobar','2012','AL','CLE','26','2','5','4','0','0','3','2','1','0']
      player = Player.new csv
      expect(Player.all.size).to eq n + 1
      expect(Player.all).to include player 
      player = Player.all[ 2 ]
      expect(player).not_to be_nil
      expect(Player.all).to include player
    end

    it 'should have basic methods' do
      csv = ['foobar01','2012','AL','CLE','26','2','0','0','0','0','0','0','0','0']
      player = Player.new csv
      expect( player.playerID ).to eq 'foobar01'
      expect( player.AB ).to eq 2
      Player.add csv
      player = Player.find csv
      expect( player.AB ).to eq 4
    end

    it 'should have basic baseball methods' do
      players = Player.all
      expect(players.size).to eq 2405 # (cat Batting-07-12.csv | cut -c 1-8 | uniq | wc -l) - 1
      expect(players[0]).not_to eq players[-1]
      players.each do |player|
        expect(player).to respond_to :AB
        expect(player).to respond_to :AB
        expect(player.most_improved_batting_average( RANGE )).not_to be_nil
      end

    end

  end

  context 'improved batting average' do

    before do
      Player.initialize
    end

    it 'should have some players' do
      n = Player.all.size
      expect(n).to be > 2400
      Player.initialize
      expect(n).to eq Player.all.size
    end

    it 'should output the most improved batting average (hits/at-bats) from 2009-2010 for players with at least 200 at-bats' do
      least_improved = Player.all.select{ |player| player.most_improved_batting_average( RANGE ) < 50 }
      at_least_200 = Player.all.select { |player| player.AB > 199 and player.most_improved_batting_average( RANGE ) > 49 } 
      expect(least_improved.size).to be > 0
      expect(at_least_200.size).to be > 0

      at_least_200.each do |winner|
        expect(least_improved).not_to include winner
      end
      
      at_least_200.each do |winner|
        least_improved.each do |loser| 
          expect(winner.most_improved_batting_average( RANGE )).to be > loser.most_improved_batting_average( RANGE )
        end
      end 
    end

  end

end


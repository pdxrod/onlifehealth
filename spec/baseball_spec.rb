require File.expand_path( '../../player.rb', __FILE__ )

RANGE = ( 2009 .. 2010 )

describe 'baseball' do
  
  context 'basic methods' do

    before do
      Player.initialize
    end

    it 'include? should work' do
      n = Player.all.keys.size
      csv = ['foobar12','2011','AL','CLE','26','2','5','4','0','0','3','2','1','0']
      player = Player.new csv
      expect( Player.all.keys.size ).to eq n + 1
      expect( Player.all[ 'foobar12' ] ).to eq player 
      csv = ['foobar12','2012','AL','CLE','26','2','5','4','0','0','3','2','1','0']
      player = Player.new csv
      expect( Player.all.keys.size ).to eq n + 1
      expect( Player.all.keys ).to include 'foobar12'
    end

    it 'should have basic methods' do
      csv = ['foobar01','2012','AL','CLE','26','2','0','0','0','0','0','0','0','0']
      player = Player.new csv
      expect( player.playerID ).to eq 'foobar01'
      expect( player.AB ).to eq 2
      csv = ['foobar01','2013','AL','CLE','26','2','0','0','0','0','0','0','0','0']
      Player.new csv # new doesn't always mean new
      player = Player.find csv
      expect(player.playerID).to eq 'foobar01'
      expect( player.AB ).to eq 4
    end

    it 'should have basic baseball methods' do
      players = Player.all.values
      attributes_size = 1
      players.each do |player|
        attributes_size = player.attributes_array.size if player.attributes_array.size > attributes_size
      end
      expect(attributes_size).to be > 1
      expect(players.size).to eq 2407 # (cat Batting-07-12.csv | cut -c 1-8 | uniq | wc -l) - 1
      expect(players[0]).not_to eq players[-1]
      players.each do |player|
        expect(player).to respond_to :playerID
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
      players = Player.all
      expect(players.class.to_s).to eq 'Hash'
      expect(players.keys[ 11 ].class.to_s).to eq 'String'
      expect(players.values[ 11 ].class.to_s).to eq 'Player'
      n = players.size
      Player.initialize
      expect(n).to eq Player.all.size
    end

    it 'should output the most improved batting average (hits/at-bats) from 2009-2010 for players with at least 200 at-bats' do
      least_improved = Player.all.values.select{ |player| player.most_improved_batting_average( RANGE ) < 50 }
      at_least_200 = Player.all.values.select { |player| player.AB > 199 and player.most_improved_batting_average( RANGE ) > 49 } 
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

  context 'slugging percentage' do

    before do
      Player.initialize
    end

    it "should output the slugging percentage for all players in the Oakland A's in 2007" do

      sp = Player.slugging_percentage( 'OAK', '2007' )
      expect(sp).to be > 0.0

    end

  end
end


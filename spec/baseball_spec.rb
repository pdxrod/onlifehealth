require File.expand_path( '../../player.rb', __FILE__ )

RANGE = ( 2009 .. 2010 )

describe 'baseball' do
  
  context 'basic methods' do

    it 'should have basic methods' do
      csv = ['accarje01','2012','AL','CLE','26','2','0','0','0','0','0','0','0','0']
      player = Player.new csv
      expect( player.playerID ).to eq 'accarje01'
      expect( player.at_bats ).to eq 2
      player = Player.find 'accarje01'
      player.add csv
      expect( player.t_bats ).to eq 4
    end

    it 'should have basic baseball methods' do

      players = Player.all
      expect(players[0]).not_to eq players[-1]
      players.each do |player|
        expect(player).to respond_to :AB
        expect(player).to respond_to :at_bats
        expect(player.least_improved_batting_average( RANGE )).not_to be_nil 
        expect(player.most_improved_batting_average( RANGE )).not_to be_nil
      end

    end

  end

  context 'improved batting average' do

    it 'should output the most improved batting average (hits/at-bats) from 2009-2010 for players with at least 200 at-bats' do
      least_improved = Player.all.select{ |player| player.least_improved_batting_average( RANGE ) > 200 }
      at_least_200 = Player.all.select { |dude| dude.at_bats > 199 } 
      expect(least_improved.size).to be > 0
      expect(at_least_200.size).to be > 0
      at_least_200.each do |winner|
        expect(least_improved.include? winner).to_be false
      end
      
      at_least_200.each do |player|
        least_improved.each do |loser| 
          expect(player.most_improved_batting_average( RANGE )).to be > loser.most_improved_batting_average( RANGE )
        end
      end 
    end

  end

end



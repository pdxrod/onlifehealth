require File.expand_path( '../../player', __FILE__)

describe 'baseball' do

  context 'improved batting average' do

    RANGE = ( 2009 .. 2010 )

    it 'should output the most improved batting average (hits/at-bats) from 2009-2010 for players with at least 200 at-bats' do
      least_improved = Player.all.select{ |player| player.least_improved_batting_average( RANGE ) }
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



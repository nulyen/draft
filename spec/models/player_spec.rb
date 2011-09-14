require 'spec_helper'

describe Player do

  before(:each) do
    @attr = {
      :name => "Darian Durant",
      :position => "QB",
      :first_team => "TB"
    }
  end

  describe "input validations" do
    it "should create a Player with valid attributes" do
      Player.create!(@attr)
    end
  
    it "should require a name" do
      no_name = Player.new(@attr.merge(:name => ""))
      no_name.should_not be_valid
    end
  
    it "should require a position" do
      no_position = Player.new(@attr.merge(:position => ""))
      no_position.should_not be_valid
    end
  
    it "should require a first_team" do
      no_first_team = Player.new(@attr.merge(:first_team => ""))
      no_first_team.should_not be_valid
    end
  
    it 'should allow valid teams' do
      teams = %w(OAK PHI ARI SF NO)
      teams.each do |team|
        player = Player.new(@attr.merge(:first_team => team))
        player.should be_valid
      end
    end
  
    it 'should disallow invalid teams' do
      teams = %w(TBB Oakland Browns NY)
      teams.each do |team|
        player = Player.new(@attr.merge(:first_team => team))
        player.should_not be_valid
      end
    end
  
    it "should accept valid positions" do
      positions=['T', 'G', 'C', 'QB','RB','WR','TE','DE','DT','LB','S','CB','K','P', 'LS']
      positions.each do | position |
        player = Player.new(@attr.merge(:position => position))
        player.should be_valid
      end
    end

    it "should reject invalid positions" do
      positions=['D','RW']
      positions.each do | position |
        player = Player.new(@attr.merge(:position => position))
        player.should_not be_valid
      end
    end
    
    it "should reject duplicate players" do
      Player.create!(@attr)
      player2 = Player.new(@attr)
      player2.should_not be_valid
    end

    it "should allow players with same name but different position" do
      Player.create!(@attr)
      player2 = Player.new(@attr.merge(:position => 'WR'))
      player2.should be_valid
    end
    
    it "should allow players with same name but different first team" do
      Player.create!(@attr)
      player2 = Player.new(@attr.merge(:first_team => 'NYJ'))
      player2.should be_valid
    end
    
    
  end  
  
end

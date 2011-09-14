require 'spec_helper'

describe DraftSelection do

  before (:each) do 
    @player = Factory(:player)
    @attr = Factory.attributes_for(:draft_selection)
  end

  it "should create an instance with valid attributes" do
    @player.create_draft_selection!(@attr)
  end

  describe "player associations" do
    before(:each) do
      @draft = @player.create_draft_selection!(@attr)
    end
  
    it "should have a player attribute" do
      @draft.should respond_to(:player)
    end
    
    it "should have the right associated player" do
      @draft.player_id.should == @player.id
      @draft.player.should == @player
    end
  end  
  
  describe "validations" do
    it "should require a player id" do
      DraftSelection.new(@attr).should_not be_valid
      @attr[:player_id] = 1
      DraftSelection.new(@attr).should be_valid
    end

    describe "team name validation" do
      before (:each) do
        @attr[:player_id] = 1
      end
      
      it 'should allow valid teams' do
        teams = %w(PIT DEN GB SEA TB CLE)
        teams.each do |team|
          @attr[:nfl_team] = team
          DraftSelection.new(@attr).should be_valid
        end
      end
    
      it 'should disallow invalid teams' do
        teams = %w(PI Denver Packers SAN)
        teams.each do |team|
          @attr[:nfl_team] = team
          DraftSelection.new(@attr).should_not be_valid
        end
      end
    end
    
    describe "position validations" do
      before (:each) do
        @attr[:player_id] = 1
      end
      
      it "should accept valid positions" do
        positions=['T','G','C','QB','RB','WR','TE','DE','DT','LB','S','CB','K','P','LS']
        positions.each do | position |
          DraftSelection.new(@attr.merge(:position => position)).should be_valid
        end
      end
  
      it "should reject invalid positions" do
        positions=['D','RW']
        positions.each do | position |
          DraftSelection.new(@attr.merge(:position => position)).should_not be_valid
        end
      end
    end    
  end
  
end

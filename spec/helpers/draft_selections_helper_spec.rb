require 'spec_helper'

describe DraftSelectionHelper do
  class Dummy
  end
  
  before(:each) do
    @dummy = Dummy.new
    @dummy.extend(DraftSelectionHelper)
  end
  
  describe "input correction" do
    it "should fix team names" do
      @dummy.fix_nfl_team("PIT").should == "PIT"
      @dummy.fix_nfl_team("Steelers").should == "PIT"
      @dummy.fix_nfl_team("STEELERS").should == "PIT"
      @dummy.fix_nfl_team("Browns").should == "CLE"
      @dummy.fix_nfl_team("HOIL").should == "TEN"
      @dummy.fix_nfl_team("LARM").should == "STL"
      @dummy.fix_nfl_team("NWE").should == "NE"
    end
    
    it "should return nil for an unfixable name" do
      @dummy.fix_nfl_team("asdf").should == nil
    end
  
  
    it "should fix positions" do
      @dummy.fix_position("RB").should == "RB"
      @dummy.fix_position("HB").should == "RB"
      @dummy.fix_position("TB").should == "RB"
      @dummy.fix_position("B").should == "RB"
      @dummy.fix_position("FS").should == "S"
      @dummy.fix_position("SS").should == "S"
      @dummy.fix_position("NT").should == "DT"
      @dummy.fix_position("DB").should == "CB"
      @dummy.fix_position("E").should == "DE"
    end
    
    it "should return nil for an unfixable position" do
      @dummy.fix_position("asdf").should == nil
    end
  end


  describe "draft row insertion" do
    YEAR = 0
    ROUND = 1
    PICK = 2
    OVERALL_SELECTION = 3
    NAME = 4
    NFL_TEAM = 5
    POSITION = 6
    COLLEGE_TEAM = 7

    describe "valid" do
      before(:each) do
        @rows = [
          '1999,2,3,35,Bob McGee,PIT,QB,Nebraska',
          '1999,2,3,35,Bob McGoo,Steelers,HB,Nebraska',
          '1999,2,3,35,Bob McGii,LARM,FS,Nebraska'
        ]
      end
      
      it "should have no errors with valid rows" do
        errors = @dummy.insert_rows @rows
        errors.size.should == 0
      end
  
      it "should create new Players" do
        expect {
          @dummy.insert_rows @rows
        }.to change(Player, :count).by(3)
      end
      
      it "should create new DraftSelections" do
        expect {
          @dummy.insert_rows @rows
        }.to change(DraftSelection, :count).by(3)
      end
 
    end


    
    describe "incorrect column count" do
      before(:each) do
        @rows = [
          '1999,2,3,35,Bob McGee,PIT,QB',  # one too few
          '1999,2,3,35,Bob McGii,LARM,FS,Nebraska,extracol' # one too many
        ]
      end
      it "should generate an error with incorrect number of columns" do
        errors = @dummy.insert_rows @rows
        errors.size.should == 2
        errors[0].should match /incorrect number of fields/i
        errors[1].should match /incorrect number of fields/i
      end
      
      it "should not create new Players with incorrect number of columns" do
        expect {
          @dummy.insert_rows @rows
        }.to change(Player, :count).by(0)
      end
      
      it "should not create new DraftSelections with incorrect number of columns" do
        expect {
          @dummy.insert_rows @rows
        }.to change(DraftSelection, :count).by(0)
      end
    end    

    describe "invalid position and team" do
      before(:each) do
        @rows = [
          '1999,2,3,35,Bob McGee,Roughriders,QB,Nebraska', 
          '1999,2,3,35,Bob McGii,LARM,CF,Nebraska'
        ]
      end
      it "should generate an error with incorrect position or team" do
        errors = @dummy.insert_rows @rows
        errors.size.should == 2
        errors[0].should match /First team is invalid/i
        errors[1].should match /Position is not included/i
      end
      
      it "should not create new Players with incorrect position or team" do
        expect {
          @dummy.insert_rows @rows
        }.to change(Player, :count).by(0)
      end
      
      it "should not create new DraftSelections with incorrect position or team" do
        expect {
          @dummy.insert_rows @rows
        }.to change(DraftSelection, :count).by(0)
      end
    end    

    describe "duplicate player" do
      before(:each) do
        @rows = [
          '1999,2,3,35,Bob McGee,PIT,FS,Nebraska',
          '2000,1,4,4,Bob McGee,Steelers,SS,Nebraska'
        ]
      end

      it "should create only one Player" do
        expect {
          @dummy.insert_rows @rows
        }.to change(Player, :count).by(1)
      end
      
      it "should create only one DraftSelection" do
        expect {
          @dummy.insert_rows @rows
        }.to change(DraftSelection, :count).by(1)
      end

      it "should create only the first Player" do
        errors = @dummy.insert_rows @rows
        Player.find_by_name('Bob McGee').draft_selection.year.should == 1999
      end
      
      it "should generate an error for the second player" do
        errors = @dummy.insert_rows @rows
        errors.size.should == 1
        errors[0].should match /Name has already been taken/i
      end
      
    end    


  end  

  
end

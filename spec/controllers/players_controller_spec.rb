require 'spec_helper'

describe PlayersController do
  render_views
  
  describe "GET 'index'" do
    
    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(new_user_session_path)
        flash[:alert].should =~ /sign in/i
      end
      
    end
    
    describe "for signed-in users" do
      before(:each) do
        @user = Factory.create(:user)
        sign_in @user
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
     
      it "should say if there are no players to show" do
        get :index
        response.should have_selector("li", :content => "There are no players")
      end
     
    describe "player list" do
      before(:each) do
        player1 = Factory.create(:player)
        player2 = Factory.create(:player, :name => 'Ron Lancaster', :first_team => 'NYJ')
        player3 = Factory.create(:player, :name => 'Danny McManus', :first_team => 'PIT')
        @players = [player1, player2, player3]
      end

      it "should list each player" do
        get :index
        @players.each do |player|
          response.should have_selector("li", :content => player.name)
        end
      end

      it "should link to each player's show page " do
        get :index
        @players.each do |player|
          response.should have_selector("a", :content => player.name,
                                             :href => "/players/#{player.id}")
        end
      end

       
      it "should paginate players" do
        40.times do
          @players << Factory(:player, :name => Factory.next(:name))
        end        
 
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :rel => "next",
                                           :content => "2")
        response.should have_selector("a.next_page", :rel => "next", :content => "Next")
      end
     end
    end
  end

  describe "GET 'show'" do
    before (:each) do |player|
      @player = Factory.create(:player)
    end

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(new_user_session_path)
        flash[:alert].should =~ /sign in/i
      end
      
    end
    
    describe "for signed-in users" do
      before(:each) do
        @user = Factory.create(:user)
        sign_in @user
      end

      it "should be successful" do
        get :show, :id => @player
        response.should be_success
      end
  
      it "should find the right player" do
        get :show, :id => @player
        assigns(:player).should == @player
      end
      
      it "should include the player's name" do
        get :show, :id => @player
        response.should have_selector("h1", :content => @player.name)
      end

    
      describe "draft" do
        it "should show 'undrafted' for non-drafted players" do
          get :show, :id => @player
          response.should have_selector("span", :content => "Undrafted.")
        end
        
        it "should show player's draft info for a drafted player" do
          @attr = Factory.attributes_for(:draft_selection)
          @player.create_draft_selection!(@attr)
          get :show, :id => @player
          response.should have_selector("td", :content => @player.draft_selection.year.to_s)
          response.should have_selector("td", :content => @player.draft_selection.round.to_s)
          response.should have_selector("td", :content => @player.draft_selection.pick.to_s)
          response.should have_selector("td", :content => @player.draft_selection.overall_selection.to_s)
          response.should have_selector("td", :content => @player.draft_selection.nfl_team)
          response.should have_selector("td", :content => @player.draft_selection.college_team)
          response.should have_selector("td", :content => @player.draft_selection.position)
        end            
      end
        
      describe "seasons" do
        it "should show player's season stats"
      end
    end
  end

end

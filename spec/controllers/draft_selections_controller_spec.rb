require 'spec_helper'

describe DraftSelectionsController do
  render_views
  
  describe "GET 'new'" do
    
    describe "for non-signed-in users" do
      it "should deny access" do
        get :new
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
        get :new
        response.should be_success
      end
      
      it "should have a file upload form" do
        get :new
        response.should have_selector("p", :content => 'file to upload')
        response.should have_selector("input", :id => 'draftfile')
        response.should have_selector("input", :type => 'submit')
      end
    end     
  end

  describe "POST 'create'" do
    
    describe "for non-signed-in users" do
      it "should deny access" do
        post :create
        response.should redirect_to(new_user_session_path)
        flash[:alert].should =~ /sign in/i
      end
    end
    
    describe "for signed-in users" do
      before(:each) do
        @user = Factory.create(:user)
        sign_in @user
      end
      
    end     
  end




end

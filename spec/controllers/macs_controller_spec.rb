require 'spec_helper'

describe MacsController do
  render_views

  before do
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:admin_user)

    # Create some test macs
    FactoryGirl.create(:mac, user: @user)
    FactoryGirl.create(:mac, user: @user)
    FactoryGirl.create(:mac, user: @user)
    FactoryGirl.create(:mac, user: @user2)
    FactoryGirl.create(:mac, user: @user2)
    FactoryGirl.create(:mac, user: @user2)
  end

  describe "regular user" do
    before do
      sign_in @user
    end

    describe "index" do
      it "should be success for a signed user and return only the current_user's macs" do
        get :index
        response.should be_success
        assigns(:macs).count.should == 3
      end

      it "should be redirect for a noot signed user" do
        sign_out @user
        get :index
        response.should be_redirect
      end
    end
  end


  describe "admin user" do
    before do
      sign_in @admin
    end

    describe "index" do
      it "should be success and return all the macs" do
        get :index
        response.should be_success
        assigns(:macs).count.should == 6
      end
    end
  end

end

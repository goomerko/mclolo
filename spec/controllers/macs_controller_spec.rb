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

    sign_in @user
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
      sign_out @user
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

  describe "new" do
    it "should render successfully" do
      get :new
      response.should be_success
    end
  end

  describe "create" do
    it "should create a new Mac" do
      post :create, mac: FactoryGirl.build(:mac).attributes
      response.should redirect_to(:macs)
    end

    it "should render new if errors exist" do
      post :create, mac: {mac: 'asdfasdf'}
      response.should render_template('new')
    end
  end

  describe "edit" do
    it "should render successfully" do
      get :edit, id: Mac.first.to_param
      response.should be_success
    end
  end

  describe "update" do
    it "should update a Mac" do
      mac = Mac.first
      new_mac = '11:aa:aa:aa:aa:aa'
      patch :update, id: mac.to_param, mac: mac.attributes.merge({mac:new_mac})
      mac.reload.mac.should == new_mac.upcase
    end

    it "should render edit if errors exist" do
      mac = Mac.first
      patch :update, id: mac.to_param, mac: mac.attributes.merge({mac:'11:aa:aa:aa'})
      response.should render_template('edit')
    end
  end


end

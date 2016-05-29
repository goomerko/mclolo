require "spec_helper"

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

      describe "search" do
        before do
          @admin_user = FactoryGirl.create(:admin_user)
          @mac1 = FactoryGirl.create(:mac, comment: "mac comment")
          @mac2 = FactoryGirl.create(:mac, mac: "00:00:00:00:00:01")
          @mac3 = FactoryGirl.create(:mac, user: FactoryGirl.create(:user, email: "u@u.com"))

          sign_in @admin_user
        end

        it "should filter by comment" do
          get :index, search_term: "comment"

          assigns[:macs].count.should == 1
          assigns[:macs].first.id == @mac1.id
        end

        it "should filter by mac" do
          get :index, search_term: "00:01"

          assigns[:macs].count.should == 1
          assigns[:macs].first.id == @mac2.id
        end

        it "should filter by user's email" do
          get :index, search_term: "u.com"

          assigns[:macs].count.should == 1
          assigns[:macs].first.id == @mac3.id
        end
      end
    end

    describe "update" do
      it "should update the Mac's user" do
        other_user = FactoryGirl.create(:user)
        mac = Mac.first
        patch :update, id: mac.to_param, mac: mac.attributes.merge(user_id: other_user.id)
        mac.reload.user.should == other_user
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
      post :create, mac: { mac: "asdfasdf" }
      response.should render_template("new")
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
      new_mac = "11:aa:aa:aa:aa:aa"
      patch :update, id: mac.to_param, mac: mac.attributes.merge(mac: new_mac)
      mac.reload.mac.should == new_mac.upcase
    end

    it "should render edit if errors exist" do
      mac = Mac.first
      patch :update, id: mac.to_param, mac: mac.attributes.merge(mac: "11:aa:aa:aa")
      response.should render_template("edit")
    end

    it "should not update the Mac's user" do
      other_user = FactoryGirl.create(:user)
      mac = Mac.first
      patch :update, id: mac.to_param, mac: mac.attributes.merge(user_id: other_user.id)
      mac.reload.user.should_not == other_user
    end
  end

  describe "destroy" do
    it "should destroy a mac" do
      previous_mac_counts = @user.macs.count

      delete :destroy, id: @user.macs.first

      @user.macs.count.should == previous_mac_counts - 1
    end
  end

  context "for a manager user" do
    before do
      @manager = FactoryGirl.create(:manager_user)
      @child1 = FactoryGirl.create(:user, parent: @manager)
      @user = FactoryGirl.create(:user)

      # Algunas macs
      FactoryGirl.create(:mac, user: @manager)
      FactoryGirl.create(:mac, user: @manager)
      FactoryGirl.create(:mac, user: @child1)
      FactoryGirl.create(:mac, user: @child1)
      FactoryGirl.create(:mac, user: @user)
      FactoryGirl.create(:mac, user: @user)

      sign_in @manager
    end

    describe "index" do
      it "should show all the children's macs" do
        get :index
        macs = assigns[:macs]
        macs.count.should == 4
      end
    end
  end
end

require 'spec_helper'

describe Admin::UsersController do
  before do
    @user = FactoryGirl.create(:user)
    @user = FactoryGirl.create(:admin_user)
    sign_in @user
  end


  describe "index" do
    it "should render successfully" do
      get :index
      response.should be_success
    end
  end


  describe "new" do
    it "should render successfully" do
      get :new
      response.should be_success
    end
  end

  describe "create" do
    it "should create a new object" do
      expect { post :create, user: FactoryGirl.attributes_for(:user) }.to change(User, :count).by(1)
      response.should be_redirect
      flash[:notice].should be_present
    end

    it "should not create an invalid object" do
      expect {post :create, user: FactoryGirl.attributes_for(:user_invalid) }.to change(User, :count).by(0)
      response.should render_template('new')
    end
  end

  context "with a created user" do
    before do
      @user = FactoryGirl.create(:user)
      @node = FactoryGirl.create(:node)
    end

    describe "edit" do
      it "should render successfully" do
        get :edit, id: FactoryGirl.create(:user).id
        response.should be_success
      end
    end

    describe "update" do
      it "should save changes in an object" do
        new_email = 'newemail@email.com'
        patch :update, id: @user.id, user: {email: new_email}
        response.should be_redirect
        @user.reload.email.should == new_email
      end

      it "should save node_ids changes" do
        patch :update, id: @user.id, user: {node_ids: [@node.id]}
        @user.reload.nodes.count.should == 1
      end

      it "should not save an invalid object" do
        old_email = @user.email
        patch :update, id: @user.id, user: {email: ''}
        response.should be_success
        response.should render_template('edit')
        @user.reload.email.should == old_email
      end
    end

    describe "destroy" do
      it "should destroy the user" do
        expect { delete :destroy, id: @user.id }.to change(User, :count).by(-1)
      end

      it "should do nothing if the user doesn't exist" do
        expect { delete :destroy, id: 101010 }.to change(User, :count).by(0)
        response.status.should == 404
      end
    end
  end

end

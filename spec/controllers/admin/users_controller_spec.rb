require 'spec_helper'

describe Admin::UsersController do
  render_views

  before do
    @node1 = FactoryGirl.create(:node)
    @node2 = FactoryGirl.create(:node)
    @node3 = FactoryGirl.create(:node)

    @user = FactoryGirl.create(:admin_user)
    sign_in @user

    @user1 = FactoryGirl.create(:user, nodes: [@node1])
    @user2 = FactoryGirl.create(:user, nodes: [@node1, @node2])
    @user3 = FactoryGirl.create(:user, nodes: [@node2])
  end


  describe "index" do
    it "should render successfully" do
      get :index
      response.should be_success
    end

    it "should show only the users in a node" do
      get :index, node_id: @node1
      assigns[:users].should include(@user1)
      assigns[:users].should include(@user2)
      assigns[:users].should_not include(@user3)
    end
  end

  describe "new" do
    it "should render successfully" do
      get :new
      response.should be_success
    end

    it "should load all the nodes" do
      get :new
      assigns[:available_nodes].count.should == 3
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

      it "should change the user's parent" do
        new_parent = FactoryGirl.create(:user)
        patch :update, id: @user.id, user: {parent_id: new_parent.id}
        @user.reload.parent.should == new_parent
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


  ##############################################################
  # MANAGER
  ##############################################################

  context "with a manager user" do

    before do
      @user = FactoryGirl.create(:manager_user, nodes: [@node1, @node2])
      FactoryGirl.create(:user, parent: @user)
      FactoryGirl.create(:user, parent: @user)
      sign_in @user
    end

    describe "index" do
      it "should render successfully" do
        get :index
        response.should be_success
      end

      it "should show only the user's children" do
        get :index
        assigns[:users].map(&:id).should == @user.children.map(&:id)
      end
    end


    describe "new" do
      it "should render successfully" do
        get :new
        response.should be_success
      end

      it "should load all the nodes" do
        get :new
        assigns[:available_nodes].count.should == 2
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
        @created_user = FactoryGirl.create(:user)
        @node = FactoryGirl.create(:node)
      end

      describe "edit" do
        it "should render successfully" do
          get :edit, id: @created_user.id
          response.should be_success
        end

      end

      describe "update" do
        it "should save changes in an object" do
          new_email = 'newemail@email.com'
          patch :update, id: @created_user.id, user: {email: new_email}
          response.should be_redirect
          @created_user.reload.email.should == new_email
        end

        it "should save node_ids changes" do
          patch :update, id: @created_user.id, user: {node_ids: [@node.id]}
          @created_user.reload.nodes.count.should == 1
        end

        it "should not set a user as admin" do
          patch :update, id: @created_user.id, user: {admin: true}
          @created_user.reload.admin.should be_false
        end

        it "should not save an invalid object" do
          old_email = @created_user.email
          patch :update, id: @created_user.id, user: {email: ''}
          response.should be_success
          response.should render_template('edit')
          @created_user.reload.email.should == old_email
        end

        it "should not change the user's parent" do
          new_parent = FactoryGirl.create(:user)
          patch :update, id: @user.id, user: {parent_id: new_parent.id}
          @user.reload.parent.should_not == new_parent
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

  ##################################
  # NORMAL USER
  ##################################

  context "with a normal user" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "index" do
      it "should redirect to root path" do
        get :index
        response.should be_redirect
      end
    end
  end

end

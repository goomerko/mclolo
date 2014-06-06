require 'spec_helper'

describe Admin::NodesController do
  before do
    @node = FactoryGirl.create(:node)
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
      expect { post :create, node: FactoryGirl.attributes_for(:node) }.to change(Node, :count).by(1)
      response.should be_redirect
      flash[:notice].should be_present
    end

    it "should not create an invalid object" do
      expect {post :create, node: FactoryGirl.attributes_for(:node_invalid) }.to change(Node, :count).by(0)
      response.should render_template('new')
    end
  end

  context "with a created node" do
    before do
      @node = FactoryGirl.create(:node)
    end

    describe "edit" do
      it "should render successfully" do
        get :edit, id: FactoryGirl.create(:node).id
        response.should be_success
      end
    end

    describe "update" do
      it "should save changes in an object" do
        new_name = 'New name'
        patch :update, id: @node.id, node: {name: new_name}
        response.should be_redirect
        @node.reload.name.should == new_name
      end

      it "should not save an invalid object" do
        old_name = @node.name
        patch :update, id: @node.id, node: {name: ''}
        response.should be_success
        response.should render_template('edit')
        @node.reload.name.should == old_name
      end
    end

    describe "destroy" do
      it "should destroy the node" do
        expect { delete :destroy, id: @node.id }.to change(Node, :count).by(-1)
      end

      it "should do nothing if the node doesn't exist" do
        expect { delete :destroy, id: 101010 }.to change(Node, :count).by(0)
        response.status.should == 404
      end
    end
  end

end

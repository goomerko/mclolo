require "spec_helper"

describe ExportsController do
  render_views

  before do
    @node1 = FactoryGirl.create(:node)
    @node2 = FactoryGirl.create(:node)

    @node_user = FactoryGirl.create(:node_user, nodes: [@node1])

    # Users
    @user1 = FactoryGirl.create(:user, nodes: [@node1])
    @user2 = FactoryGirl.create(:user, nodes: [@node1])
    @user3 = FactoryGirl.create(:user, nodes: [@node2])
    @user4 = FactoryGirl.create(:user, nodes: [@node1], blocked: true)

    # Macs
    @mac1 = FactoryGirl.create(:mac, user: @user1)
    @mac2 = FactoryGirl.create(:mac, user: @user2)
    @mac3 = FactoryGirl.create(:mac, user: @user3)
    @mac4 = FactoryGirl.create(:mac, user: @user1, blocked: true)
    @mac5 = FactoryGirl.create(:mac, user: @user4)

    sign_in @node_user
  end

  it "should return the non-blocked macs for my nodes" do
    get :macs, format: :txt

    macs = assigns[:macs]
    macs.should include(@mac1)
    macs.should include(@mac2)
    macs.should_not include(@mac3)
    macs.should_not include(@mac4)
    macs.should_not include(@mac5)
  end

  it "should return the ip tables format" do
    get :macs, format: :iptables

    macs = assigns[:macs]
    macs.should include(@mac1)
    macs.should include(@mac2)
    macs.should_not include(@mac3)
    macs.should_not include(@mac4)
    macs.should_not include(@mac5)
  end

  it "should include the user's header and footer" do
    @node_user.update_attribute(:header, "current_user_header")
    @node_user.update_attribute(:footer, "current_user_footer")

    get :macs, format: :iptables

    response.body.should include("current_user_header")
    response.body.should include("current_user_footer")
  end
end

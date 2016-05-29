require "spec_helper"

describe User do
  describe "validations" do
  end

  describe "relations" do
    it { should have_many(:macs) }
    it { should have_and_belong_to_many :nodes }
    it { should have_many(:children) }
    it { should belong_to(:parent) }
  end

  describe "available_macs" do
    before do
      @admin = FactoryGirl.create(:admin_user)
      @manager = FactoryGirl.create(:manager_user)
      @user = FactoryGirl.create(:user, parent: @manager)
      @user2 = FactoryGirl.create(:user)

      # Macs
      FactoryGirl.create(:mac, user: @user)
      FactoryGirl.create(:mac, user: @user)
      FactoryGirl.create(:mac, user: @user)
      FactoryGirl.create(:mac, user: @manager)
      FactoryGirl.create(:mac, user: @manager)
      FactoryGirl.create(:mac, user: @user2)
      FactoryGirl.create(:mac, user: @user2)
    end

    it "should return all the macs for an admin user" do
      @admin.available_macs.count.should == 7
    end

    it "should return all the children's macs for a amanger" do
      @manager.available_macs.count.should == 5
    end

    it "should return her macs for a regular user" do
      @user.available_macs.count.should == 3
      @user2.available_macs.count.should == 2
    end
  end
end

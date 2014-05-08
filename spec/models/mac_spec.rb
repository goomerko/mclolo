require 'spec_helper'

describe Mac do
  describe "validations" do
    it { should ensure_length_of(:mac).is_equal_to(17) }
    it { should validate_presence_of(:mac) }

    it do
      FactoryGirl.create(:mac)
      should validate_uniqueness_of(:mac)
    end
  end

  describe "relations" do
    it { should belong_to(:user) }
  end

  describe "convert_scores" do
    it "should replace the - in the mac" do
      mac = Mac.new(mac: 'XX-XX-XX-XX-XX-XX')
      mac.save
      mac.mac.should == 'XX:XX:XX:XX:XX:XX'
    end

  end
end

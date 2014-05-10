require 'spec_helper'

describe Mac do
  describe "validations" do
    it { should ensure_length_of(:mac).is_equal_to(17) }
    it { should validate_presence_of(:mac) }

    it do
      mac = FactoryGirl.create(:mac)
      mac2 = FactoryGirl.build(:mac, mac: mac.mac)
      mac2.should_not be_valid
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

  describe "convert_to_upcase" do
    it "should convert to upcase" do
      mac = Mac.new(mac: "ab:ab:12:ab:12:12")
      mac.save
      mac.mac.should == "AB:AB:12:AB:12:12"
    end
  end
end

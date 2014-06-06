require 'spec_helper'

describe User do

  describe "validations" do
  end

  describe "relations" do
    it { should have_many(:macs) }
    it { should have_and_belong_to_many :nodes }
  end
end

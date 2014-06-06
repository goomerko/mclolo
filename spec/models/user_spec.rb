require 'spec_helper'

describe User do

  describe "validations" do
  end

  describe "relations" do
    it { should have_many(:macs) }
    it { should belong_to :node }
  end
end

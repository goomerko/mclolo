require 'spec_helper'

describe Node do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relations' do
    it { should have_many :users }
    it { should have_many :macs }
  end
end

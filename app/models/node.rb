class Node < ActiveRecord::Base
  validates :name, presence: true

  has_many :users
  has_many :macs

  def self.valid_params(params)
    params.require(:node).permit(:name)
  end
end

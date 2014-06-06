class Node < ActiveRecord::Base
  validates :name, presence: true

  has_and_belongs_to_many :users

  def self.valid_params(params)
    params.require(:node).permit(:name)
  end
end

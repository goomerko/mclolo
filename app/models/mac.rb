class Mac < ActiveRecord::Base
  belongs_to :user

  validates :mac, length: {is: 17}, presence: true, uniqueness: true

  before_validation :convert_scores

  def convert_scores
    self.mac = self.mac.gsub('-', ':')
  end

  def self.valid_params(params)
    params.permit(:mac, :comment)
  end
end

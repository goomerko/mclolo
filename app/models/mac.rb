class Mac < ActiveRecord::Base
  belongs_to :user

  validates :mac, length: {is: 17}, presence: true, uniqueness: true

  before_validation :convert_scores
  before_validation :convert_to_upcase

  def convert_scores
    self.mac = self.mac.gsub('-', ':') if self.mac.present?
  end

  def convert_to_upcase
    self.mac = self.mac.upcase
  end
  def self.valid_params(params)
    params.permit(:mac, :comment, :node, :blocked)
  end

end

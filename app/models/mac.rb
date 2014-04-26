class Mac < ActiveRecord::Base
  belongs_to :user

  validates :mac, length: {is: 17}, presence: true, uniqueness: true

  before_save :convert_scores

  def convert_scores
    self.mac['-'] = ':' if self.mac.include?('-')
  end
end

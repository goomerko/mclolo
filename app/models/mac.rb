class Mac < ActiveRecord::Base
  belongs_to :user

  validates :mac, length: { is: 17 }, presence: true, uniqueness: true

  before_validation :convert_scores
  before_validation :convert_to_upcase

  belongs_to :node

  def convert_scores
    self.mac = mac.tr("-", ":") if mac.present?
  end

  def convert_to_upcase
    self.mac = mac.upcase if mac.present?
  end

  def self.valid_params(params, current_user)
    if current_user.admin?
      params.permit(:mac, :comment, :node, :blocked, :user_id)
    else
      params.permit(:mac, :comment, :node, :blocked)
    end
  end
end

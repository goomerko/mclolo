class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :macs
  has_and_belongs_to_many :nodes

  has_many :children, class_name: "User", foreign_key: :parent_id
  belongs_to :parent, class_name: "User"

  after_create :send_admin_mail

  def self.valid_params(params, current_user)
    if current_user.admin?
      params.require(:user).permit(:email, :blocked, :header, :footer, :iface, :admin, :manager, :node, node_ids: [])
    elsif current_user.manager?
      params.require(:user).permit(:email, :blocked, :manager, node_ids: [])
    end
  end

  def send_admin_mail
    self.send_reset_password_instructions
  end

  def available_macs
    if self.admin?
      Mac.all
    elsif self.manager?
      Mac.where("user_id in (?)", self.children.map(&:id) << self.id)
    else
      self.macs
    end
  end
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable


  has_many :macs
  has_and_belongs_to_many :nodes

  after_create :send_admin_mail

  def self.valid_params(params)
    params.require(:user).permit(:email, :header, :footer, :iface, :admin, :manager, :node, node_ids: [])
  end

  def send_admin_mail
    self.send_reset_password_instructions
  end
end

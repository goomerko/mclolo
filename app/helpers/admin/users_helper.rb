module Admin::UsersHelper

  def admin_text(user)
    if user.admin?
      'Sí'
    else
      'No'
    end
  end

end

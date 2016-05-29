module ApplicationHelper
  def yes_no_text(value)
    if value
      "Sí"
    else
      "No"
    end
  end
end

module ApplicationHelper
  include Pagy::Frontend

  def current_page_name(controller_name)
    controller_name == 'dashboard' ? 'Home' : controller_name.upcase_first
  end

  def active_class_checked(obj, user)
    if (user.gender.blank? && obj.value == 'male') || obj.value == user.gender
      'checked'
    end
  end
end

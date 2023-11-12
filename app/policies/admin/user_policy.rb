class Admin::UserPolicy < RegionPolicy
  def reset_password?
    manage?
  end

  private ##

  def manage?
    manage_region?
  end
end

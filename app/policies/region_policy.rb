class RegionPolicy < ApplicationPolicy
  def manage_region?
    user.region_id == record.region_id
  end
end

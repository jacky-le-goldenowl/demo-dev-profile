class Admin::BaseController < ApplicationController
  before_action :authenticate_user!, :check_admin_access!, :current_region

  layout 'admin'

  private

  def check_admin_access!
    authorize(:gateway, :admin_namespace?)
  end

  def current_region
    @current_region = current_user.region
  end
end

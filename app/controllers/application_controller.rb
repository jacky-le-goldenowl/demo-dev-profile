class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  include Notificationable

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def flash_notice(type, model)
    flash.now[:notice] = t(type, model:)
  end

  def flash_warning(type, model)
    flash.now[:alert] = t(type, model:)
  end

  def generate_html_flash(message, type)
    render_to_string(
      partial: 'shared/flash_custom', layout: false, locals: { message:, type: }
    )
  end

  def render_to_string_html(partial, **options)
    render_to_string(
      partial:, layout: false, locals: options
    )
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[region_id])
  end

  def check_authorize(record, query = nil)
    authorize(record, query, policy_class: "#{controller_path.classify}Policy".constantize)
  end

  private

  def after_sign_in_path_for(resource)
    if resource.has_role?(:admin)
      admin_root_path
    elsif resource.has_role?(:teacher)
      teacher_root_path
    elsif resource.has_role?(:student)
      resource.type == 'User::Student' ? student_root_path : new_student_registration_path
    elsif resource.has_role?(:superadmin)
      owner_root_path
    else
      root_path
    end
  end

  def not_authorized
    flash[:alert] = t('policy.not_authorized')
    redirect_to(request.referer || root_path)
  end
end

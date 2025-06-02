class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters = devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

  def require_admin_or_owner
    redirect_to root_path, alert: '権限がありません。' unless current_user&.admin_or_owner?
  end

  # owner権限
  def require_owner
    redirect_to root_path, alert: 'この操作にはオーナー権限が必要です。' unless current_user&.owner?
  end
end

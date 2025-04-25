class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?


  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { error: exception.message }, status: :forbidden }
    end
  end

  protected
    def configure_permitted_parameters
      # devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
      devise_parameter_sanitizer.permit(:account_update, keys: [ :username, :first_name, :last_name ])
    end
end

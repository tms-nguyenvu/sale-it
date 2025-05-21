class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  rescue_from Exception, with: :handle_exception
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  protected

  def after_sign_in_path_for(resource)
    admin_dashboard_path
  end

  private

  def handle_exception(e)
    Rails.logger.error(e.message)
    Rails.logger.error(e.backtrace.join("\n"))
    Sentry.capture_exception(e) if Rails.env.production?

    respond_to do |format|
      format.html { render file: Rails.root.join("public", "500.html"), status: 500, layout: false }
      format.json { render json: { error: "Internal Server Error" }, status: 500 }
    end
  end

  def handle_not_found(e)
    respond_to do |format|
      format.html { render file: Rails.root.join("public", "404.html"), status: :not_found, layout: false }
      format.json { render json: { error: "Resource not found" }, status: :not_found }
    end
  end

  def handle_access_denied(exception)
    respond_to do |format|
      format.html do
        flash[:alert] = exception.message
        if request.referer
          redirect_back(fallback_location: admin_dashboard_path)
        else
          redirect_to admin_dashboard_path
        end
      end
      format.json { render json: { error: exception.message }, status: :forbidden }
    end
  end
end

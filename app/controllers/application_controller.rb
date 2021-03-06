class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def after_accept_path_for(resource)
    user_path(resource)
  end

  private

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

end

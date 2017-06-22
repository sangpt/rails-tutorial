class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def valid_info object
    render file: "public/404.html" unless object
  end

  private

  def logged_in_user
    return if logged_in?
      store_location
      flash[:danger] = t ".please_log_in"
      redirect_to login_url
  end
end

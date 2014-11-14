class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private
  
   def logged_in_only
      unless logged_in?
        store_forwarding_url
        flash[:danger]="Please log in."
        redirect_to login_url
      end
    end


end

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :prepare_filters

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  private

    def prepare_filters
      session[:filters] = {}
    end
end

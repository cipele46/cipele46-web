class ApplicationController < ActionController::Base
  protect_from_forgery
  responders :json
  before_filter :prepare_filter

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  private

    def prepare_filter
      @ad_filter = AdFilter.new(params)
    end
end

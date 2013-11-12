class UsersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json
  
  def show 
    respond_with current_user  
  end
    
  def update
    current_user.update_attributes(params[:user])
    respond_with current_user
  end    
end

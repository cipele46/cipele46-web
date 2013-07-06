class UsersController < ApplicationController
  before_filter :authenticate_user!

  #def index
  #  authorize! :index, @user, :message => 'Not authorized as an administrator.'
  #  @users = User.all
  #end

  def show
    @user = current_user
    respond_to do |format|
      format.json do 
        render :json => @user
      end
    end
  end
  
  def create
    @user = User.create(params[:user])
    if @user.save
      render :json => {:state => {:code => 0}, :data => @user }
    else
      render :json => {:state => {:code => 1, :messages => @user.errors.full_messages} }
    end
  end

  #def update
  #  authorize! :update, @user, :message => 'Not authorized as an administrator.'
  #  @user = User.find(params[:id])
  #  if @user.update_attributes(params[:user], :as => :admin)
  #    redirect_to users_path, :notice => "User updated."
  #  else
  #    redirect_to users_path, :alert => "Unable to update user."
  #  end
  #end
    
  #def destroy
  #  authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
  #  user = User.find(params[:id])
  #  unless user == current_user
  #    user.destroy
  #    redirect_to users_path, :notice => "User deleted."
  #  else
  #    redirect_to users_path, :notice => "Can't delete yourself."
  #  end
  #end
end
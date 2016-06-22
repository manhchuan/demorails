class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index]
  def new
  	@user = User.new
  end

  def index
    @users =User.paginate(page: params[:page])

  end

  def show 
  	@user = User.find(params[:id])
    @entries = @user.entries.paginate(page: params[:page],per_page: 10)
  end

  def create
   @user = User.new(user_params)
   if @user.save
    log_in @user
    flash[:success]= "Welcome to DemoRails!"
    redirect_to @user
  else
    render 'new'
  end
end
def destroy
  User.find(params[:id].destroy)
  flash[:success] ="User delete"
  redirect_to users_url
end
private

def user_params
  params.require(:user).permit(:name, :email, :password,
   :password_confirmation)
end
end
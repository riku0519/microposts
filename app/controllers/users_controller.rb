class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end
  
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Update Profile"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.following_users
    @title = 'followings'
    render 'show_follow'
  end
  
  def followers
     @user = User.find(params[:id])
    @users = @user.follower_users
    @title = 'follower'
    render 'show_follower'
  end
  
  def favorites
     @user = User.find(params[:id])
     @microposts = @user.favorite_microposts
     @title = 'favorites'
     render 'show_favorite'
  end
  

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile, :birthplace, :password,
                                 :password_confirmation)
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path if @user != current_user
  end
end

  
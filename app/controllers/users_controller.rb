class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def following
    @user = User.find(params[:id])
    @users = @user.following.order(created_at: :desc).page(params[:page])
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.order(created_at: :desc).page(params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end

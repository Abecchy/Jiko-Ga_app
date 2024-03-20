class ProfilesController < ApplicationController
  def show
    @posts = current_user.posts.order(created_at: :desc).page(params[:page])
  end

  def edit
    @user = User.find(current_user.id)
    @pet = @user.pets.build
  end

  def update
    @user = User.find(current_user.id)

    if @user.update(user_params)
      redirect_to profile_path, success: t('defaults.flash_message.updated', item: User.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :avatar, :avatar_cache, pets_attributes: [:id, :name, :age, :gender, :pet_avatar, :pet_avatar_cache, :_destroy])
  end
end

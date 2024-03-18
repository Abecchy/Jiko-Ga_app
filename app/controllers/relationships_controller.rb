class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)

    respond_to do |format|
      format.html { redirect_to users_path, success: t('.success') }
      format.turbo_stream
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)

    respond_to do |format|
      format.html { redirect_to users_path, success: t('.success'), status: :see_other }
      format.turbo_stream
    end
  end
end

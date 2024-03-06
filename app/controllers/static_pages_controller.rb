class StaticPagesController < ApplicationController
  skip_before_action :require_login

  def top
    @new_posts = Post.includes(:user).order(created_at: :desc).limit(3)
  end
end

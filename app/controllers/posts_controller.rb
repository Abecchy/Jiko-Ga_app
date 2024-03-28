class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    post_count = current_user.posts.created_today.count

    if @post.post_image.present? && @post.body.present?
      if post_count < 3
        @post.title = OpenAi.generate_title(@post.body, @post.post_image) if @post.post_image.present? && @post.body.present?
        @post.save
        redirect_to post_path(@post), success: t('defaults.flash_message.created', item: Post.model_name.human)
      else
        redirect_to posts_path, danger: t('defaults.flash_message.limit')
      end
    elsif @post.post_image.blank? && @post.body.blank?
      @post.errors.add(:post_image, 'を選択してください')
      @post.errors.add(:body, 'を入力してください')
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    elsif @post.body.present?
      @post.errors.add(:post_image, 'を選択してください')
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    else
      @post.errors.add(:body, 'を入力してください')
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to @post, success: t('defaults.flash_message.updated', item: Post.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    redirect_to posts_path, success: t('defaults.flash_message.deleted', item: Post.model_name.human), status: :see_other
  end

  def likes
    @q = current_user.like_posts.ransack(params[:q])
    @like_posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image, :post_image_cache)
  end
end

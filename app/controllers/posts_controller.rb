class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    if params[:tag_name]
      tag = Tag.find_by(name: params[:tag_name])

      if tag.present?
        @q = tag.posts.ransack(params[:q])
        @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page]) if tag.posts.present?
      else
        redirect_to posts_path, warning: "タグ「#{params[:tag_name]}」に関する事故画はありませんでした"
      end
    elsif params[:latest]
      @q = Post.ransack(params[:q])
      @posts = @q.result(distinct: true).includes(:user).latest.page(params[:page])
    elsif params[:old]
      @q = Post.ransack(params[:q])
      @posts = @q.result(distinct: true).includes(:user).old.page(params[:page])
    elsif params[:order_by_like_count]
      @q = Post.ransack(params[:q])
      @posts = @q.result(distinct: true).includes(:user).order_by_like_count.page(params[:page])
    else
      @q = Post.ransack(params[:q])
      @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :asc)
    @tags = @post.tags
  end

  def new
    @post = Post.new
    @tags = @post.tags.map(&:name).join(',')
  end

  def create
    @post = current_user.posts.build(post_params)
    tag_list = params[:post][:tags][:name].split(',').uniq
    post_count = current_user.posts.created_today.count

    if @post.post_image.present? && @post.body.present?
      if post_count < 3
        @post.title = OpenAi.generate_title(@post.body, @post.post_image) if @post.post_image.present? && @post.body.present?
        @post.save
        @post.save_tags(tag_list)
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
    @tags = @post.tags.map(&:name).join(',')
  end

  def update
    @post = current_user.posts.find(params[:id])
    latest_tags = params[:post][:tags][:name].split(',').uniq

    if @post.update(post_params)
      @post.update_tags(latest_tags)
      redirect_to post_path(@post), success: t('defaults.flash_message.updated', item: Post.model_name.human)
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

  def search
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
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

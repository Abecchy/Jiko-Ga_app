class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
    flash.now[:success] = t('defaults.flash_message.created', item: Comment.model_name.human)
  end

  def edit
    @comment = current_user.comments.find(params[:id])
    @post = @comment.post
  end

  def update
    @comment = current_user.comments.find(params[:id])
    if @comment.update(comment_update_params)
      flash.now[:success] = t('defaults.flash_message.updated', item: Comment.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: Comment.model_name.human)
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
    flash.now[:success] = t('defaults.flash_message.deleted', item: Comment.model_name.human)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body).merge(post_id: @comment.post_id)
  end
end

class Admin::NovelCommentsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @novel = Novel.find(params[:novel_id])
    @comments = @novel.novel_comments.order(created_at: :desc)
  end
  
  def destroy
    @novel = Novel.find(params[:novel_id])
    @comment = NovelComment.find(params[:id])
    @comment.destroy
    redirect_to novel_novel_comments_path(@novel)
  end

  private

  def novel_comment_params
    params.require(:novel_comment).permit(:comment)
  end
end

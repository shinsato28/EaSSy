class Public::NovelCommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @novel = Novel.find(params[:novel_id])
    @comments = @novel.novel_comments.order(created_at: :desc)
    @new_comment = NovelComment.new
  end

  def create
    novel = Novel.find(params[:novel_id])
    comment = current_user.novel_comments.new(novel_comment_params)
    comment.novel_id = novel.id
    if comment.save
      redirect_to novel_novel_comments_path(novel), notice: "コメントを投稿しました。"
    end
  end

  def edit
    @novel = Novel.find(params[:novel_id])
    @comment = NovelComment.find(params[:id])
  end

  def update
    @novel = Novel.find(params[:novel_id])
    @comment = NovelComment.find(params[:id])
    if @comment.update(novel_comment_params)
      flash[:notice] = "コメントを編集しました。"
      redirect_to novel_novel_comments_path(@novel)
    else
      flash[:danger] = "コメントの編集に失敗しました。"
      render :edit
    end
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

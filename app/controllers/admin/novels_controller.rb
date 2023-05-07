class Admin::NovelsController < ApplicationController

  def edit
    @novel = Novel.find(params[:id])
  end

  def update
    @novel = Novel.find(params[:id])
    user = @novel.user
    if @novel.update(novel_params)
      flash[:notice] = "変更内容を保存しました。"
      redirect_to novels_index_admin_user_path(user)
    else
      render :edit
    end
  end

  private
    def novel_params
      params.require(:novel).permit(:is_deleted)
    end
end

class Admin::UsersController < ApplicationController
  before_action :authenticate_admin! # ログイン済管理者のみにアクセスを許可する

  def index
    @users = User.page(params[:page])
  end

  def novels_index
    @user = User.find(params[:id])
    @novels = @user.novels.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @novels = @user.novels
    @deleted_novels = @novels.where(is_deleted: true)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報の編集に成功しました。"
      redirect_to admin_user_path(@user.id)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :is_deleted, :email)
  end
end

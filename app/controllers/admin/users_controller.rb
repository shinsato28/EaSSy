class Admin::UsersController < ApplicationController
  before_action :authenticate_admin! # ログイン済管理者のみにアクセスを許可する

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :is_deleted, :email)
  end
end

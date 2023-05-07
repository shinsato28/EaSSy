class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:new]

  def show
    @user = User.find(params[:id])
    @novels = @user.novels.where(is_deleted: false)
  end

  def novels_index
    @user = User.find(params[:id])
    @novels = @user.novels
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報の編集に成功しました。"
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def withdraw
    @user = User.find(current_user.id)
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path, notice: "退会処理が完了しました。ご利用ありがとうございました。"
  end

  def unsubscribe
  end

  private

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end

  def user_params
    params.require(:user).permit(:name, :is_deleted, :email)
  end
end

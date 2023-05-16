# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :user_state, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_in_path_for(resource)
    flash[:notice] = "ログインに成功しました。"
    novels_path
  end

  def after_sign_out_path_for(resource)
    flash[:notice] = "ログアウトに成功しました。"
    root_path
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up)
  end

  # ログインしようとしたユーザーが退会済みなら新規登録画面へ遷移させる
  def user_state
    @user = User.find_by(email: params[:user][:email])

    # ユーザーのパスワードが一致かつ退会していないならログイン
    if @user && @user.valid_password?(params[:user][:password]) &&  @user.is_deleted == false
      flash[:notice] = "ログインに成功しました。"
    elsif @user && !@user.valid_password?(params[:user][:password])
      flash[:notice] = "パスワードが違います。"
    # ユーザーが退会済みなら新規登録画面に遷移
    else
      flash[:notice] = "退会済みです。再度ご登録をしてご利用ください。"
      redirect_to new_user_registration_path
    end
  end
end

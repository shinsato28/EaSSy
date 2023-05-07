class Public::NovelsController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def index
    @novels = Novel.where(is_unpublished: false, is_deleted: false)
  end

  def show
    @novel = Novel.find(params[:id])
    @user = @novel.user
  end

  def new
    @novel = Novel.new
  end

  def confirm
    @novel = Novel.new(novel_params)
    @novel.user_id = current_user.id
    render :new if @novel.invalid?
  end

  def create
    @novel = Novel.new(novel_params)
    @novel.user_id = current_user.id
    tag_list = params[:novel][:tag_name].delete(' ').delete('　').split(',')
    #　戻るボタンを押したときまたは、@novelが保存されなかったらnewアクションを実行
    if params[:back] || !@novel.save
      render :new and return
      @novel = Novel.new(novel_params)
    elsif @novel.save
      @novel.save_posts(tag_list)
      flash[:notice]="投稿に成功しました。"
      redirect_to novel_path(@novel)
    end
  end

  def edit
    @novel = Novel.find(params[:id])
    @tag_list = @novel.tags.pluck(:name).join(',')
  end

  def update
    @novel = Novel.find(params[:id])
    tag_list = params[:novel][:tag_name].delete(' ').delete('　').split(',')
    if @novel.update(novel_params)
      @novel.save_posts(tag_list)
      flash[:notice] = "変更内容を保存しました。"
      redirect_to novel_path(@novel)
    else
      render :edit
    end
  end

  private
    def novel_params
      params.require(:novel).permit(:title, :body, :is_unpublished, :is_deleted)
    end

    def is_matching_login_user
      novel = Novel.find(params[:id])
      user = novel.user
      unless user.id == current_user.id
        redirect_to novels_path
      end
    end
end

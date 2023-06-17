class Public::NovelsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:new, :edit]

  def home
    @recently_novels = Novel.where(is_unpublished: false, is_deleted: false).order(created_at: :desc)
    @most_favorite_novels = Novel.where(is_unpublished: false, is_deleted: false).most_favorite.order("favorites_count DESC").select("novels.*")
    @random_novels = Novel.where(is_unpublished: false, is_deleted: false).shuffle
  end

  def index
    # @q = Novel.ransack(params[:q])
    if params[:most_favorite]
      @novels = Novel.where(is_unpublished: false, is_deleted: false).page(params[:page]).most_favorite.order("favorites_count DESC").select("novels.*")
    elsif params[:latest]
      @novels = Novel.where(is_unpublished: false, is_deleted: false).page(params[:page]).latest
    else
      @novels = Novel.where(is_unpublished: false, is_deleted: false).order(created_at: :desc).page(params[:page])
    end
  end

  def show
    @novel = Novel.find(params[:id])
    @user = @novel.user
    # 小説が非公開、削除済みなら小説一覧に遷移
    if @novel.is_unpublished == true && @user.id != current_user.id
      flash[:notice]="非公開中です。"
      redirect_to novels_path
    elsif @novel.is_deleted == true
      flash[:notice]="管理者によって削除されています。"
      redirect_to novels_path
    end
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
    tag_list = params[:novel][:tag_name].split(/[[:space:]]+/)
    #　戻るボタンを押したときまたは、@novelが保存されなかったらnewアクションを実行
    if params[:back]
      render :new and return
      @novel = Novel.new(novel_params)
    # tag_name_no_duplicateメソッドを使用して重複するタグ名があれば戻す。メソッドの詳細は下記
    elsif tag_name_no_duplicate(tag_list) == false
      render :confirm and return
    elsif @novel.save
      @novel.save_posts(tag_list)
      flash[:notice]="投稿に成功しました。"
      redirect_to novel_path(@novel)
    end
  end

  def edit
    @novel = Novel.find(params[:id])
    @tag_list = @novel.tags.pluck(:name).join(' ')
  end

  def update
    @novel = Novel.find(params[:id])

    # 付けられたタグを配列として取得する。
    tag_list = params[:novel][:tag_name].split(/[[:space:]]+/)

    # updateの条件を満たすかつタグ名の重複がない場合、変更する。
    # 重複の判断にはtag_name_no_duplicateメソッドを使用。メソッドの詳細は下記
    if @novel.update(novel_params) && tag_name_no_duplicate(tag_list)
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

    # タグの保存、更新をする際に使用する。
    # .uniq.countで一意な要素の数を取得し、全体の数から引いた数が0でないときfalseを返す。
    def tag_name_no_duplicate(tag_list)
      result = tag_list.count == tag_list.uniq.count
      if result == false
        @tag_list = @novel.tags.pluck(:name).join(',')
        flash[:notice] = "同じタグ名を複数付けることはできません。"
        return false
      else
        return true
      end
    end

    def ensure_guest_user
      @user = current_user
      if current_user.name == "guestuser"
        redirect_to user_path(current_user) , notice: 'ゲストユーザーは新規投稿画面へ遷移できません。'
      end
    end
end

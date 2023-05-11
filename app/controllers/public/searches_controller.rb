class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    # Tagモデルに記載したsearch_novels_forを使った検索処理
    @model = params[:model]
    @content = params[:content]

    # タグ検索の場合の処理（タグをクリックすることでタグ検索を行う）
    if @model == 'tag'
      @records = Tag.search_novels_for(@content)
    # ユーザー検索の場合
    elsif @model == 'user'
      @records = User.search_for(@content)
    # novel検索の場合
    else
      # 検索ワードが空白で区切られていた場合分割して配列に直す
      keywords = params[:content].split(/[[:space:]]+/)
      # 新着順、いいね順にnovelを並び替えられるようにする
      if params[:most_favorite]
        @records = Novel.search_by_keywords(keywords).sort_by { |novel| -novel.favorites.count }
      elsif params[:latest]
        @records = Novel.search_by_keywords(keywords).sort_by(&:created_at).reverse
      else
        @records = Novel.search_by_keywords(keywords)
      end
    end
  end
end

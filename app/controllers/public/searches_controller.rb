class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    # Tagモデルに記載したsearch_novels_forを使った検索処理
    @model = params[:model]
    @content = params[:content]


    if @model == 'tag'
      @records = Tag.search_novels_for(@content)
    elsif @model == 'user'
      @records = User.search_for(@content)
    else
      keywords = params[:content].split(/[[:space:]]+/)
      @records = Novel.search_by_keywords(keywords)
    end
  end
end

class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @content = params[:content]

    if @model == 'tag'
      @records = Tag.search_novels_for(@content)
    end
  end
end

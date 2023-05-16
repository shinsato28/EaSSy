class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @novel = Novel.find(params[:novel_id])
    favorite = @novel.favorites.new(user_id: current_user.id)
    favorite.save
    # app/views/favorites/create.js.erbを参照する
  end

  def destroy
    @novel = Novel.find(params[:novel_id])
    favorite = @novel.favorites.find_by(user_id: current_user.id)
    favorite.destroy
    # app/views/favorites/destroy.js.erbを参照する
  end
end

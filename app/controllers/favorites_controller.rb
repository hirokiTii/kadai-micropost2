class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    fav = Micropost.find(params[:post_id])
    current_user.add_fav(fav)
    flash[:success] = "お気に入り登録しました"
    redirect_back(fallback_location: root_path)
  end

  def destroy
    fav = Micropost.find(params[:post_id])
    current_user.del_fav(fav)
    flash[:success] = "お気に入り解除しました"
    redirect_back(fallback_location: root_path)
  end
end
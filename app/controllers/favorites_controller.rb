class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
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
  
  def correct_user
    @favorites = current_user.fav_posts.find_by(id: params[:post_id])
    unless @favorites
      redirect_to root_url
    end
  end
end
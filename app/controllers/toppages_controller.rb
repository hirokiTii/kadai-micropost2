class ToppagesController < ApplicationController
  def index
    if logged_in?
      @micropost = current_user.microposts.build  # form_with 用
      @microposts = Micropost.all.order(id: :desc).page(params[:page])
    end
  end
end

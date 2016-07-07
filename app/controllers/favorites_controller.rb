class FavoritesController < ApplicationController
    before_action :logged_in_user

  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.like(@micropost)
  end

  def destroy
    @micropost= current_user.favorite_relationships.find(params[:id]).micropost
    current_user.unlike(@micropost)
  end
end

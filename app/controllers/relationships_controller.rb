class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_relationship, only: :destroy
  def create
    load_user params[:followed_id]
    current_user.follow @user
    respond_remote
  end

  def destroy
    @user = @relationship.followed
    if @user
      current_user.unfollow @user
      respond_remote
    else
      flash[:danger] = t "user.not_unfollow"
      redirect_to root_url
    end
  end

  def show
    load_user params[:id]
    case params[:type]
    when Settings.following
      @users = @user.following.paginate page: params[:page]
      @title = t "user.following"
    when Settings.follower
      @users= @user.followers.paginate page: params[:page]
      @title = t "user.followers"
    else
      flash[:danger] = t "navigate_error"
      redirect_to root_url
    end
  end

  private
  def respond_remote
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def load_user param_id
    @user = User.find_by id: param_id
    unless @user
      flash[:danger] = t "user.nil"
      redirect_to root_url
    end
  end
  def load_relationship
    @relationship = Relationship.find_by(id: params[:id])
    unless @relationship
      flash[:danger] = t "relationship.nil"
      redirect_to root_url
    end
  end
end

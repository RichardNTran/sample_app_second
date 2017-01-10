class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "micropost.create_success"
      redirect_to root_url
    else
      flash[:danger] = t "micropost.create_unsuccess"
      @feed_items = []
      redirect_to root_url
    end
  end

  def destroy
    @micropost.destroy ? flash[:success] = t("micropost.destroy.success") :
      flash[:danger] = t("micropost.destroy.unsuccess")
    redirect_back_or root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url if @micropost.nil?
  end
end

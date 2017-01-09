class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_micropost_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "micropost.create_success"
    else
      flash[:danger] = t "micropost.create_unsuccess"
      @feed_items = []
    end
    redirect_to root_url
  end

  def destroy
    byebug
    @micropost.destroy ? flash[:success] = t("micropost.destroy.success") :
      flash[:danger] = t("micropost.destroy.unsuccess")
    redirect_to request.referrer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_micropost_user
    @micropost = current_user.microposts.find_by id: params[:id]
    unless @micropost
      flash[:danger] = t "micropost.not_exist"
      redirect_to root_url
    end
  end
end

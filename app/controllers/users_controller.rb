class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :load_user, only: [:edit, :update, :destroy]

  def index
    page_size = params[:per_page].present? ? params[:per_page] :
      Settings.per_page
    @users = User.find_activated(true)
      .paginate page: params[:page], per_page: page_size
  end

  def show
    @user = User.find_by id: params[:id]
    @microposts = @user.microposts.paginate page: params[:page]
    unless @user && @user.activated
      redirect_to root_url
      flash[:warning] = t "user.invalid_user"
    end
  end

  def new
    @user= User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "user.activate_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "user.update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy ? flash[:success] = t("user.delete_success") :
      flash[:danger] = t("user.delete_unsuccess")
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:errors] = t "user.nil"
      redirect_to root_url
    end
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def admin_user
    unless current_user.admin?
      flash[:warning] = t "user.just_admin_role"
      redirect_to root_url
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    unless current_user? @user
      flash[:warning] = t "user.correct_user"
      redirect_to root_url
    end
  end
end

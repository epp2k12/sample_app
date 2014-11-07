class UsersController < ApplicationController
  before_action :logged_in_only, only:  [:index, :edit, :update, :destroy]
  before_action :current_user_only, only: [:edit, :update]
  #only admin can delete
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate( page: params[:page], :per_page => 5 )
  end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create

  	@user = User.new(user_params)
  	if @user.save 
  		# handles successful record save
      log_in @user
  		flash[:success] = "Welcome to Bawingsky's World"
  		redirect_to @user
  		# redirect_to user_url(@user)
  	else
  		render "new"
  	end

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated!"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success]= "User deleted!"
    redirect_to users_url
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    def logged_in_only
      unless logged_in?
        store_forwarding_url
        flash[:danger]="Please log in."
        redirect_to login_url
      end
    end

    def current_user_only
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end

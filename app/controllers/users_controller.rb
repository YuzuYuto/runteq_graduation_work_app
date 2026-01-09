class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit 
  end

  def update 
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールを更新しました'
    else
      flash.now[:alert] = 'プロフィールの更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy 
    @user.destroy!
    redirect_to users_path, notice: 'ユーザーを削除しました', status: :see_other
  end

  private

  def set_user 
    @user = User.find(params[:id])
  end

  def user_params 
    params.require(:user).permit(:email)
  end

  def ensure_correct_user
    unless @user == current_user
      redirect_to users_path, alert: '他のユーザーの情報は編集できません'
    end
  end
end

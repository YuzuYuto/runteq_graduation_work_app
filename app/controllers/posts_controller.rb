class PostsController < ApplicationController
  before_action :set_post, only: %i[show destroy edit update]
  before_action :authorize_user, only: %i[edit update destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new 
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save 
      redirect_to posts_path, success: '投稿を作成しました'
    else
      flash.now[:danger] = '投稿を作成できませんでした'
      render :new, status: :unprocessable_content
    end
  end

  def show 
  end

  def destroy 
    @post.destroy 
    redirect_to posts_path, notice: '投稿が削除されました'
  end

  def edit 
  end

  def update 
    if @post.update(post_params)
      redirect_to @post, notice: '投稿を更新しました'
    else
      flash.now[:alert] = '投稿の更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_post 
    @post = Post.find(params[:id])
  end

  def post_params 
    params.require(:post).permit(:title, :body)
  end

  def authorize_user 
    unless @post.user == current_user 
      redirect_to posts_path, alert: '権限がありません'
    end
  end
end

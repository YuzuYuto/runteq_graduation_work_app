class PostsController < ApplicationController
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

  def destroy 
    @post = Post.find(params[:id])
    if @post.user == current_user 
      @post.destroy 
      redirect_to posts_path, notice: '投稿が削除されました'
    else
      redirect_to posts_path, alert: '権限がありません'
    end
  end

  private

  def post_params 
    params.require(:post).permit(:title, :body)
  end
end

class CommentsController < ApplicationController
    before_action :authenticate_user!

    def create 
        @post = Post.find(params[:post_id])
        @comment = @post.comments.build(comment_params)
        @comment.user = current_user

        if @comment.save 
            redirect_to post_path(@post), notice: 'コメントを投稿しました'
        else
            # エラー時は投稿詳細ページを際表示
            @comments = @post.comments.includes(:user).order(created_at: :desc)
            flash.now[:alert] = 'コメントの投稿に失敗しました'
            render 'post/show', status: :unprocessable_entity
        end
    end

    def destroy 
        @comment = current_user.comments.find(params[:id])
        @post = @comment.post 
        @comment.destroy!

        redirect_to post_path(@post), notice: 'コメントを削除しました', status: :see_other
    end

    private

    def comment_params
        params.require(:comment).permit(:body)
    end
end

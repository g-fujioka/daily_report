class CommentsController < ApplicationController
  before_action :correct_user, only: [:edit, :destroy]

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      flash[:success] = 'コメントを投稿しました'
      redirect_to report_url(@comment.report)
    else
      redirect_to home_url
      #　redirect_to 直前のページにリダイレクト
    end

  end

  def destroy
    @comment = Comment.find(params[:id])
    @report = Report.find_by(id: @comment.report_id)
    @comment.destroy
    flash[:success] = 'コメントを削除しました'
    redirect_to @report
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :report_id, :user_id)
  end

  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to home_url if @comment.nil?
  end
end

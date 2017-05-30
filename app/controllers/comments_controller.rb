class CommentsController < ApplicationController
  before_action :correct_user, only: [:edit, :destroy]

  def create
    @report = Report.find(params[:report_id])
    @report.comments.build(comment_params)
    if @report.save
      flash[:success] = t('info.post')
      redirect_to @report
    else
      flash[:danger] = @report.comments.last.errors.full_messages.join
      return_back
    end

  end

  def destroy
    @comment = Comment.find(params[:id])
    @report = Report.find(params[:report_id])
    @comment.destroy
    flash[:success] = t('info.delete')
    redirect_to @report
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :report_id, :user_id)
  end

  # 正しいユーザー確認
  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_url if @comment.nil?
  end
end
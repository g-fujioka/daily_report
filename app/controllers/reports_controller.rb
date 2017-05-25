class ReportsController < ApplicationController

  def show
    @report = Report.find(params[:id])
    @comments = Comment.all.where(report_id: params[:id])
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    if @report.save
      flash[:info] = "日報を投稿しました"
      redirect_to reports_url
    else
      render 'reports/new'
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def report_params
    params.require(:report).permit(:report_date, :title, :content, :user_id)
  end
end

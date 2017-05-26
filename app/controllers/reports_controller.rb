class ReportsController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :log_in?, only:[:index, :show]

  def index
    @reports = Report.all.paginate(page: params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @comments = Comment.where(report_id: params[:id])
    @comment = Comment.new
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    if @report.save
      flash[:info] = t('info.post')
      redirect_to @report
    else
      return_back
    end
  end

  def edit
    @report = Report.find(params[:id])
  end

  def update
    if @report.update_attributes(report_params)
      flash[:success] = t('info.update')
      redirect_to @report
    else
      render 'reports/edit'
    end
  end

  def destroy
    @report.destroy
    flash[:success] = t('info.delete')
    redirect_to root_url
  end

  private

  def report_params
    params.require(:report).permit(:report_date, :title, :content, :user_id)
  end

  def correct_user
    @report = current_user.reports.find_by(id: params[:id])
    redirect_to root_url if @report.nil?
  end
end

class ReportsController < ApplicationController
  before_action :set_report, only: [:edit, :update, :destroy]
  before_action :log_in?, only: [:index, :show, :new]

  def index
    @q = Report.ransack(params[:q])
    @reports = @q.result.page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @comments = @report.comments.page(params[:page])
    @comment = Comment.new
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    if current_user.id == @report.user_id
      if @report.save
        flash[:info] = t('info.post')
        redirect_to @report
      else
        render 'reports/new'
      end
    else
      redirect_to root_url
      flash[:info] = t('errors.messages.correct_user')
    end
  end

  def edit
  end

  def update
    @report.attributes = report_params
    if current_user.id == @report.user_id
      if @report.save
        flash[:success] = t('info.update')
        redirect_to @report
      else
        render 'reports/edit'
      end
    else
      redirect_to root_url
      flash[:info] = t('errors.messages.correct_user')
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

  def set_report
    @report = current_user.reports.find_by(id: params[:id])
    if @report.nil?
      redirect_to root_url
      flash[:info] = t('errors.messages.correct_user')
    end
  end
end
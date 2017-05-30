class DepartmentsController < ApplicationController

  def index
    @departments = Department.paginate(page: params[:page])
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      flash[:success] = t('info.create')
      redirect_to departments_url
    else
      render 'departments/new'
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    if @department.update_attributes(department_params)
      flash[:success] = t('info.update')
      redirect_to departments_url
    else
    render 'departments/edit'
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    flash[:success] = t('info.delete')
    redirect_to departments_url
  end

  private

  def department_params
    params.require(:department).permit(:department_name, :state)
  end
end

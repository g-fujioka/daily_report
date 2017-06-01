class RenameDepartmentNameColumnToDepartments < ActiveRecord::Migration[5.1]
  def change
    rename_column :departments, :department_name, :name
  end
end

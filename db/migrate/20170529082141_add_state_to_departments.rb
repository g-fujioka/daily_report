class AddStateToDepartments < ActiveRecord::Migration[5.1]
  def change
    add_column :departments, :state, :boolean, default: true
  end
end

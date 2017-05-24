class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.integer, :user_id
      t.date, :report_date
      t.string, :title
      t.text :content

      t.timestamps
    end
  end
end

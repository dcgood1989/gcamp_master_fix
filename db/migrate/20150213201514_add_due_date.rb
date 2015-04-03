class AddDueDate < ActiveRecord::Migration
  def change
    add_column :tasks, :due_date, :date_field
  end
end

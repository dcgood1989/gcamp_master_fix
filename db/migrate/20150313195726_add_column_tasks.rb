class AddColumnTasks < ActiveRecord::Migration
  def change
    add_column :comments, :created_at, :datetime
    add_column :comments, :updated_at, :datetime

    add_column :tasks, :created_at, :datetime
    add_column :tasks, :updated_at, :datetime
  end
end

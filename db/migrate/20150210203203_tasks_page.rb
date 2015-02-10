class TasksPage < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
    t.text :description

    t.timestamp
  end
end
end

require 'rails_helper'

feature 'Existing users CRUD task' do

  before :each do
    Task.destroy_all
  end

  scenario "index lists all tasks with description" do
    homework = Task.new(description: 'homework')
    homework.save!
    crud = Task.new(description: 'crud')
    crud.save!

    sign_in_user
    expect(current_path).to eq root_path

    visit tasks_path
    expect(page).to have_content "Tasks"
    expect(page).to have_content "Due On"
    expect(page).to have_content "homework"
    expect(page).to have_content "crud"
  end

  scenario "can make a new task from the new task form" do

    sign_in_user
    visit tasks_path
    click_on 'New Task'

    expect(current_path).to eq new_task_path

    fill_in :Description, with: 'Drink'
    click_button 'Create Task'

    expect(page).to have_content 'Drink'
  end
scenario "index links to show via the description" do

   errands = Task.new(description: 'errands')
   errands.save!

   sign_in_user
   visit tasks_path

   click_link 'errands'

   expect(current_path).to eq task_path(errands)
   expect(page).to have_content "errands"
  end
  scenario "can edit task" do

    stuff = Task.new(description: 'stuff')
    stuff.save!

    sign_in_user
    visit tasks_path
    click_on "stuff"

    click_on "Edit"

    expect(page).to have_content "Edit Task"

    fill_in :task_description, with: "stuffs"
    click_button 'Update Task'

    expect(page).to have_content "Task was edited successfully"
    expect(page).to have_content 'stuffs'
  end

  scenario "can delete task" do
    stuff = Task.new(description: 'stuff')
    stuff.save!

    sign_in_user
    visit tasks_path
    click_on "Delete"
    expect(page).not_to have_content "stuff"
  end
end

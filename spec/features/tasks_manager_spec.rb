require 'rails_helper'

feature 'Existing users CRUD task' do

  before :each do
    Task.destroy_all
    User.destroy_all
    Project.destroy_all
  end

  scenario "index lists all tasks with description" do

    homework = Project.new(name: 'homework')
    homework.save!

    crud = Project.new(name: 'crud')
    crud.save!

    sign_in_user
    expect(current_path).to eq root_path

    click_on 'Projects'
    click_on 'homework'
    expect(page).to have_content "Edit"
    expect(page).to have_content "homework"
    expect(page).to have_content "Don Johnson"
  end

  scenario "can make a new task from the new task form" do
    homework = Project.new(name: 'homework')
    homework.save!
    sign_in_user
    visit project_tasks_path(homework)
    click_on 'New Task'

    expect(current_path).to eq new_project_task_path(homework)

    fill_in :Description, with: 'Drink'
    click_button 'Create Task'

    expect(page).to have_content 'Drink'
  end

  scenario "index links to show via the description" do

    homework = Project.new(name: 'homework')
    homework.save!

    sign_in_user
    visit project_tasks_path(homework)
    click_on 'New Task'

    fill_in :Description, with: 'errands'
    click_on "Create Task"
    click_link 'errands'

    expect(page).to have_content "errands"
  end

  scenario "can edit task" do

    homework = Project.new(name: 'homework')
    homework.save!

    sign_in_user
    click_on "Projects"
    click_on "homework"
    click_on "0 Tasks"

    click_on "New Task"
    fill_in :Description, with: 'heyo'
    click_on "Create Task"

    click_on "Edit"

    fill_in :Description, with: 'help'


    click_on "Update Task"

    expect(page).to have_content "help"

    expect(page).to have_content "Task was successfully updated"
    expect(page).to have_content 'help'
  end

  scenario "can delete task" do
    homework = Project.new(name: 'homework')
    homework.save!

    sign_in_user
    click_on "Projects"
    click_on "homework"
    click_on "0 Tasks"

    click_on "New Task"
    fill_in :Description, with: 'heyo'
    click_on "Create Task"

    page.find('.glyphicon-remove').click
    expect(page).to have_content 'Task was successfully deleted'
    expect(page).not_to have_content 'heyo'

  end
end

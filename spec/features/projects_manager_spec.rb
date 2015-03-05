require 'rails_helper'

feature 'Existing users CRUD projects' do

  before :each do
    User.destroy_all
    Project.destroy_all
  end

  scenario "index lists all prjects with name" do
    crud = Project.new(name: 'crud')
    crud.save!

    sign_in_user
    expect(current_path).to eq root_path

    visit projects_path
    expect(page).to have_content "Name"

end

  scenario "can make a new project from the new project form" do

    sign_in_user
    visit projects_path
    click_on 'New Project'

    expect(current_path).to eq new_project_path

    fill_in :project_name, with: 'Capybara'
    click_button 'Create Project'

    expect(page).to have_content 'Capybara'
end

scenario "index links to show via the name" do

   errands = Project.new(name: 'errands')
   errands.save!

   sign_in_user
   visit projects_path

   click_link 'errands'

   expect(page).to have_content "errands"
end
  scenario "can edit project" do

    project = Project.new(name: 'grow a beard')
    project.save!

    sign_in_user
    visit projects_path
    click_on 'grow a beard'

    click_on "Edit"

    expect(page).to have_content "Edit Project"

    fill_in :project_name, with: "stuffs"
    click_button 'Update Project'

    expect(page).to have_content "Project was edited successfully"
    expect(page).to have_content 'stuffs'
  end

  scenario "can delete project" do
    stuff = Project.new(name: 'stuff')
    stuff.save!

    sign_in_user
    visit projects_path
    click_on "stuff"
    click_on "Delete"
    expect(page).not_to have_content "stuff"
  end
end

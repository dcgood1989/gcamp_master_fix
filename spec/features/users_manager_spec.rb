require 'rails_helper'

feature 'Existing user CRUD users' do

  before :each do
    User.destroy_all
    Task.destroy_all
  end

  scenario "index lists all users with name, email" do

    sign_in_user
    expect(current_path).to eq root_path

    visit users_path
    expect(page).to have_content "Name"
    expect(page).to have_content "Don Johnson"
    expect(page).to have_content "Email"
    expect(page).to have_content "New User"
    expect(page).to have_content "Edit"
  end

  scenario "can make a new user from the new user form" do

    sign_in_user
    visit users_path
    click_on 'New User'

    expect(current_path).to eq new_user_path

    fill_in :user_first_name, with: 'Trey'
    fill_in :user_last_name, with: 'Anastasio'
    fill_in :user_email, with: 'phishsticks@kanye.com'
    fill_in :user_password, with: 'cayman review'
    fill_in :user_password_confirmation, with: 'cayman review'
    click_button 'Create User'

    expect(page).to have_content 'Trey Anastasio'
    expect(page).to have_content  'phishsticks@kanye.com'
    end


  scenario "index links to show via the name" do

   sign_in_user
   visit users_path

   click_link 'Don'

   expect(page).to have_content "hawaii50@gmail.com"

  end

  scenario "can edit user" do

    sign_in_user
    visit users_path
    click_on "Don"

    click_on "Edit"

    expect(page).to have_content "Edit"

    fill_in :user_first_name, with: 'Trey'
    fill_in :user_last_name, with: 'Anastasio'
    fill_in :user_email, with: 'phishsticks@kanye.com'
    fill_in :user_password, with: 'cayman review'
    fill_in :user_password_confirmation, with: 'cayman review'
    click_on "Update User"

    expect(page).to have_content "User was edited successfully"
    expect(page).to have_content 'Trey'
  end

  scenario "can delete user" do
    user = User.new(first_name: 'Mark', last_name: 'Mcgrath', email: 'sugarray@forlife.com', password: 'halo', password_confirmation: 'halo')
    user.save!

    sign_in_user
    visit users_path
    click_on "Mark"
    click_on "Edit"
    click_on "Delete"
    expect(page).not_to have_content "Mark"
  end
  end

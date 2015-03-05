require 'rails_helper'

feature 'sign out' do

  before :each do
    User.destroy_all
  end

  scenario 'user can sign out' do

    sign_in_user


    expect(page).to have_content "Don Johnson"

    click_on 'Sign Out'

    expect(page).not_to have_content 'Don Johnson'
    expect(current_path).to eq root_path
    expect(page).to have_content 'You have successfully signed out'

  end
end

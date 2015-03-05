require 'rails_helper'

feature 'user signup' do

 before :each do
   User.destroy_all
 end

 scenario 'user can sign up' do
   visit root_path
   expect(page).to have_content 'gCamp'

   click_link 'Sign Up'
   expect(current_path).to eq sign_up_path
   expect(page).to have_content 'Sign up for gCamp!'

   fill_in :user_first_name, with: 'Roger'
   fill_in :user_last_name, with: 'Goodell'
   fill_in :user_email, with: 'football@dog.com'
   fill_in :user_password, with: 'football'
   fill_in :user_password_confirmation, with: 'football'
   click_button 'Sign up'

   expect(current_path).to eq '/'
   expect(page).to have_content 'You have successfully signed up'
 end
end

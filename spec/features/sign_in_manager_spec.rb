require "rails_helper"

feature "sign in" do

 before :each do
   User.destroy_all
 end

 scenario "can sign in" do

   user = User.new(first_name: 'Jennifer',
   last_name: 'Garner',
   email: '13goingon30@gmail.com',
   password: '13',
   password_confirmation: '13')
   user.save!

   visit root_path
   click_on "Sign In"

   expect(page).to have_content "Sign into gCamp"


   fill_in 'Email', with: '13goingon30@gmail.com'
   fill_in 'Password', with: '13'

   click_button "Sign In"

   expect(current_path).to eq projects_path

end

scenario 'are redirected back to the sign in form and shown' do
 visit root_path
 click_on 'Sign In'

 expect(current_path).to eq sign_in_path
 expect(page).to have_content 'Sign into gCamp'

 fill_in :email, with: 'nickpapagiorgio'
 fill_in :password, with: 'damn'
 click_button 'Sign In'

 expect(current_path).to eq sign_in_path
 expect(page).to have_content 'Email/Password combination is invalid'
 end
end

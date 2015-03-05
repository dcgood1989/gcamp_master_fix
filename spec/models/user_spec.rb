require 'rails_helper'

  describe Task do
   it "requires a first name" do
     user = User.new
     expect(user).not_to be_valid
     user.update(first_name: 'Dillon', last_name: 'Good', email:'dil@dil.com', password: 'dil', password_confirmation: 'dil')
     expect(user).to be_valid

  end
end

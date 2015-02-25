require "rails_helper"

describe User do
   it "requires a first name" do
     user = User.create( first_name: "Dillon", last_name: "Good", email: "dill@dill.com" )
     expect(user).to be_valid
   end
 end

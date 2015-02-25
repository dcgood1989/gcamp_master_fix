require "rails_helper"


  describe user do
    it "requires a first name" do
      User.create(first_name: "dillon", last_name: "good", email: "soccerdudedg@gmail.com")
      expect(@user).to be_valid
    end
  end

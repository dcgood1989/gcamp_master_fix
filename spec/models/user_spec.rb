require "rails_helper"

it “requires a first name” do
  expect(@user).to be_valid
end

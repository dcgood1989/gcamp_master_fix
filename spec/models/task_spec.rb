require 'rails_helper'

  describe Task do
   it "requires a description" do
     task = Task.new
     expect(task).not_to be_valid
     task.description = "Super sweet task"
     expect(task).to be_valid
   end
  end

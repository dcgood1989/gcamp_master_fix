def sign_in_user
  user = User.new(first_name: 'Don', last_name: 'Johnson', email: 'hawaii50@gmail.com', password: 'hawaii', password_confirmation: 'hawaii', admin: true)
  user.save!
  visit sign_in_path
  fill_in :email, with: 'hawaii50@gmail.com'
  fill_in :password, with: 'hawaii'
  click_button 'Sign In'
end

def create_user(options={})
  User.create!({
    first_name: "Randall",
    last_name: "Savage",
    email: "slimjim#{rand(100000) + 1}@example.com",
    password: "snapintoaslimjim",
    password_confirmation: "snapintoaslimjim",
    admin: true
  }.merge(options))
end

def create_project(options = {})
  defaults = {
    name: "Run real away"
  }
  project = Project.create!(defaults.merge(options))
end

def create_task(options={})
  Task.create!({
    description: "Run away",
    project_id: create_project.id,
    due_date: "1/12/2030"
  }.merge(options))
end

def create_comment(options={})
  Comment.create!({
    content: "I like your shoes",
    user_id: create_user.id,
    task_id: create_task.id
    }.merge(options))
end

def create_membership(options={})
  Membership.create!({
    roles: "Owner",
    project_id: create_project.id,
    user_id: create_user.id
  }.merge(options))
end

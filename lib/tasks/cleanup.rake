namespace :cleanies do

  desc "Removes all memberships where their users have already been deleted"
  task list: :environment do
    Membership.where.not(user_id: User.pluck(:id)).destroy_all
    puts 'please'
  end

  desc "Removes all memberships where their projects have already been deleted"
    task list: :environment do
      Membership.where.not(project_id: Project.pluck(:id)).destroy_all
      puts 'pass'
  end

  desc "Removes all tasks where their projects have been deleted"
    task list: :environment do
      Task.where.not(project_id: Task.pluck(:id)).destroy_all
      puts "the"
  end

  desc "Removes all comments where their tasks have been deleted"
    task list: :environment do
      Comment.where.not(task_id: Task.pluck(:id)).destroy_all
      puts "orange"
  end

  desc "Sets the user_id of comments to nil if their users have been deleted"
    task list: :environment do
      Comment.where.not(user_id: User.pluck(:id)).update_all(user_id: nil)
      puts "juice"
  end

  desc "Removes any tasks with null project_id"
    task list: :environment do
      Task.where(project_id: nil).destroy_all
      puts "and"
  end

  desc "Removes any comments with a null task_id"
      task list: :environment do
        Comment.where(task_id: nil).destroy_all
        puts "more"
  end

  desc "Removes any memberships with a null project_id or user_id"
    task list: :environment do
        Membership.where(project_id: nil).destroy_all
        puts "vodka"
  end

  desc "Removes any memberships with a null user_id"
    task list: :environment do
        Membership.where(user_id: nil).destroy_all
        puts "ful"
  end

end

require 'rails_helper'

describe TasksController do

  before :each do
    @user = create_user(admin: false)
    session[:user_id] = @user.id
    @project = create_project
    @membership = create_membership(project_id: @project.id, user_id: @user.id, roles: "Member")
    @task = create_task(project_id: @project.id)
  end

  describe "#index" do
    it "shows projects you are a part of" do
      task = create_task
      get :index, project_id: @project.id
      expect(response).to be_success
      expect(response).to render_template("index")
    end
  end

  describe "#new" do
    it "renders the new page" do
      get :new, project_id: @project.id
      expect(response). to be_success
      expect(response). to render_template("new")
    end
  end

  describe "#create" do

    it "project members can add tasks to projects" do
      expect{
        post :create, task: {description: "Jump up jump up get down"}, project_id: @project.id
      }.to change{Task.all.count}.by(1)
    end

    it "non members cannot add tasks" do
      session.clear
      user = create_user(admin: false)
      session[:user_id] = user.id

      expect{
        post :create, task: {description: "Jump up"}, project_id: @project.id
      }.to_not change{Task.all.count}

      expect(flash[:error]).to eq("You do not have access to that project")
    end
  end

  describe "#show" do

    it "displays task show page" do

      get :show, project_id: @project.id, id: @task.id
      expect(response).to render_template :show
    end
  end

  describe "#edit" do

    it "displays edit for that project task" do
      get :edit, project_id: @project.id, id: @task.id
      expect(response).to be_success
      expect(response).to render_template :edit
    end
  end


  describe "#update" do

    it "updaates the current task" do
      project = create_project(name: "Build a horse")
      task = create_task(description: "Wooden horse", project_id: project.id)
      membership = Membership.create!(user_id: @user.id, project_id: project.id, roles: "Owner")
      patch :update, project_id: project.id, id: task.id, task: {description: "Build a dog"}
      task.reload
    expect(task.description).to eq("Build a dog")
    expect(flash[:notice]).to eq "Task was successfully updated"
    expect(response).to redirect_to project_task_path
    end
  end


  describe "#destroy" do

    describe "can destroy a task" do
      it "owners can delete a task" do
        project = create_project(name: "Take candy")
        task = create_task(description: "Eat canty", project_id: project.id)
        membership = Membership.create!(user_id: @user.id, project_id: project.id, roles: "Owner")
        expect {
          delete :destroy, project_id: project.id, id: task.id
          }.to change { Task.all.count }.by(-1)
          expect(response).to redirect_to project_tasks_path

      end
    end
  end

  end

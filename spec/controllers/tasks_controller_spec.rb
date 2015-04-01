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

    describe "#new" do
      it "renders the new page" do
        get :new, project_id: @project.id
        expect(response). to be_success
        expect(response). to render_template("new")
      end
    end

    describe "#create" do

      it 'project members can add tasks to projects' do
        expect{
          post :create, task: {description: "Jump up jump up get down"}, project_id: @project.id
        }.to change{Task.all.count}.by(1)
      end

      it 'non members cannon add tasks' do
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

#     describe "#update" do
#       it "updates the task when valid parameters are passed and belongs to project" do
#         expect{
#           patch :update, task: project_id: @project.id
#
#           expect(flash[:notice]).to eq "Task was successfully updated"
# end
# end
#
#     describe "#destroy" do
#
#       it "deletes a task" do
#         task = create_task(project_id: @project.id, id: @task.id)
#
#         expect{
#           delete :destroy, id: @task.id
#         }.to change {project.task}
end
end

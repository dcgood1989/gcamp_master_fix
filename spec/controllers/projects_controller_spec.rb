require 'rails_helper'

describe ProjectsController do
  before :each do
    @user = create_user(admin: false)
    session[:user_id] = @user.id
    @project = create_project
  end

  describe "#index" do
    it "assigns all projects with a title eat" do
      project = create_project(name: "eat")
      membership = Membership.create!(user_id: @user.id, project_id: project.id, roles: "Owner")

      get :index

      expect(assigns(:projects)).to eq [project]
    end
  end

  describe "#new" do
    it "renders the new page" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "#create" do

    describe "success" do
      it "user can create a new project with valid parameters" do
        expect{
          post :create, project: {
            name: "Brovloski"
          }
        }.to change{Project.all.count}.by(1)

        project = Project.last
        expect(project.name).to eq "Brovloski"
        expect(flash[:notice]).to eq "Project was created successfully"
      end

      describe "failure" do
        it "does not create a new project with invalid parameters" do
          expect {
            post :create, project: {name: nil}}.to_not change { Project.all.count}

            expect(response).to render_template(:new)
          end
        end

  describe "#show" do

    it "displays the project show page" do
      get :show, id: @project
      expect(assigns(:project)).to eq(@project)
    end

    it "does not display show for projects they are not a part of" do
      session.clear
      get :show, id: @project
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "#edit" do

    it "displays edit for owners of projects" do
      get :edit, id: @project
      expect(assigns(:project)).to eq (@project)
    end

    it 'does not display edit for projects that are not logged in' do
      session.clear
      get :edit, id: @user
      expect(response).to redirect_to sign_in_path
    end
  end
  end

  describe "#update" do

    describe "can update a project with valid attributes" do
      it "project owner can update projects" do

        project = create_project(name: "Dog")
        membership = Membership.create!(user_id: @user.id, project_id: project.id, roles: "Owner")
        expect {
          patch :update, id: project.id, project: {name: "Cat"}}.to change {project.reload.name}.from("Dog").to("Cat")

          expect(flash[:notice]).to eq "Project was edited successfully"
          expect(response).to redirect_to project_path(project)
        end
      end
    end

    # it 'cannot update if not project owner' do
    #   project = create_project(name: "Dog")
    #   membership = Membership.create!(user_id: @user.id, project_id: project.id, roles: "Member")
    #   expect {
    #     patch :update, id: project.id, project: {name:"Cat"}}.to not_change
    #     {project.reload.name}.from("Dog").to("Cat")
    #
    #     expect(flash[:notice]).to eq

  describe "#destroy" do

    describe "can delete projects" do
      it 'allows a project owner to delete a project' do
        project = create_project
        membership = Membership.create!(user_id: @user.id, project_id: project.id, roles: "Owner")
        expect {
          delete :destroy, id: project.id
        }.to change { Project.all.count }.by(-1)

        expect(flash[:notice]).to eq "The project has been successfully deleted"
        expect(response).to redirect_to projects_path
      end
    end

      it 'allows an admin to delete a project' do
        session.clear
        admin_user = create_user(admin: true)
        session[:user_id] = admin_user.id

        project = create_project

        expect {
          delete :destroy, id: project.id
        }.to change { Project.all.count }.by(-1)

        expect(flash[:notice]).to eq "The project has been successfully deleted"
        expect(response).to redirect_to projects_path
      end
    end
  end
end

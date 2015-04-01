require "rails_helper"

describe MembershipsController do

  before :each do
    @user = create_user(admin: false)
    session[:user_id] = @user.id
    @user_admin = create_user(admin: true, email: "test@example.com")
    session[:user_id] = @user_admin.id
    @project = create_project
    @membership = create_membership(project_id: @project.id, user_id: @user.id, roles: "Member")
    @task = create_task(project_id: @project.id)
  end

  describe "#index" do
    it "displays the memberships" do
      membership = create_membership
      get :index, project_id: @project.id
      expect(response).to be_success
      expect(response).to render_template("index")
    end
  end

  describe "#create" do

    it "Admin or owners can change memberships" do
      session.clear
      @user_admin = create_user
      session[:user_id] = @user_admin.id
      project = create_project
      membership = create_membership(user_id: @user_admin.id, project_id: project.id, roles: "Owner")
      expect { post :create, project_id: project.id, membership:{project_id: project.id, user_id: @user.id, roles: "Member"}}.to change {Membership.count}.by(1)
      expect(response).to redirect_to project_memberships_path(project)
    end

    it "nonmembers cannot edit memberships" do
      session.clear
      project = create_project
      membership = create_membership(user_id: @user_admin.id, project_id: project.id, roles: "Owner")
      expect { post :create, project_id: project.id, membership:{project_id: project.id, user_id: @user.id, roles: "Member"}}.to change {Membership.count}.by(0)
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "#update" do

    it "allows owners and admins rights to update memberships" do
      @user_admin = create_user
      session[:user_id] = @user_admin.id
      @user = create_user
      session[:user_id] = @user.id
      project = create_project
      membership_admin = create_membership(user_id: @user_admin.id, project_id: project.id, roles: "Owner")
      membership = create_membership(user_id: @user.id, project_id: project.id, roles: "Member")
      patch :update, project_id: project.id, id: membership.id, membership: {role: "Owner"}
      expect(response).to redirect_to project_memberships_path(project)
    end

    it 'does not allow nonmembers to update memberships' do
     session.clear
     @user = create_user
     session[:user_id] = @user.id
     project = create_project
     membership = create_membership(user_id: @user.id, project_id: project.id, roles: "Owner")
     patch :update, project_id: project.id, id: membership.id, membership: {roles: "Member"}
     expect(response).to redirect_to project_memberships_path(project)
   end
  end

  describe "#destroy" do

   it "allows owners and admins to delete a task" do
     @user_admin = create_user
     session[:user_id] = @user_admin.id
     @user = create_user
     session[:user_id] = @user.id
     project = create_project
     membership_admin = create_membership(user_id: @user_admin.id, project_id: project.id, roles: "Owner")
     membership = create_membership(user_id: @user.id, project_id: project.id, roles: "Member")

     expect{
       delete :destroy, project_id: project.id, id: membership.id
     }.to change {Membership.all.count}.by(-1)

     expect(response).to redirect_to projects_path
     expect(flash[:notice]).to eq("Randall Savage was successfully deleted")
   end




 end






end

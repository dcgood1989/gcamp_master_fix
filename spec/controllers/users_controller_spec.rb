require "rails_helper"

describe UsersController do

  before :each do
    @user = create_user(admin: false)
    session[:user_id] = @user.id
  end


  describe "#index" do

    it "allows admin users" do
      user = create_user(admin: true)
      session[:user_id] = user.id
      get :index
      expect(response).to be_success
    end

    it "renders the index page" do
      get :index
      expect(response). to render_template ("index")
    end

    it 'does not display index for users that are not logged in' do
      session.clear
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "#new" do

    it "renders the new page" do
      get :new
      expect(response).to render_template("new")
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "#create" do

    describe "on success" do
      it "creates a new user when valid parameters are passed" do
        expect{
          post :create, user: {
            first_name: "Roger",
            last_name: "Klotz,",
            email: "doug@example.com",
            password: "hello",
            password_confirmation: "hello",
            admin: false
          }
        }.to change{User.all.count}.by(1)

        user = User.last
        expect(user.first_name).to eq "Roger"
        expect(user.last_name).to eq "Klotz,"
        expect(user.email).to eq "doug@example.com"

        expect(flash[:notice]).to eq "User was created successfully"
        expect(response).to redirect_to users_path
      end
    end

    describe"#show" do

      it "displays show page" do
        get :show, id: @user
        expect(assigns(:user)).to eq(@user)
        expect(response).to render_template :show
      end


      it 'does not display show for users that are not logged in' do
        session.clear
        get :show, id: @user
        expect(response).to redirect_to sign_in_path
      end
    end



    describe "#edit" do

      it "displays edit for the current user" do
        get :edit, id: @user
        expect(assigns(:user)).to eq (@user)
        expect(response).to render_template :edit
      end

      it 'does not display edit for users that are not logged in' do
        session.clear
        get :edit, id: @user
        expect(response).to redirect_to sign_in_path
      end

    end

    describe "#update" do

      it "updates a new user when valid parameters are passed and is current user" do
        expect{
          patch :update, id: @user, user: {
            first_name: "Roger",
            last_name: "Klotz,",
            email: "doug@example.com",
            password: "hello",
            password_confirmation: "hello",
            admin: false
          }
        }.to change{User.all.count}.by(0)

        user = User.last
        expect(user.first_name).to eq "Roger"
        expect(user.last_name).to eq "Klotz,"
        expect(user.email).to eq "doug@example.com"

        expect(flash[:notice]).to eq "User was edited successfully"
        expect(response).to redirect_to users_path
      end

      it 'cannot update if not user' do
        user = create_user(email: "rabble@gmail.com")

        expect{
          patch :update, id: user, user: {first_name: user.first_name, last_name: "Newport", email: user.email, password: user.password, password_confirmation: user.password}
        }.to_not change{@user.reload.last_name}
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes a user and not comments' do
        comment = create_comment(user_id: @user.id)

        expect{
          delete :destroy, id: @user.id
        }.to change {User.all.count}.by(-1)

        expect(flash[:notice]).to eq("User was successfully deleted")
        expect(response).to redirect_to root_path

      end

      it 'users cannot delete other users' do
        user = create_user

        expect{
          delete :destroy, id: user.id
        }.to_not change{User.all.count}
      end
    end
  end
end

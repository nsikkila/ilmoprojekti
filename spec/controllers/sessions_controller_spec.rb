require 'spec_helper'

describe SessionsController do

  describe "#create" do

    describe 'with valid credentials' do

      describe 'with not disabled user' do
        let!(:user){ FactoryGirl.create :user }
        it "creates a session with valid credentials" do
          post :create, username:"Maija", password:"Test123"

          expect(session[:user_id]).to eq(1)
        end

        it "deletes session information if the session times out" do
          post :create, username:"Maija", password:"Test123"

          session[:timeout].should_not be(nil)

          #Timeoutataan sessioni
          session[:timeout] = Time.now - 20.minutes

          #Tehdään http request, jolloin ao. session attribuutit pitäisi tuhota
          #Ennen :new actionia kutsutaan check_expire metodia

          get :new
          session[:user_id].should be(nil)
          session[:timeout].should be(nil)


        end
      end

      describe 'with disabled user' do
        let!(:user){ FactoryGirl.create(:user, disabled:true) }

        it 'session is not created' do
          post :create, username:"Maija", password:"Test123"
          expect(session[:user_id]).to be nil
        end

        it 'redirects to signin_path' do
          post :create, username:"Maija", password:"Test123"

          expect(response).to redirect_to signin_path
        end


      end


    end


  end
end

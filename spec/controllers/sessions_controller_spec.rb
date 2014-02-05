require 'spec_helper'

describe SessionsController do

	describe "#create" do
		let!(:user){ FactoryGirl.create :user }
		it "creates a session with valid credentials" do
			post :create, username:"Maija", password:"Test123"

			expect(session[:user_id]).to eq(1)
		end

	end
end

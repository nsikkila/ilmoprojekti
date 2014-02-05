require 'spec_helper'

describe "User" do

	describe "who has registered" do
		before :each do
			FactoryGirl.create :user
		end

		it "can sign in with right credentials" do
			sign_in

			expect(page).to have_content 'Welcome back!'
			expect(page).to have_content 'Maija'
		end

		it "can not sign in with incorrect password" do
			visit signin_path
			fill_in('username', with:"Maija")
			fill_in('password', with:"Tatti123")
			click_button('Log in')

			expect(page).to have_content 'Username and password do not match'
		end

		it "can not sign in with incorrect username" do
			visit signin_path
			fill_in('username', with:"Matti")
			fill_in('password', with:"Test123")
			click_button('Log in')

			expect(page).to have_content 'Username and password do not match'
		end
		
	end

	describe "who has signed in and is a teacher" do
		before :each do
			FactoryGirl.create :user
			sign_in
		end

		it "can access project creation" do
			visit projects_path

			click_link "New Project"
			expect(current_path).to eq(new_project_path)
		end

		it "can not access user creation" do
			visit new_user_path

			expect(current_path).to eq('/')
		end
	end

	describe "who has signed in and is an admin" do
		before :each do
			FactoryGirl.create :user, accesslevel:1
			sign_in
		end

		it "can access project creation" do
			visit projects_path

			click_link "New Project"
			expect(current_path).to eq(new_project_path)
		end

		it "can access user creation" do
			visit new_user_path

			expect(page).to have_content 'New user'
			expect(current_path).to eq(new_user_path)
		end

		it "can access user list" do
			visit users_path

			expect(page).to have_content 'Käyttäjät'
			expect(current_path).to eq(users_path)
		end

	end

end

def sign_in
	visit signin_path
	fill_in('username', with:"Maija")
	fill_in('password', with:"Test123")
	click_button('Log in')
end
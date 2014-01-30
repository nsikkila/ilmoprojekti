require 'spec_helper'

describe "User" do
	before :each do
		FactoryGirl.create :user
	end

	describe "who has registered" do
		it "can sign in with right credentials" do
			visit signin_path
			fill_in('username', with:"Maija")
			fill_in('password', with:"Test123")
			click_button('Log in')

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
end
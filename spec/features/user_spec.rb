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
	end
end
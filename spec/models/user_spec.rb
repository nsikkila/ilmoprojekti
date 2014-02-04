require 'spec_helper'


describe User do
	let(:user){ FactoryGirl.build(:user) }
	
	it "has the username set correctly" do
		user.username.should == "Maija"
	end

	it "has the password set correctly" do
		user.password.should == "Test123"
		user.password.should == "Test123"
	end

	it "is not saved with too short username" do
		#Username is too short
		user = FactoryGirl.build(:user, username:"ab")
		#User must not be valid
		expect(user.valid?).to be(false)
		#User must not be added to db
		expect(User.count).to eq(0)
	end

	describe "with proper fields" do

		it "is saved" do
			user.save
			#User is valid
			expect(user.valid?).to be (true)
			#User is added to db
			expect(User.count).to eq (1)
		end
	end
end
require 'spec_helper'

#dfsajsescribe User do
 # pending "add some examples to (or delete) #{__FILE__}"
#end

describe User do
	let(:user){ FactoryGirl.build(:user) }
	
	it "has the username set correctly" do
		user.username.should == "Maija"
	end

	it "has the passwors set correctly" do
		user.password.should == "Test123"
		user.password.should == "Test123"
	end

	it "is saved with proper fields" do
		user = FactoryGirl.create(:user)

		#User is valid
		expect(user.valid?).to be (true)
		#User is added to db
		expect(User.count).to eq (1)
	end

	describe "without a proper username" do

		it "is not saved" do
			#Username is too short
			user = FactoryGirl.build(:user_with_too_short_username)

			#User must not be valid
			expect(user.valid?).to be(false)
			#User must not be added to db
			expect(User.count).to eq(0)
		end
	end
end
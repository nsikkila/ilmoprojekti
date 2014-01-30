require 'spec_helper'

#dfsajsescribe User do
 # pending "add some examples to (or delete) #{__FILE__}"
#end

describe User do
	it "has the username set correctly" do
		user = User.new username:"Maija"

		user.username.should == "Maija"
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
			user = User.create username:"ab", password:"Testi123", password_confirmation:"Testi123"

			#User must not be valid
			expect(user.valid?).to be(false)
			#User must not be added to db
			expect(User.count).to eq(0)
		end
	end
end
require 'spec_helper'

#describe User do
 # pending "add some examples to (or delete) #{__FILE__}"
#end

describe User do
	it "constructor correctly sets username" do
		user = User.new username:"Maija"

		user.username.should == "Maija"
	end
end

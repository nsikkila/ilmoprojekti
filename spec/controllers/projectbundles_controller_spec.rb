require 'spec_helper'

describe ProjectbundlesController do
	before :each do
		@projectbundle1 = FactoryGirl.create :projectbundle, name:"bundle1"
		@projectbundle2 = FactoryGirl.create :projectbundle, name:"bundle2"
	end
=begin
	it "#new sets all bundles to variable" do
		get :new
		assigns(:projectbundles).count.should == 2
	end
=end
end
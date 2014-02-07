require 'spec_helper'

describe ProjectbundlesController do
	before :each do
		@projectbundle1 = FactoryGirl.create :projectbundle, name:"bundle1"
		@projectbundle2 = FactoryGirl.create :projectbundle, name:"bundle2"
	end

	it "#index sets all bundles to variable" do
		get :index
		assigns(:projectbundles).count.should == 2
	end

end
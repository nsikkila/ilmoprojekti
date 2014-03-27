require 'spec_helper'

describe ProjectbundlesController do
	before :each do
		@projectbundle1 = FactoryGirl.create :projectbundle, name:"bundle1", verified:false, active:true
	end
=begin
	it "#new sets all bundles to variable" do
		get :new
		assigns(:projectbundles).count.should == 2
	end
=end
=begin
  it "Projectbundle cannot be verified if user is not logged in" do
    get "/projectbundles/1/verify"

    @projectbundle1.verify.should == false

  end
=end
end
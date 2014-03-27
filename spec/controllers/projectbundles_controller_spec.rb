require 'spec_helper'
include TestHelper

describe ProjectbundlesController do
	before :each do
		@projectbundle1 = FactoryGirl.create :projectbundle, name:"bundle1", verified:false, active:true, signup_end:Date.yesterday
	end
=begin
	it "#new sets all bundles to variable" do
		get :new
		assigns(:projectbundles).count.should == 2
	end
=end

  it "Projectbundle cannot be verified if user is not logged in" do
    #get "/projectbundles/1/verify"
    get(:verify, {'projectbundle_id' => "1"})

    pbundle = Projectbundle.find_by_verified(true)
    pbundle.should == nil

  end

  it "Projectbundle cannot be verified if user is logged in as a teacher" do
    user = FactoryGirl.create(:teacher)
    session[:user_id] = user.id

    get(:verify, {'projectbundle_id' => "1"})

    pbundle = Projectbundle.find_by_verified(true)
    pbundle.should == nil

  end

  it "Projectbundle can be verified if user is logged in as an admin" do
    user = FactoryGirl.create(:admin)
    session[:user_id] = user.id

    create_signups_for_projectbundle(@projectbundle1)

    get(:verify, {'projectbundle_id' => "1"})

    pbundle = Projectbundle.find_by_verified(true)
    pbundle.should_not == nil

  end

  it "Projectbundle cannot be verified before deadline" do
    user = FactoryGirl.create(:admin)
    session[:user_id] = user.id

    @projectbundle1.signup_end = Date.tomorrow
    @projectbundle1.save

    get(:verify, {'projectbundle_id' => "1"})

    pbundle = Projectbundle.find_by_verified(true)
    pbundle.should == nil

  end

end
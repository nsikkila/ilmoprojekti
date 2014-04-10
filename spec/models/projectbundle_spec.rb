require 'spec_helper'

#dfsajsescribe User do
# pending "add some examples to (or delete) #{__FILE__}"
#end

describe Projectbundle do

  it "gets added to the database when created" do
    p = Projectbundle.create(name: "Testbundle", description: "Testdescription")

    expect(p.valid?).to be(true)
    expect(Projectbundle.count).to eq(1)

  end
=begin
  it "is not created if some else bundle already is active" do
    p = FactoryGirl.create(:projectbundle)

    s = Projectbundle.create(name:"FailiingTest", description: "testing failure", active:true)

    expect(s.valid?).to be_false
    expect(Projectbundle.count).to eq(1)
  end
=end


  it "is not created if data is faulty" do
    p = Projectbundle.create

    expect(p.valid?).to be(false)
    expect(Projectbundle.count).to eq(0)

  end

end
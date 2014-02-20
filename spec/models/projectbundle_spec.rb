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

  it "is not created if data is faulty" do
    p = Projectbundle.create

    expect(p.valid?).to be(false)
    expect(Projectbundle.count).to eq(0)

  end

end
require 'spec_helper'


describe Project do

  it 'removing a project removes associated signups' do
    p = create_project_with_enrollments

    #initial
    expect(Project.count).to eq 1
    expect(p.signups.count).to eq 2
    expect(Signup.count).to eq 2

    #remove
    p.destroy
    expect(Project.count).to eq 0
    expect(Signup.count).to eq 0
  end


  it 'removing a project does not delete unassociated signups' do
    p1 = create_project_with_enrollments
    p2 = FactoryGirl.create :project

    #initial
    expect(Project.count).to eq 2
    expect(p1.signups.count).to eq 2
    expect(Signup.count).to eq 2

    #remove
    p2.destroy
    expect(Project.count).to eq 1
    expect(Signup.count).to eq 2
  end
end

def create_project_with_enrollments
  p = FactoryGirl.create(:project)
  s1 = FactoryGirl.create(:signup, id:1, project_id:p.id, enrollment_id:1)
  s2 = FactoryGirl.create(:signup, id:2, project_id:p.id, enrollment_id:2)
  e1 = FactoryGirl.build(:enrollment, id:1)
  e2 = FactoryGirl.build(:enrollment, id:2)
  e1.save
  e2.save

  p
end


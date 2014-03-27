=begin
require 'spec_helper'
include TestHelper

describe "Projectpundle page" do
  describe "Projectbundle new" do

    it "should have correct fields in the page" do
       visit "projectbundles/new"

      expect(page).to have_content("Projektiryhmän nimi")

    end

  end
end
=end

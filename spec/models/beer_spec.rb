require 'spec_helper'

describe Beer do
  it "is saved when it has a name and a style" do
    beer = Beer.create name:"Testbeer", style:FactoryGirl.create(:style)

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved when it doesn't have a name" do
    beer = Beer.create style:FactoryGirl.create(:style)

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved when it doesn't have a style" do
    beer = Beer.create name:"Testbeer"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end

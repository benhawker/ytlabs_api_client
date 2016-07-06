require "spec_helper"

describe "roomallo API" do
  let(:roomallo_api) { RoomalloApi }

  it "is a module" do
    expect( roomallo_api ).to be_a( Module )
  end
end
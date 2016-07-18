require "spec_helper"

describe "roomallo API" do
  let(:ytlabs_api) { YTLabsApi }

  it "is a module" do
    expect( ytlabs_api ).to be_a( Module )
  end
end
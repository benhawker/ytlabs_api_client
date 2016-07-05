require 'spec_helper'

describe "RoomoramaAPI" do
  let(:roomallo_config) { RoomalloAPI::Config.new }

  describe "Config" do
    it "instantiates a config object" do
      expect(roomallo_config).to be_a (RoomalloAPI::Config)
    end
  end

  describe "#base_url" do
    it "responds with the base url" do
      expect(roomallo_config).to respond_to (:base_url)
      expect(roomallo_config.base_url).to eq ("https://api.ytlabs.co.kr/stage/v1/")
    end

  end
end
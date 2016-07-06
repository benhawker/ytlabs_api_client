require 'spec_helper'

describe "RoomoramaAPI" do
  ##Generates a 32 char length token.
  let(:token) { SecureRandom.hex(16) }
  let(:client) { RoomalloAPI::Client.new(token) }

  describe "Client" do
    it "instantiates a new client object" do
      expect(client).to be_a (RoomalloAPI::Client)
    end

    it "raises an error if a token is not valid" do
      bad_token = "123"
      expect { RoomalloAPI::Client.new(bad_token) }.to raise_error "Please pass a valid access token"
    end
  end

  describe "base_url" do
    it "responds with the base url" do
      expect(client).to respond_to (:base_url)
      expect(client.base_url).to eq ("https://api.ytlabs.co.kr/stage/v1")
    end
  end

  describe "#attribute_url" do
    it "build the endpoint URL correctly" do
      attribute = "properties"
      expect(client.attribute_url(attribute)).to eq "https://api.ytlabs.co.kr/stage/v1/properties/"
    end
  end

  describe "#setup" do

  end

end

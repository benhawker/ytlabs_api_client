require 'spec_helper'

describe "RoomoramaAPI" do
  ##Generates a 32 char length token.
  let(:token) { SecureRandom.hex(16) }
  let(:client) { RoomalloApi::Client.new(token) }

  describe "Client" do
    it "instantiates a new client object" do
      expect(client).to be_a (RoomalloApi::Client)
    end

    it "raises an error if a token is not valid" do
      error_message = "Your access token is not valid. It must be 32 characters long."
      bad_token = "123"
      expect { RoomalloApi::Client.new(bad_token) }.to raise_error (error_message)
    end
  end

  describe "base_url" do
    it "responds with the base url" do
      expect(client).to respond_to (:base_url)
      expect(client.base_url).to eq ("https://api.ytlabs.co.kr/stage/v1")
    end
  end

  describe "#build_url" do
    context "without identifier (i.e. a room hash/id)" do
      it "build the endpoint URL correctly" do
        action = "properties"
        expect(client.build_url(action)).to eq "https://api.ytlabs.co.kr/stage/v1/properties/"
      end
    end

    context "with an identifier (i.e. a room hash/id)" do
      it "build the endpoint URL correctly" do
        action = "properties"
        identifier = "123"
        expect(client.build_url(action, identifier)).to eq "https://api.ytlabs.co.kr/stage/v1/properties/"
      end
    end
  end

end

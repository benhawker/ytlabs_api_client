require 'spec_helper'

describe "RoomoramaAPI" do
  ## Generates a 32 char length token.
  let(:token) { SecureRandom.hex(16) }
  let(:content_type) { "json" }
  let(:client) { RoomalloApi::Client.new(token, content_type) }

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

  describe "#get_property" do
    context "with an invalid access token" do
      it "returns an Unauthorized response" do
        WebMock.allow_net_connect!
        expect(client.get_property("w_w0307360")).to include ( {"message"=>"Unauthorized"} )
      end
    end

    context "with a valid access token" do
      before do
        response = '[{ "property": "a property for you" }]'
        stub_request(:any, "https://api.ytlabs.co.kr/stage/v1/properties").to_return(:body => response, :status => 200, :headers => {})
      end

      it "returns a property within a parsed response" do
        client = RoomalloApi::Client.new(token, "json")
        response = client.get_properties
        expect(response).to eq response
      end
    end
  end

  private

  describe "#build_url" do
    context "without identifier (i.e. a room hash/id)" do
      it "builds the endpoint URL correctly" do
        stub_const("RoomalloApi::CLient::END_POINTS", { get_properties: "properties" } )
        action = "get_properties"
        expect(client.send(:build_url, action)).to eq "https://api.ytlabs.co.kr/stage/v1/properties"
      end
    end

    context "with an identifier (i.e. a room hash/id)" do
      it "builds the endpoint URL correctly" do
        stub_const("RoomalloApi::CLient::END_POINTS", { get_properties: "properties" } )
        action = "get_properties"
        identifier = "123"
        expect(client.send(:build_url, action, identifier)).to eq "https://api.ytlabs.co.kr/stage/v1/properties/123"
      end
    end
  end

  describe "#camelize_params_keys!(params_hash)" do
    it "modifies a Rubified set of params keys correctly" do
      params_hash = { :room_code => "123", :search_start_date => "456" }
      expect(client.send(:camelize_params_keys!, params_hash)).to eq ({"roomCode"=> "123", "searchStartDate"=> "456"})
    end

    it "it does not modify keys that are already camelized" do
      params_hash = { :roomCode => "123", :searchStartDate => "456" }
      expect(client.send(:camelize_params_keys!, params_hash)).to eq ({"roomCode"=> "123", "searchStartDate"=> "456"})
    end
  end

end

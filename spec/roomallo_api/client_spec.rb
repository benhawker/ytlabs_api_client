require 'spec_helper'

describe "RoomoramaAPI" do
  ## Generates a 32 char length token.
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

  describe "#get_property" do
    context "with an invalid access token" do
      it "returns an Unauthorized response" do
        expect(client.get_property("w_w0307360")).to eq {"message"=>"Unauthorized"}
      end
    end

    #TODO - Mock external service
    it "returns a property within a parsed response" do
      expect(client.get_property("w_w0307360")).to eq "something"
    end
  end

  describe "#build_url" do
    context "without identifier (i.e. a room hash/id)" do
      xit "build the endpoint URL correctly" do
        action = "properties"
        expect(client.send(:build_url, action)).to eq "https://api.ytlabs.co.kr/stage/v1/properties/"
      end
    end

    context "with an identifier (i.e. a room hash/id)" do
      xit "build the endpoint URL correctly" do
        action = "properties"
        identifier = "123"
        expect(client.send(:build_url, action, identifier)).to eq "https://api.ytlabs.co.kr/stage/v1/properties/"
      end
    end
  end

end



    # #Initial testing before removing to a module
    # def get_properties(params=nil)
    #   HTTParty.get(
    #     "#{build_url(__method__.to_s)}?#{transform_params(params)}",
    #     headers: { "Authorization" => token.to_s, "Content-Type" => "application/json" }
    #   )
    # end

    # def get_property(property_identifier, params=nil)
    #   HTTParty.get(
    #     "#{build_url(__method__.to_s, property_identifier)}?i18n=en-US",
    #     headers: { "Authorization" => token.to_s, "Content-Type" => "application/json" }
    #   )
    # end
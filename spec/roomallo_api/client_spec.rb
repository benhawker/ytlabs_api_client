require 'spec_helper'

describe RoomalloApi::Client do
  ## Generates a 36 char length token.
  let(:token) { SecureRandom.hex(18) }
  let(:content_type) { :json }
  let(:client) { described_class.new(token, content_type) }

  describe "Client" do
    it "instantiates a new client object" do
      expect(client).to be_a (RoomalloApi::Client)
    end

    context "token" do
      it "raises an error if a token is not valid" do
        error_message = "Your access token is not valid. It must be 36 characters long."
        bad_token = "123"
        expect { described_class.new(bad_token) }.to raise_error (error_message)
      end
    end

    context "content_type" do
      it "accepts json" do
        client = described_class.new(token, :json)
        expect(client.content_type).to eq "application/json"
      end

      it "accepts xml" do
        client = described_class.new(token, :xml)
        expect(client.content_type).to eq "application/xml"
      end

      it "does not content types other than json or xml" do
        error_message = "Your content type is invalid. 'json' or 'xml' are the 2 valid options"
        expect { described_class.new(token, :html) }.to raise_error (error_message)
      end
    end

    context "invalid/not implemented method/endpoint called" do
      it "raises when invalid endpoint is called" do
        error_message = 'This endpoint is not supported: Try one of these: ["get_properties", "get_property", "get_availability", "get_provinces", "get_cities", "get_extra_service_codes", "get_theme_codes", "get_reservations", "get_room_types", "get_property_room_types", "get_cancellation_charge", "post_reservation_request", "post_reservation_confirmation", "post_cancellation_request"]'
        expect { client.bob }.to raise_error.with_message (error_message)
      end
    end
  end

  describe "base_url" do
    it "responds with the base url" do
      expect(client).to respond_to (:base_url)
      expect(client.base_url).to eq ("https://api.ytlabs.co.kr/stage/v1")
    end
  end

  context "properties" do
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
          client = RoomalloApi::Client.new(token, :json)
          response = client.get_property("w_w0307360")
          expect(response).to eq response
        end
      end
    end

    describe "#get_properties" do
      context "with an invalid access token" do
        it "returns an Unauthorized response" do
          WebMock.allow_net_connect!
          expect(client.get_properties(:updated_at => "1970-01-01", :limit => 3)).to include ( {"message"=>"Unauthorized"} )
        end
      end

      context "with a valid access token" do
        before do
          response = '[{ "property": "a property for you" }, { "property_2": "another property for you" }]'
          url = "https://api.ytlabs.co.kr/stage/v1/properties?i18n=en-US&offset=0&limit=2&active=1&updatedAt=2016-05-24"
          stub_request(:any, url).to_return(:body => response, :status => 200, :headers => {})
        end

        it "returns 2 properties within a parsed response" do
          client = RoomalloApi::Client.new(token, :json)
          response = client.get_properties(updated_at: Date.today)
          expect(response).to eq response
        end
      end
    end

    describe "#get_room_types" do
      before do
        response = '[{ "room_type": "a room_type for you" }, { "room_type_2": "another room_type for you" }]'
        url = "https://api.ytlabs.co.kr/stage/v1/roomtypes?i18n=en-US&offset=0&limit=30&active=1&updatedAt=2016-05-24"
        stub_request(:any, url).to_return(:body => response, :status => 200, :headers => {})
      end

      it "returns 2 room_types within a parsed response" do
        client = RoomalloApi::Client.new(token, :json)
        response = client.get_room_types
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

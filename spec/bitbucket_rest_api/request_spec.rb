require 'spec_helper'
require 'bitbucket_rest_api/request'

describe BitBucket::Request do
  let(:fake_api) { (Class.new {
    include BitBucket::Request

    def connection(*any); end

    def new_access_token(*any); end
  })}
  let(:faraday_connection) { Faraday.new(:url => 'https://api.bitbucket.org') }

  describe "request" do
    it "raises an ArgumentError if an unsupported HTTP verb is used" do
      expect { fake_api.new.request(:i_am_a_teapot, {}, '/') }.to raise_error(ArgumentError)
    end

    context "with a connection" do
      before(:each) do
        allow_any_instance_of(fake_api).to receive(:connection).and_return(faraday_connection)
        allow_any_instance_of(fake_api).to receive(:new_access_token).and_return("12345")
      end

      it "supports get" do
        stub_request(:get, "https://api.bitbucket.org/1.0/endpoint").
          with(:headers => {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer 12345',
          'User-Agent' => "Faraday v#{Faraday::VERSION}"
        })

        fake_api.new.request(:get, '/1.0/endpoint', {}, {})
      end

      it "supports put" do
        stub_request(:put, "https://api.bitbucket.org/1.0/endpoint").
          with(:body => "{\"data\":{\"key\":\"value\"}}",
               :headers => {
            'Accept' => '*/*',
            'Content-Type'=>'application/x-www-form-urlencoded',
            'Authorization' => 'Bearer 12345',
            'User-Agent' => "Faraday v#{Faraday::VERSION}"
          })

        fake_api.new.request(:put, '/1.0/endpoint', { 'data' => { 'key' => 'value'} }, {})
      end

      it "supports patch" do
        stub_request(:patch, "https://api.bitbucket.org/1.0/endpoint").
          with(:body => "{\"data\":{\"key\":\"value\"}}",
               :headers => {
            'Accept' => '*/*',
            'Content-Type'=>'application/x-www-form-urlencoded',
            'Authorization' => 'Bearer 12345',
            'User-Agent' => "Faraday v#{Faraday::VERSION}"
          })

        fake_api.new.request(:patch, '/1.0/endpoint', { 'data' => { 'key' => 'value'} }, {})
      end

      it "supports delete" do
        stub_request(:delete, "https://api.bitbucket.org/1.0/endpoint").
          with(:headers => {
          'Accept' => '*/*',
          'Authorization' => 'Bearer 12345',
          'User-Agent' => "Faraday v#{Faraday::VERSION}"
        })
        fake_api.new.request(:delete, '/1.0/endpoint', {}, {})
      end

      it "supports post" do
        stub_request(:post, "https://api.bitbucket.org/1.0/endpoint").
          with(:body => "{\"data\":{\"key\":\"value\"}}",
               :headers => {
            'Accept' => '*/*',
            'Content-Type'=>'application/x-www-form-urlencoded',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization' => 'Bearer 12345',
            'User-Agent' => "Faraday v#{Faraday::VERSION}"
          })

        fake_api.new.request(:post, '/1.0/endpoint', { 'data' => { 'key' => 'value'} }, {})
      end
    end
  end
end

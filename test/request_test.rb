require 'test_helper'
require 'http_magic/uri'
require 'http_magic/request'

describe 'HttpMagic::Request' do
  before do
    @domain = 'example.com'
    @uri = HttpMagic::Uri.new(@domain)
  end

  it 'should make a request' do
    stub_request = stub_request(
      :get,
      "https://#{@domain}/api/v2/path/to/something"
    )

    @uri.namespace = 'api/v2'
    @uri.parts = ['path', 'to', 'something']
    request = HttpMagic::Request.new(@uri)
    request.get

    assert_requested stub_request
  end

  it 'should return content on request' do
    content = 'This is SPARTA!'
    stub_request(:get, "https://#{@domain}").
      to_return(body: content)

    request = HttpMagic::Request.new(@uri)

    assert_equal content, request.get
  end

  it 'should be able to delete a resource' do
    stub_request = stub_request(:delete, "https://#{@domain}").
      to_return(status: 204)

    request = HttpMagic::Request.new(@uri)
    request.delete

    assert_requested stub_request
  end

  it 'should be able to post data as hash' do
    expected_data = {
      apple: 'crispy',
      banana: 'soft'
    }
    stub_request = stub_request(:post, "https://#{@domain}").with(
      body: expected_data.to_json,
      headers: { 'content-type' => 'application/json' }
    )

    request = HttpMagic::Request.new(@uri, data: expected_data)
    request.post

    assert_requested stub_request
  end

  it 'should be able to put data as hash' do
    expected_data = {
      apple: 'crispy',
      banana: 'soft'
    }
    stub_request = stub_request(:put, "https://#{@domain}").with(
      body: expected_data.to_json,
      headers: { 'content-type' => 'application/json' }
    )

    request = HttpMagic::Request.new(@uri, data: expected_data)
    request.put

    assert_requested stub_request
  end

  it 'should set correct headers' do
    stub_request = stub_request(:get,  "https://#{@domain}").
      with(headers: { 'X-AuthToken' => 'test_token' })

    request = HttpMagic::Request.new(
      @uri,
      headers: { 'X-AuthToken' => 'test_token' }
    )
    request.get

    assert_requested stub_request
  end
end

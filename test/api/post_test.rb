require 'test_helper'
require 'http_magic'

class HttpMagicTest < HttpMagic::Api
end

describe 'HttpMagic#post' do
  before do
    @url = HttpMagicTest.url 'www.example.com'
    HttpMagicTest.namespace nil
    HttpMagicTest.headers nil
  end

  it 'should send POST request' do
    stub_post = stub_request(:post, "https://#{@url}")

    HttpMagicTest.post
    assert_requested stub_post
  end

  it 'should send data with POST request' do
    expected_data = {
      apple: 'sauce',
      banana: 'bread'
    }
    stub_post = stub_request(:post, "https://#{@url}/foo").with(
      body: expected_data
    )

    HttpMagicTest.foo.post(expected_data)

    assert_requested stub_post
  end
end

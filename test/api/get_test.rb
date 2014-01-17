require 'test_helper'
require 'http_magic'

class HttpMagicTest < HttpMagic::Api
end

describe 'HttpMagic#get' do
  before do
    @url = HttpMagicTest.url 'www.example.com'
    HttpMagicTest.namespace nil
    HttpMagicTest.headers nil
  end

  it 'should return the root response' do
    stub_request(:get, "https://#{@url}:443").
      to_return(body: 'I am root!!')

    assert_equal(
      'I am root!!',
      HttpMagicTest.get
    )
  end

  it 'should return the named resource' do
    stub_request(:get, "https://#{@url}:443/bar").
      to_return(body: 'A bear walked into a bar...')

    assert_equal(
      'A bear walked into a bar...',
      HttpMagicTest.bar.get
    )
  end

  it 'should return the named resource' do
    stub_request(:get,  "https://#{@url}:443/bar/84").
      to_return(body: 'Where Everybody Knows Your Name')

    assert_equal(
      'Where Everybody Knows Your Name',
      HttpMagicTest.bar[84].get
    )
  end

  it 'should serialize JSON objects' do
    stub_request(:get,  "https://#{@url}:443/bar/99").
      to_return(
        headers: { 'Content-Type' => 'application/json' },
        body: fixture_file('projects.json')
      )

    assert_equal(
      'GradesFirst',
      HttpMagicTest.bar[99].get.first['name']
    )
  end

  it 'should provide specified headers' do
    stub_request(:get,  "https://#{@url}:443/bar/84").
      with(headers: { 'X-AuthToken' => 'test_token' }).
      to_return(body: 'Where Everybody Knows Your Name')

    HttpMagicTest.headers({ 'X-AuthToken' => 'test_token' })
    assert_equal(
      'Where Everybody Knows Your Name',
      HttpMagicTest.bar[84].get
    )
  end
end

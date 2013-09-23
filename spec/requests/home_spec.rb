require 'spec_helper'

describe "Stub ajax request", js: true do

  context 'a simple path' do
    let(:message) { 'my custom message' }
    let(:api_path) { '/api/path' }

    before do
      stub_ajax url: api_path, responseText: { message: message }
      stub_ajax url: 'api/other_path', responseText: { message: message }
      visit home_index_path
    end

    it 'stubs the ajax request and returns the correct message' do
      page.execute_script("$.getJSON('#{api_path}', function(data) { $('#message_container').html(data.message) })")
      wait_until do
        page.find('#message_container').has_content? message
      end
    end
  end

  context 'a path with a regexp' do

    let(:message)  {'my custom message' }
    let(:api_path) { /\/api\/v\d+\/path/ }

    before do
      stub_ajax url: api_path, responseText: { message: message }
      visit home_index_path
    end

    it 'stubs matching requests' do
      page.execute_script("$.getJSON('/api/v1/path', function(data) { $('#message_container').html(data.message) })")
      wait_until do
        page.find('#message_container').has_content? message
      end
    end

    it 'does not stub not-matching requests' do
      page.execute_script("$.getJSON('/api/vx/path', function(data) { $('#message_container').html(data.message) })")
      expect do
        wait_until do
          page.find('#message_container').has_content? message
        end
      end.to raise_error Capybara::TimeoutError
    end

  end

end

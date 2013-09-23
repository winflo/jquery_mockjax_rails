require 'spec_helper'

describe JqueryMockjaxRails do

  context 'mockjax_representation' do

    it 'converts a stub to its json representation' do
      JqueryMockjaxRails.mockjax_representation(url: "/api/path").should == '{"url":"/api/path"}'
    end

    it 'converts a url regexp' do
      JqueryMockjaxRails.mockjax_representation(url: /\/api\/v\d+\/path/).should == '{"url":/\\/api\\/v\\d+\\/path/}'
    end

  end

end

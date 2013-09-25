module JqueryMockjaxRails
  class << self
    def stub args
      stubs << args
    end

    def stubs
      @stubs ||= []
    end

    def clean
      stubs = []
    end

    def js_path
      @js_path ||= '/assets/jquery.mockjax.js'
    end

    def mockjax_representation(stub)
      stub[:url] = resolve_regexp stub[:url]
      stub.to_json.gsub("\\\\", "\\").gsub('"REGEXP_START', '').gsub('REGEXP_END"', '')
    end

    def resolve_regexp(url)
      case url
      when Regexp
        "REGEXP_START#{url.inspect}REGEXP_END"
      else
        url
      end
    end

    def js_output
      stubs.map do |stub|
        "jQuery.mockjax(#{mockjax_representation(stub)})"
      end.join(";\n")
    end
  end
end

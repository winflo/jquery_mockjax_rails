class JqueryMockjaxMiddleware
  def initialize app
    @app = app
  end

  def call env
    status, headers, response = @app.call(env)
    append_mockjaxes response
    [status, headers, response]
  end

  private
    def append_mockjaxes response
      if response.is_a?(ActionDispatch::Response) && response.response_code == 200
        response.body = response.body.gsub!(
          /(<\/head>)/,
          %Q{
            <script src='#{JqueryMockjaxRails.js_path}' type='text/javascript'></script>
            <script type='text/javascript'>if(typeof($.fn.select2)=='function'){$.fn.select2.ajaxDefaults.transport = $.ajax}</script>\\1
            <script type='text/javascript'>#{JqueryMockjaxRails.js_output}</script>\\1
          }.squish
        )
      end
    end
end

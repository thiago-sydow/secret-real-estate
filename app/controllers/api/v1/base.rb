module API
  module V1
    class Base < Dispatch
      format :json
      version 'v1'
      default_error_formatter :json
      content_type :json, 'application/json'

      rescue_from Pundit::NotAuthorizedError do |e|
        opts = { error: "You have insuficient permissions." }
        Rack::Response.new(opts.to_json, 403, {
          'Content-Type' => "application/json",
          'Access-Control-Allow-Origin' => '*',
          'Access-Control-Request-Method' => '*',
        }).finish
      end

      rescue_from :all do |e|
        eclass = e.class.to_s
        status = case
        when eclass.match('RecordNotFound'), e.message.match(/unable to find/i).present?
          404
        else
          (e.respond_to? :status) && e.status || 500
        end
        opts = { error: "#{e.message}" }
        opts[:trace] = e.backtrace[0,10] unless Rails.env.production?
        Rack::Response.new(opts.to_json, status, {
          'Content-Type' => "application/json",
          'Access-Control-Allow-Origin' => '*',
          'Access-Control-Request-Method' => '*',
        }).finish
      end

      # mount API::V1::Users
      mount API::V1::Properties

      route :any, '*path' do
        raise StandardError, "Unable to find endpoint"
      end
    end
  end
end

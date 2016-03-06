require 'grape-swagger'

module API
  class Dispatch < Grape::API
    mount API::V1::Base

    add_swagger_documentation hide_documentation_path: true, api_version: 'v1', base_path: '/api'

    route :any, '*path' do
      Rack::Response.new({message: "Not found"}.to_json, 404).finish
    end
  end

  Base = Rack::Builder.new do
    use API::Logger
    run API::Dispatch
  end
end

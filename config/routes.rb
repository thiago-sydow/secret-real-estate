SecretRealEstate::Application.routes.draw do

  mount API::Base => '/api/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end

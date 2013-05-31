module HerokuRequestId
  class Railtie < Rails::Railtie
    initializer 'heroku_request_id.add_middleware' do |app|
      app.config.middleware.insert_before "ActionDispatch::RequestId", "HerokuRequestId::Middleware"
    end
  end
end

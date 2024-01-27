Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:5100', '127.0.0.1:5100' # later change to the domain of the frontend app
    resource '*',
      headers: :any,
      expose: ['access-token', 'expiry', 'token-type', 'Authorization', 'X-CSRF-Token'],
      methods: %i[get post put patch delete options head]
  end
end
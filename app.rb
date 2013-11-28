require 'bundler'
Bundler.require

class App < Sinatra::Base
  enable :prefixed_redirects

  get '/' do
    redirect 'hello'
  end
  get '/hello' do
    haml :hello
  end
end

App.run!

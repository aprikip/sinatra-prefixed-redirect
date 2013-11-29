sinatra-prefixed-redirects
=========================
This is a sample sinatra app using prefixed-redirects enabled.

## Why prefixed-redirects?
In almost all how-to sites, a sinatra app runs with its proper web server, like `ruby app.rb` from the shell.  In that case, all requests are placed in the root directory of the server.  We can write the URI path patterns like

```ruby:app.rb
get '/index' do
    haml :index
end
```
and so on.  These codes can run on the apache web server with phusion passenger properly, if we describe the proper settings on httpd.conf,

```conf:httpd.conf
RackBaseURI /sinatra/app1
RackBaseURI /sinatra/app2
```
and make a symbolic links from the server document root.

```shell:
ln -s /var/www/sinatra/app1/public /usr/local/www/data/app1
ln -s /var/www/sinatra/app2/public /usr/local/www/data/app2
```
With these codes, we can get the rendered `index.haml` when we access to `http://some.server/sinatra/app1`. :)

However, `Sinatra#redirect` cannot handle these settings properly.

```ruby:app.rb
get '/' do
  redirect '/index'
end
get '/index' do
  haml :index
end
```

With these codes, when we accessed `http://some.server/sinatra/app1/`, the server redirects us to `http://some.server/index`, not to `http://some.server/sinatra/app1/index` which we expected.

To avoid this mis-redirection, we should use `enable :prefixed_redirects`.

```ruby:app.rb
class App << Sinatra::Base
  enable :prefixed_redirects
  get '/' do
    redirect '/index'
  end
  get '/index' do
    haml :index
  end
end
App.run!
```
 These codes redirect us to the expected URI, in both WEBrick and apache+passenger environments.  Happy!

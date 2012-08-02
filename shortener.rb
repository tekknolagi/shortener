require 'sinatra'
require 'redis'
require 'erb'

configure do
  def randstr(length)
    rand(36**length).to_s 36
  end

  def constr_url(host, port)
    if port == "80" || port == 80
      return host
    else
      return host+":"+port
    end
  end

  $redis = Redis.new
  $len = 5
  $url = "YOUR_URL_HERE"
  $port = "80"
  $baseurl = constr_url($url, $port)
end

get "/" do
  erb :index
end

post "/" do
  url = params[:url]
  unless url.match(/http\:\/\//)
    url = "http://"+url
  end
  rand = randstr($len)
  while $redis.get "links:#{rand}"
    rand = rand+randstr(1)
  end
  $redis.set "links:#{rand}", url
  @rand = rand
  @link_to = $baseurl+File.join($port,@rand)
  erb :index
end

get "/:code" do
  code = params[:code]
  $redis.incr "views:#{code}"
  redirect $redis.get "links:#{code}" || "/"
end

%w(i info).each do |path|
  get "/#{path}/:code" do
    @code = params[:code]
    @link_to = File.join($baseurl, @code)
    @end_url = $redis.get "links:#{@code}" || "none"
    @views = $redis.get "views:#{@code}" || 0
    erb :info
  end
end

__END__

@@index
<form action="/" id="url-form" method="post">
<input type="text" name="url" id="url-input" value="<%= @url %>" /><input type="submit" value="shorten" />
</form>
<% if @rand %>
<a href="/<%= @rand %>"><%= @link_to %></a>
<% end %>

@@info
<link rel="stylesheet" type="text/css" src="styles.css" />
<a href="/">Home</a>
<br>
<br>
<div id="info">
Short URL: <%= @link_to %><br />
Links to: <% @end_url %><br />
Views: <%= @views %><br />
</div>

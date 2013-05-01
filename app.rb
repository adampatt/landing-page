require 'yaml'

require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'
require 'gibbon'

Bundler.require(:default)

if ENV['RACK_ENV'] != 'production'
  config = YAML.load_file('./config.yml')
  config.each do |k,v|
    ENV[k] = v
  end
end

class LandingPage < Sinatra::Base
  get '/' do
    erb :index, :layout => :layout
  end

  post '/submit' do
    gb = Gibbon.new
    puts gb.inspect
    gb.listSubscribe( {
      :id => ENV['MAILCHIMP_LIST_ID'],
      :double_optin => false,
      :email_address => params[:email],
      :update_existing => true
    })
    redirect '/thanks'
  end

  get '/thanks' do
    erb :thanks, :layout => :layout
  end
end

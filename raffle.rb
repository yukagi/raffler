$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'lib/authorization'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/entries.db")

class Entry

	include DataMapper::Resource
	property :id, 			Serial
	property :first, 		String
	property :last, 		String
	property :email, 		String
	property :created_at,	DateTime	

end

configure :development do
	# Create or upgrade all tables at once
	DataMapper.auto_upgrade!
end

before do
	headers "Content-Type" => "text/html; charset=utf-8"
end

helpers do
	include Sinatra::Authorization
end

enable :sessions

get '/' do
	@title = "Enter to win a rad Timbuk2 bag!"
	erb :welcome
end

post '/' do
	@entry = Entry.new(params[:entry])

	if @entry.save
		redirect('/thanks')
	else
		redirect('/')
	end
end

get '/thanks' do
	erb :thanks
end

get '/list' do
	require_admin
	@title = "List of Entries"
	@entries = Entry.all(:order => [:created_at.desc])
	erb :list
end

get '/delete/:id' do
	require_admin
	entry = Entry.get(params[:id])
	unless entry.nil?
		entry.destroy
	end
	redirect('/list')
end   


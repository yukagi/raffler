$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'sinatra/base'
require 'data_mapper'
require 'lib/authorization'
require 'pony'

class Raffler < Sinatra::Base
#	DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/entries.db")
	DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://#{Dir.pwd}/entries.db')
	# This is the code for connecting to Postgres with a hard-coded path, not currently working.
	# 'postgres://#{Dir.pwd}/log/entries'

	set :static, true

	class Entry

		include DataMapper::Resource
		property :id, 			Serial
		property :first, 		String, :required => true
		property :last, 		String, :required => true
		property :email, 		String, :required => true
		property :created_at,	DateTime	

	#	validates_with_method :email, :method => :isAppleEmail?

		def isAppleEmail?
			if @email =~ /\A[^@\s]+(@apple.com)\Z/
				return true
			else
			 	return [false, "You must enter your Apple email address"]
			end
		end
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
		@errors = session[:errors]
		erb :welcome
	end

	post '/' do
		@entry = Entry.new(params[:entry])

		if @entry.save
			session[:id] = @entry.id
			session[:first] = @entry.first
			
			puts "ID: #{@entry.id}"
			puts "Session ID: #{session[:id]}"

			redirect('/thanks')
		else
			session[:errors] = @entry.errors.values.map{|e| e.to_s}
			redirect('/')
		end
	end

	get '/thanks' do
		puts "Thanks ID: #{session[:id]}"
		@id = session[:id]
		@first = session[:first]
		@entry = Entry.get(@id)

#		Pony.mail(:to => @entry.email, :from => "example@raffler.com", 
#						:subject => "Thanks for entering!", 
#						:headers => { "Content-Type" => "text/html" },
#						:body => (erb :thanks))
		erb :thanks
	end

	get '/list' do
		require_admin
		@title = "List of Entries"
		@entries = Entry.all(:order => [:created_at.desc])
		erb :list
	end

	get '/delete/:id' do
		entry = Entry.get(params[:id])
		unless entry.nil?
			entry.destroy
		end
		redirect('/list')
	end
end



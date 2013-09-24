require 'bundler/setup'
require 'sinatra'
require 'sinatra/respond_to'
require "active_support/core_ext"
Sinatra::Application.register Sinatra::RespondTo
set :environment, :development

get '/' do
	File.read(File.join('public', 'index.html'))
end

get '/spellchecker.?:format?' do
	params[:language] ||= "en_US"
	word = params[:word].gsub(/[^a-zA-Z]/, '') # For now, only allow a-Z
	data = Frugard::Spellchecker.check(
		word.downcase,
		:suggestions_when_correct => params[:suggestions_when_correct],
		:language									=> params[:language]
	)

	respond_to do |format|
		format.html{erb :spellchecker, :locals => {:data => data}}
		format.json{            
			content_type "application/json"
      data.to_json
    }
    format.xml{            
			content_type "application/xml"
      data.to_xml
    }
	end
end
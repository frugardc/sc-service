require 'bundler/setup'
require 'sinatra'
require 'sinatra/respond_to'
require "active_support/core_ext"
Sinatra::Application.register Sinatra::RespondTo
set :environment, :development
CHECKER = Frugard::Spellchecker
get '/spellchecker.?:format?' do
	# For now, only allow a-Z
	word = params[:word].gsub(/[^a-zA-Z]/, '')
	data = CHECKER.check(word.downcase,:suggestions_when_correct => params[:suggestions_when_correct])
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
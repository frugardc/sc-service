require 'bundler/setup'
require 'sinatra'
require 'sinatra/respond_to'
require "active_support/core_ext"
require "sinatra/multi_route"
Sinatra::Application.register Sinatra::RespondTo
set :environment, :development
# Index Helpfile
get '/' do
	File.read(File.join('public', 'index.html'))
end
route :get, :post, '/spellchecker.?:format?' do
	# Post a word to the spellchecker resource, receive a boolean response of :correct along
	# 	with suggestions when incorrect.  Options of:
	#	     :word 											(the word to spellcheck)
	#      :format										(:json,:XML,:html currently supported)
	#      :language 									(es and en_US currently supported)
	#      :suggestions_when_correct 	(similarly spelled words returned even if :word is correct)
	#
	params[:language] ||= "en_US"
	word = params[:word].gsub(/[^a-zA-Z]/, '') # For now, only allow a-Z
	data = Frugard::Spellchecker.check(
		word,
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
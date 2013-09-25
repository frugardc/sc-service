require 'bundler/setup'
require 'sinatra'
require 'sinatra/respond_to'
require "active_support/core_ext"
require "sinatra/multi_route"
Sinatra::Application.register Sinatra::RespondTo


SUPPORTED_FORMATS =	["xml","html","json"]
# Index Helpfile
get '/' do
	File.read(File.join('public', 'index.html'))
end

def validate_params(params)
	@errors = []
	unless params[:word]
		@errors << "Word to check is unset.  Make sure you specify the :word parameter."
	end
	if params[:format] and !SUPPORTED_FORMATS.include?(params[:format])
		@errors << ["Format #{params[:format]} is not supported.  Please select one of #{SUPPORTED_FORMATS.join(",")}"]
	end
	halt 422# unless @errors.empty?
end

route :get, :post, '/spellchecker.?:format?' do
	# Post a word to the spellchecker resource, receive a boolean response of :correct along
	# 	with suggestions when incorrect.  Options of:
	#	     :word 											(the word to spellcheck)
	#      :format										(:json,:XML,:html currently supported)
	#      :language 									(es and en_US currently supported)
	#      :suggestions_when_correct 	(similarly spelled words returned even if :word is correct)
	#
	
	validate_params(params)

	params[:language] ||= "en_US"
	word = params[:word].to_s.gsub(/[^a-zA-Z]/, '') # For now, only allow a-Z
	data = Frugard::Spellchecker.check(
		word,
		:suggestions_when_correct => params[:suggestions_when_correct],
		:language									=> params[:language]
	)
	data[:resource] = request.path_info
	data[:full_path] = request.fullpath
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
# Errors
not_found do
  data = {:error => 404, :message => "404 Resource Not Found", :resource => request.path_info, :full_path => request.fullpath}
	respond_to do |format|
		format.html{erb :error, :locals => {:data => data}}
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

error do
  data = {:error => 500, :message => "500 Application Error", :resource => request.path_info, :full_path => request.fullpath}
	respond_to do |format|
		format.html{erb :error, :locals => {:data => data}}
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

error 422 do
  data = {:error => 422, :message => "422 Unprocessible", :errors => @errors, :resource => request.path_info, :full_path => request.fullpath}
	respond_to do |format|
		format.html{erb :error, :locals => {:data => data}}
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
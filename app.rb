require 'sinatra'
require 'json'
require 'ffi/aspell'
set :environment, :development
CHECKER = Frugard::Spellchecker
get '/word/:word' do
	CHECKER.check(params[:word],:suggestions_when_correct => params[:suggestions_when_correct]).to_json
end
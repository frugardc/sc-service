require 'ffi/aspell'
module Frugard
	class Spellchecker
		def self.check(word,options={})
			return_vals 					= {}
			return_vals[:suggestions] = []
			options[:language]		||= 'en_US'
			aspeller 							= FFI::Aspell::Speller.new(options[:language], :encoding => 'utf-8')
			return_vals[:word]		= word
			return_vals[:correct]	= aspeller.correct?(word)
			if !return_vals[:correct] or options[:suggestions_when_correct]
				return_vals[:suggestions] = aspeller.suggestions(word)
			end
			return_vals
		end
	end
end
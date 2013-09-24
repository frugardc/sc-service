ASpellchecker
=========

REST Spellchecking Web Service utilizing [GNU Aspell ](http://aspell.net/ "ASpell") running in Sinatra.

Installation:
  - This is only tested on Ubuntu Linux with ruby 1.9.3.  You will need aspell and whatever language dictionary you wish to support.  This Web Service will support US English and Spanish, and as a result must be installed with:

        sudo apt-get install aspell aspell-en aspell-es

  - Verify ffi-aspell works

        $ gem install 'ffi-aspell' 
        Successfully installed ffi-aspell-0.0.3
        1 gem installed
        Installing ri documentation for ffi-aspell-0.0.3...
        Installing RDoc documentation for ffi-aspell-0.0.3...
        $ irb
        1.9.3p194 :002 > require 'ffi/aspell'
         => true 
        1.9.3p194 :003 > FFI::Aspell::Speller.new("en_US", encoding: 'utf-8').correct?("hello")
         => true

  - If you get an error where ruby cannot find the aspell library, you may need to do something along the lines of...
 
        sudo ln /usr/lib/libaspell.so.15.2.0 /usr/lib/libaspell.so, then try the above again

  - Then proceed        

        git clone git@github.com:frugardc/sc-service.git
        cd sc-service
        bundle install
        cucumber # run the tests to make sure we are all good
        rackup
  
  Documentation of the Spellchecker available at http://aspellchecker.info
  


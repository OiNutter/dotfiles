# Install ruby versions and set the global default

rbenv install 1.9.3-p484
rbenv install 2.1.0

rbenv global 2.1.0

rbenv rehash

gem install skeletor rails sinatra thor sass redcarpet albino nokogiri compass sprockets powify

rbenv rehash

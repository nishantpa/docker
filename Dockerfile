### Dockerfile for local Webdev - pullup
# @nishantpatel
	# 2 Sep 2017 --> Tested on OSX only
	# To run locally, the following is needed:
	# 	- Install Docker Toolbox for your machine
	# The following steps outline how to run pullup's website for local development. Copy/Paste exactly:
	#	
	# 	1) Clone it!
	# 		git clone https://github.com/jasperdavey/pullup-website.git
	# 	NOTE: If you run into issues cloning, do the following, and replace the uppercased with your creds:
	# 		git clone https://USERNAME:PASSWORD@github.comjasperdavey/pullup-website.git 
	#	
	# 	2) Build the image 
	# 		docker build -t pullup .
	# 	NOTE: This step will take a little while, about a minute. 
	#	
	# 	3) Get the image ID of the "pullup" image. You will need it for the next step.
	# 		docker image ls
	# 		Copy the image ID. 
	#
	# 	4) Run the container of the image you just built. Make sure you are in the same directory you cloned the repo into.
	# 		docker container run --rm -ti -p 3000:3000 -v $(pwd):/var/www.local-wev _PASTE IMAGE ID HERE_
	#	
	#	5) To start the server in the container, run the following:
	#		bundle exec rails server -b 0.0.0.0
	#	
	# 	6) Go to Chrome. In the URL, type in http://192.168.99.100:3000/ 
	#	
	# 	You can develop on the host machine. When you want to test, refresh and iterate. 



FROM ruby:2.4.1-slim
MAINTAINER Nishant Patel <nishantpatel0@yahoo.com>

# Install packages
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libsqlite3-dev nodejs git vim

# Define where our application will live
ENV RAILS_ROOT /var/www/local-web

# Create application home
RUN mkdir -p $RAILS_ROOT/tmp/pids

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Use the Gemfiles as Docker cache markers
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler

# Finish establishing our Ruby enviornment
RUN bundle install

# Copy the Rails application into place
COPY . .

# Local dev setup
RUN rake db:setup \
	&& rake db:migrate

EXPOSE 3000

# To execute when container runs on its own
CMD ["/bin/bash"]
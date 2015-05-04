# Ruby requires
require 'yaml'

# required gems
require 'active_support/core_ext/class/attribute'
require 'elasticsearch/persistence'
require 'elasticsearch/persistence/model'
require 'elasticsearch/persistence/repository'
require 'octokit'
require 'thor'

# Gem Info
require 'mcstuffins/version'

# Models
Dir[File.join(File.dirname(__FILE__), 'mcstuffins/models/**/*.rb')].each{|f| require f}

# Repositories
Dir[File.join(File.dirname(__FILE__), 'mcstuffins/repositories/**/*.rb')].each{|f| require f}

# CLI
require 'mcstuffins/config'
require 'mcstuffins/cli/exiting_thor'
require 'mcstuffins/cli/collect'
require 'mcstuffins/doc'

Octokit.auto_paginate = true

# Uncomment the code below if you would like to know what requests are made to GitHub

# stack = Faraday::RackBuilder.new do |builder|
#   builder.response :logger
#   builder.use Octokit::Response::RaiseError
#   builder.adapter Faraday.default_adapter
# end
# Octokit.middleware = stack

module McStuffins
    # Your code goes here...
end

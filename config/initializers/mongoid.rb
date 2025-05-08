# rubocop:todo all

# Enable Mongo driver query cache for Rack
Rails.application.config.middleware.use(Mongo::QueryCache::Middleware)
 
# Enable Mongo driver query cache for ActiveJob
ActiveSupport.on_load(:active_job) do
  include Mongo::QueryCache::Middleware::ActiveJob
end

Rails.application.configure do
  config.after_initialize do
    # Change Mongoid log destination and level
    Mongoid.logger = Logger.new(STDERR).tap do |logger|
      logger.level = ENV.fetch("MONGODB_LOG_LEVEL", "debug")
    end
    # Change driver log destination and level
    Mongo::Logger.logger = Logger.new(STDERR).tap do |logger|
      logger.level = ENV.fetch("MONGODB_LOG_LEVEL", "debug")
    end
  end
end

require 'logger'
Delayed::Job.establish_connection 'delayed_job'
Delayed::Job.table_name = 'delayed_jobs'
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 1
silence_warnings do
  #Delayed::Job.const_set("MAX_ATTEMPTS", 3)
  #Delayed::Job.const_set("MAX_RUN_TIME", 30.seconds)
end
#Delayed::Worker.logger = Rails.logger
logger = Logger.new(File.join(Rails.root, 'log', 'dj.log'))
logger.datetime_format = '%Y-%m-%d %H:%M:%S'
#logger.level = Logger::ERROR
Delayed::Worker.logger = logger

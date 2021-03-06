require './config/boot'
require './config/environment'
require 'clockwork'
require 'delayed_job_active_record'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  # handler receives the time when job is prepared to run in the 2nd argument
  # handler do |job, time|
  #   puts "Running #{job}, at #{time}"
  # end

  every(10.seconds, 'frequent.job') {
    Delayed::Job.enqueue SendMailJob.new('Track send mail failed'), :priority => 1
  }
  #every(3.minutes, 'less.frequent.job')
  #every(1.hour, 'hourly.job')
  #
  #every(1.day, 'midnight.job', :at => '00:00')
end
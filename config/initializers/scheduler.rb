require 'rubygems'
require 'rufus/scheduler'
require './scripts/get_bangumis.rb'

scheduler = Rufus::Scheduler.singleton

scheduler.every("30m") do
  GetBangumis.start
end

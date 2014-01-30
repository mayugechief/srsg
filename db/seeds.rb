# coding: utf-8

if name = ENV["name"].presence
  require "#{Rails.root}/db/seeds/#{name}/load.rb"
end

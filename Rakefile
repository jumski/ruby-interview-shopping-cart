# frozen_string_literal: true

require 'rake/testtask'

PKG_NAME = 'karnov-wojciech-majewski.zip'
BUILD_FILES = FileList['*.rb', 'Rakefile', 'README.md']

task default: :test

desc 'Run tests'
Rake::TestTask.new do |t|
  t.test_files = FileList['*_test.rb']
end

desc 'Build package'
task build: :test do
  puts
  puts "-- Creating #{PKG_NAME}"
  system("zip #{PKG_NAME} #{BUILD_FILES.join(' ')}")
  puts "-- Package #{PKG_NAME} created"
end 

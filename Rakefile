# frozen_string_literal: true

require 'rake/testtask'

task default: :test

desc 'Run tests'
Rake::TestTask.new do |t|
  t.test_files = FileList['*_test.rb']
end

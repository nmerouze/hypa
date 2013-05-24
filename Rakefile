require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test_*.rb']
  # t.ruby_opts = ["-w"]
  t.verbose = true
end

task :default => :test
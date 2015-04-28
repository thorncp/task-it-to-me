require 'rake/testtask'
require 'rubygems'

Rake::TestTask.new do |t|
  t.libs.push 'test'
  t.pattern = 'test/**/*_test.rb'
end

desc 'Generates a coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end

desc 'Generate reek report in "metrics/reek.txt"'
task :reek do
  `reek lib > metrics/reek.txt`
end

desc 'Generate Flog scoring in "metrics/flog.txt"'
task :flog do
  `flog -a -c -d -s -v lib > metrics/flog.txt`
end

desc 'Generate rubycritic report "metrics/flog.txt"'
task :rubycritic do
  `rubycritic lib --path=metrics/rubycritic`
end

task :default => [:coverage, :rubycritic]

# ----------

desc 'Open coverage and critic reports'
task :view_metrics do
  `open metrics/coverage/index.html`
  `open metrics/rubycritic/overview.html`
end

desc 'Open coverage report (OSX only)'
task :view_coverage do
  `open metrics/coverage/index.html`
end

desc 'Open rubycritic report (OSX only)'
task :view_rubycritic do
  `open metrics/rubycritic/overview.html`
end


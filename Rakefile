# require "bundler/gem_tasks"
# task :default => :spec

require "rake"
require "rake/clean"

CLEAN.include("**/*.gem", ".yardoc/", "doc/yard")

namespace :docs do
  require "yard"

  YARDDIR = "./doc/yard"

  YARDOPTS = [
    "--db=#{YARDDIR}/.yardoc",
    "--markup=markdown",
    "--no-private",
    "--output-dir=#{YARDDIR}"
  ]

  desc "Remove built documentation files from project directory."
  task :cleanup do
    require "pathname"
    dirs = [".yardoc", "doc/yard"]
    dirs.each { |d|
      dir = Pathname.new("#{__dir__}/#{d}")
      dir.exist? and dir.rmtree
    }
  end

  desc "Generate new documentation from source."
  # task :build
  YARD::Rake::YardocTask.new(:build) do |t|
    Rake::Task["docs:cleanup"].invoke

    t.files   = ["lib/**/*.rb"]
    t.options = YARDOPTS
  end

  desc "Start the YARD server."
  task :server do
    system "yard", "server", "--reload"
  end
end

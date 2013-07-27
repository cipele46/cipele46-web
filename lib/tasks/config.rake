namespace :config do
  desc "Copy example config files."
  task :defaults do
    Dir.glob("#{Rails.root}/config/*.example").each do |file|
      example = File.basename(file)
      file = File.basename(example, '.example')
      if File.exists?(Rails.root.join('config', file))
        puts "#{file} already exists."
      else
        cp Rails.root.join('config', example), Rails.root.join('config', file)
      end
    end
    exit 0
  end

  desc "Copy travis config over database.yml"
  task :travis do
    cp Rails.root.join('config/database.yml.travis'), Rails.root.join('config/database.yml')
    exit 0
  end
end

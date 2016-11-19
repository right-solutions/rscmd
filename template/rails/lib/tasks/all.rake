require 'csv'
require 'open-uri'
require 'time'

RAILS_ENV = ENV["RAILS_ENV"] || "development"

namespace 'import' do

  desc "Import all data in sequence"
  task 'all' => :environment do

    if RAILS_ENV == "production"
      import_list = ["users", "testimonials"]
    else
      import_list = ["users", "testimonials", "subscriptions", "enquiries"]
    end

    import_list.each do |item|
      puts ""
      puts "Importing #{item.titleize}".yellow
      begin
        Rake::Task["import:#{item}"].invoke
      rescue Exception => e
        puts "Importing #{item.titleize} - Failed - #{e.message}".red
      end
    end

  end

end
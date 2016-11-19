require 'csv'
require 'open-uri'
require 'time'

RAILS_ENV = ENV["RAILS_ENV"] || "development" unless defined?(RAILS_ENV)

namespace 'import' do
	# This import is only done while developing and testing
  desc "Import Subscriptions"
  task 'subscriptions' => :environment do

    if ["true", "t","1","yes","y"].include?(ENV["truncate_all"].to_s.downcase.strip)
      Subscription.destroy_all
    end

    path = "db/import_data/#{RAILS_ENV}/subscriptions.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers

    csv_table.each_with_index do |row, count|

      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

      next if row[:email].blank?

      subscription = Subscription.find_by_email(row[:email]) || Subscription.new
      subscription.email = row[:email]
      
      if subscription.save!
        puts "#{subscription.email} saved".green
      else
        puts "Error! #{subscription.errors.full_messages.to_sentence}".red
      end

    end
  end
end
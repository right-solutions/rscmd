require 'csv'
require 'open-uri'
require 'time'

RAILS_ENV = ENV["RAILS_ENV"] || "development" unless defined?(RAILS_ENV)

namespace 'import' do
	# This import is only done while developing and testing
  desc "Import Enquiries"
  task 'enquiries' => :environment do

    if ["true", "t","1","yes","y"].include?(ENV["truncate_all"].to_s.downcase.strip)
      Enquiry.destroy_all
    end

    path = "db/import_data/#{RAILS_ENV}/enquiries.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers

    csv_table.each_with_index do |row, count|

      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

      next if row[:name].blank?

      enquiry = Enquiry.find_by_email(row[:email]) || Enquiry.new
      enquiry.name = row[:name]
      enquiry.email = row[:email]
      enquiry.phone = row[:phone]
      enquiry.subject = row[:subject]
      enquiry.message = row[:message]
      
      enquiry.status = Enquiry::UNREAD

      if enquiry.save!
        puts "#{enquiry.name} saved".green
      else
        puts "Error! #{enquiry.errors.full_messages.to_sentence}".red
      end

    end
  end
end
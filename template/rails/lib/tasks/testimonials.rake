require 'csv'
require 'open-uri'
require 'time'

RAILS_ENV = ENV["RAILS_ENV"] || "development" unless defined?(RAILS_ENV)

namespace 'import' do
	desc "Import Testimonials"
  task 'testimonials' => :environment do

    if ["true", "t","1","yes","y"].include?(ENV["truncate_all"].to_s.downcase.strip)
      Image::Base.where("imageable_type = 'Testimonial'").destroy_all
      Testimonial.destroy_all
    end

    path = "db/import_data/#{RAILS_ENV}/testimonials.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers

    csv_table.each_with_index do |row, count|

      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

      next if row[:name].blank?

      testimonial = Testimonial.find_by_name(row[:name]) || Testimonial.new
      testimonial.name = row[:name]
      testimonial.designation = row[:designation]
      testimonial.organisation = row[:organisation]
      testimonial.statement = row[:statement]
      
      testimonial.status = Testimonial::PUBLISHED

      ## Adding a testimonial image
      begin
        image_path = "db/import_data/#{RAILS_ENV}/images/testimonials/#{sprintf('%02d', count+1)}.jpg"
        if File.exists?(image_path)
          testimonial.build_picture
          testimonial.picture.image = File.open(image_path)
        else
          puts "Warning! Picture not found for #{testimonial.name}. #{image_path} doesn't exists"
        end
      rescue => e
        puts "Error during processing: #{$!}"
        puts "Event Title: #{testimonial.name}, Image Path: #{image_path}".red
        puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      end if testimonial.picture.blank?

      if testimonial.valid? && (testimonial.picture.blank? || testimonial.picture.valid?)
        testimonial.save
        puts "#{testimonial.name} saved".green
      else
        puts "Error! #{testimonial.errors.full_messages.to_sentence}".red
      end

    end
  end
end
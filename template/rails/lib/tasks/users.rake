require 'csv'
require 'open-uri'
require 'time'

RAILS_ENV = ENV["RAILS_ENV"] || "development" unless defined?(RAILS_ENV)

namespace 'import' do
  desc "Import Users"
  task 'users' => :environment do

    if ["true", "t","1","yes","y"].include?(ENV["truncate_all"].to_s.downcase.strip)
      Image::Base.where("imageable_type = 'User'").destroy_all
      User.destroy_all
    end

    path = "db/import_data/#{RAILS_ENV}/users.csv"
    csv_table = CSV.table(path, {headers: true, converters: nil, header_converters: :symbol})
    headers = csv_table.headers

    csv_table.each do |row|

      row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

      next if row[:name].blank?

      user = User.find_by_username(row[:username]) || User.new
      user.name = row[:name]
      user.username = row[:username]
      user.designation = row[:designation]
      user.email = row[:email]
      user.phone = row[:phone]

      user.super_admin = ["true", "t","1","yes","y"].include?(row[:super_admin].to_s.downcase.strip)

      user.status = User::ACTIVE
      user.password = ConfigCenter::Defaults::PASSWORD
      user.password_confirmation = ConfigCenter::Defaults::PASSWORD

      ## Adding a profile picture
      begin
        image_path = "db/import_data/#{RAILS_ENV}/images/users/#{user.username}.png"
        if File.exists?(image_path)
          user.build_profile_picture
          user.profile_picture.image = File.open(image_path)
        else
          puts "Warning! Profile Picture not found for #{user.name}. #{image_path} doesn't exists"
        end
      rescue => e
        puts "Error during processing: #{$!}"
        puts "Username: #{user.username}, Image Path: #{image_path}".red
        puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      end if user.profile_picture.blank?

      if user.valid? && (user.profile_picture.blank? || user.profile_picture.valid?)
        user.save!
        user.active!
        puts "#{user.display_name} saved & activated".green
      else
        puts "Error! #{user.errors.full_messages.to_sentence} & #{user.profile_picture.errors.full_messages.to_sentence}".red
      end

    end
  end
end
require 'thor'
require 'pathname'
require 'octokit'
require 'rest-client'
require 'json'
require 'pry'
require 'colorize'
require 'shellwords'

require "rscmd/scripts/jekyll"
require "rscmd/scripts/rails"
require "rscmd/scripts/github"
require "rscmd/scripts/aws"
require "rscmd/scripts/optimizer"

module Rscmd
  class Cli < Thor
    
    desc "rscmd jekyll <project_name> <project_path>", "Will create a jekyll application and configure it according to the standards."
    long_desc <<-LONGDESC
      \nThe jekyll command will create a jekyll application and configure it according to the standards.  \n
   
      You need to specify 2 parameters  \n
      > project_name: name of the project, preferably the domain name according to the right solution standard.  \n
      > project_path: The path where you would like to create jekyll application  \n
   
      Examples: \n
      
      > $ rscmd jekyll example.com .  \n
      > $ rscmd jekyll example.com projects/jekyll  \n

    LONGDESC
    option :github, :required => false, :type => :boolean
    option :template, :required => false, :type => :boolean
    def jekyll(name, path)
      absolute_path = Dir.exist?(path) ? path : Pathname.new(".").realpath + path
      domain = name.gsub("http://", "").gsub("www.", "")

      if Dir.exist?(absolute_path)
        # Create Jekyll Project
        Scripts::Jekyll.create(domain, absolute_path)

        # Setup Git
        github(name, path) if options[:github]

        # Setup Template
        template(name, path) if options[:template]
      else
        puts "Error! Directory #{path} doesn't exist"
      end
    end

    desc "rscmd rails <project_name> <project_path>", "Will create a rails application and configure it according to the standards."
    long_desc <<-LONGDESC
      \nThe rails command will create a rails application and configure it according to the standards.  \n
   
      You need to specify 2 parameters  \n
      > project_name: name of the project, preferably the domain name according to the right solution standard.  \n
      > project_path: The path where you would like to create rails application  \n
   
      Examples: \n
      
      > $ rscmd rails example.com .  \n
      > $ rscmd rails example.com projects/jekyll  \n

    LONGDESC
    def rails(name, path)
      path = Dir.exist?(path) ? path : Pathname.new(".").realpath + path
      domain = name.gsub("http://", "").gsub("www.", "")

      if Dir.exist?(path)
        # Create Rails Project
        RS::Rails.create(domain, path)
      else
        puts "Error! Directory #{path} doesn't exist"
      end
    end

    desc "rscmd github <project_name> <project_path>", "will setup repository in github and push the given directory (code) to the master branch. Need to provide github login and password."
    long_desc <<-LONGDESC
      \nThe github command will setup repository in github and push the given directory (code) \n
      to the master branch. Need to provide github login and password. \n
   
      You need to specify 2 + 2 parameters \n
      1) project_name: name of the application you would like to set repository for in github \n
      2) project_path: the path where the application is created. if the application example.com is in /Projects/Jekyll, then the project_path would be /Projects/Jekyll \n

      While running, it will ask you to enter the github login handle and password
      
      Examples: \n
      
      > $ rscmd github example.com .  \n
      > $ rscmd github example.com projects/jekyll  \n

    LONGDESC
    def github(name, path)
      path = Dir.exist?(path) ? path : Pathname.new(".").realpath + path
      
      if Dir.exist?(path)
        # Setup Github Repository & Sync
        puts "You need to login to github in order to create a repository"
        login = ask("login handle:")
        password = ask("password: ", :echo => false)
        puts ""
        Scripts::Github.setup(name, path, login, password)
      else
        puts "Error! Directory #{path} doesn't exist"
      end
    end

    desc "rscmd dummy <project_name> <project_path>", "will add some dummy contents to the jekyll mainly used during the development"
    long_desc <<-LONGDESC
      \nThe dummy command will add some basic files to the jekyll project to look like a standard project. \n 
      These files include assets, some partials, full fledged html layout etc. \n
      
      You need to specify 2 parameters \n
      1) project_name: name of the application \n
      2) project_path: the path where the application is created. if the application example.com is in /Projects/Jekyll, then the project_path would be /Projects/Jekyll \n
      
      Examples: \n
      
      > $ rscmd dummy example.com . \n
      > $ rscmd dummy example.com projects/jekyll \n

      NOTE: As this is a dummy work, the changes are not committed to git.

    LONGDESC
    def dummy(name, path)
      path = Dir.exist?(path) ? path : Pathname.new(".").realpath + path
      
      puts "Error! Directory #{path} doesn't exist" && return unless Dir.exist?(path)
      
      # Copy the template to the project folder and setup
      Scripts::Jekyll.fill_dummy(name, path)
    end


    desc "rscmd template <project_name> <project_path>", "will copy the downloaded template and will add it to the repository according to the right solutions standards"
    long_desc <<-LONGDESC
      \nThe template command will copy the downloaded template and will add it to the repository \n 
      according to the right solutions standards. \n
      
      This command will also do the following\n
      1) create a directory named 'template' and will copy the template file to it \n
      2) extract the template zip/rar file into the template folder for easy access \n
      3) add the extracted files to the .gitignore so that the repository is lean \n
   
      You need to specify 2 parameters \n
      1) project_name: name of the application \n
      2) project_path: the path where the application is created. if the application example.com is in /Projects/Jekyll, then the project_path would be /Projects/Jekyll \n
      
      This will ask you to choose the template zip file which will be copied to the the project folder.
      It will also ask you to enter the github login handle and password.
   
      Examples: \n
      
      > $ rscmd template example.com . \n
      > $ rscmd template example.com projects/jekyll \n

    LONGDESC
    def template(name, path)
      path = Dir.exist?(path) ? path : Pathname.new(".").realpath + path
      
      puts "Error! Directory #{path} doesn't exist" && return unless Dir.exist?(path)
      
      puts "Login to github to commit the changes"
      login = ask("login handle:")
      password = ask("password: ", :echo => false)

      # Copy the template to the project folder and setup
      Scripts::Jekyll.setup_template(name, path, login, password)
    end

    desc "rscmd optimize abc.com temp", "will copy the downloaded template and will add it to the repository according to the right solutions standards"
    long_desc <<-LONGDESC
      \nThe optimize command will optimize all the images in the assets/img folder in the application  \n 
      according to the right solutions standards. \n
      It will also add a commit for the changes it did for images. \n
      
      You need to specify 2 parameters \n
      1) name: name of the application \n
      2) path: the path where the application is created \n
      
      Examples: \n
      
      > $ rscmd optimize abc.com ~/Projects/Temp \n
      > $ rscmd optimize abc.com . ~/Downloads \n
      > $ rscmd optimize abc.com projects/rails_projects ~/Downloads \n

    LONGDESC
    def optimize(path)
      path = Dir.exist?(path) ? path : Pathname.new(".").realpath + path
      puts "Error! Directory #{path} doesn't exist" && return unless Dir.exist?(path)
      t1 = Time.now
      # Optimizing images
      RS::Doctor.optimize_images(path)
      t2 = Time.now
      puts "Finished all jobs in #{(t2-t1)} seconds"
    end

    desc "rscmd aws", "asd"
    long_desc <<-LONGDESC
      \nThe optimize command will optimize all the images in the assets/img folder in the application  \n 
      according to the right solutions standards. \n
      It will also add a commit for the changes it did for images. \n
      
      You need to specify 2 parameters \n
      1) name: name of the application \n
      2) path: the path where the application is created \n
      
      Examples: \n
      
      > $ rscmd optimize abc.com ~/Projects/Temp \n
      > $ rscmd optimize abc.com . ~/Downloads \n
      > $ rscmd optimize abc.com projects/rails_projects ~/Downloads \n

    LONGDESC
    def aws(path)
      path = Dir.exist?(path) ? path : Pathname.new(".").realpath + path
      puts "Error! Directory #{path} doesn't exist" && return unless Dir.exist?(path)
      t1 = Time.now
      # Optimizing images
      RS::Doctor.optimize_images(path)
      t2 = Time.now
      puts "Finished all jobs in #{(t2-t1)} seconds"
    end

  end
end
# Rscmd

All commands are basically ruby codes residing in the file `lib/rscmd`. To experiment with that code, run `bin/console` for an interactive prompt. 

Go through the Usage Section for more information about how to use this commands / gem

You will have to install the gem first before you could work with it. Followh the section below to install this gem on your system to start with:

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rscmd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rscmd

## Usage

Note: You might want to try bundle exec bin/rscmd instead of just rscmd for the following commands.

### Create a Jekyll Project

```rscmd jekyll <project_name> <project_path>```

The jekyll command will create a jekyll application and configure it according to the standards.  
   
You need to specify 2 parameters  
> project_name: name of the project, preferably the domain name according to the right solution standard.  
> project_path: The path where you would like to create jekyll application  

Examples: 

		$ rscmd jekyll example.com ~/Projects/Temp 
		$ rscmd jekyll example.com .  
		$ rscmd jekyll example.com projects/jekyll_projects  

The folder structure is as follows:

-> project_name
	|-> releases # zipped releases files
	|-> src # jekyll project files
	|-> template # the html template if any

The src folder will be the jekyll root folder

Make sure that you do do bundle install after this command

$ bundle install 






### Create a Rails Project

```rscmd rails <project_name> <project_path>```

The rails command will create a jekyll application and configure it according to the standards.  
   
You need to specify 2 parameters  
> project_name: name of the project, preferably the domain name according to the right solution standard.  
> project_path: The path where you would like to create rails application  

Examples: 

		$ rscmd rails example.com ~/Projects/Temp 
		$ rscmd rails example.com .  
		$ rscmd rails example.com projects/jekyll_projects  

-> project_name
	|-> releases
	|-> src
	|-> template

The src folder will be the rails root folder

Make sure that you do do bundle install after this command

$ bundle install 






### Create a Github Repository

```rscmd github <project_name> <project_path>```

The github command will setup repository in github and push the given directory (code) 
to the master branch. Need to provide github login and password. 

You need to specify 2 + 2 parameters 
1) project_name: name of the application you would like to set repository for in github 
2) project_path: the path where the application is created. if the application example.com is in /Projects/Jekyll, then the project_path would be /Projects/Jekyll 

While running, it will ask you to enter the github login handle and password

Examples: 

		$ rscmd github example.com . 
		$ rscmd github example.com projects/jekyll






### Add an HTML template

```rscmd template <project_name> <dir_path>```

The template command will open up a filebrowser window where you can select the downloaded html template file. It will then copy it to the /template directory in the project folder, add it to the repository but ignoring the content inside.

Since it is adding the template file to the repository, you will have to enter your github username and password.

According to the right solutions standards. 

This command will also do the following
1) create a directory named 'template' and will copy the template file to it 
2) extract the template zip/rar file into the template folder for easy access 
3) add the extracted files to the .gitignore so that the repository is lean 

You need to specify 2 parameters 
*) project_name: name of the application 
*) project_path: the path where the application is created. if the application example.com is in /Projects/Jekyll, then the project_path would be /Projects/Jekyll 

This will ask you to choose the template zip file which will be copied to the the project folder.
It will also ask you to enter the github login handle and password.

Examples: 

		$ rscmd template example.com .
		$ rscmd template example.com projects/jekyll












## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rscmd.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


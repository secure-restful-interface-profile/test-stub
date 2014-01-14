VistA Novo Test Stub 
====================

The VistA Novo Test Stub is a tool based on rails_admin for serving user-generated healthcare data for the development of consuming applications. It allows users to define data models to their own specifications, populate their data models, and then retrieve the data through REST calls.

Installation and Setup
----------------------

The Test Stub was developed in a *nix environment, so the installation instructions will assume a Debian/Ubuntu environment. Be sure to update apt (sudo apt-get update) before you install the dependency packages.

First, install Git:

    sudo apt-get install git-core

Then install some dependencies:

    sudo apt-get install build-essential openssl libssl-dev libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config nodejs

Then install the ruby version manager (rvm):

    curl -L get.rvm.io | sudo -i bash -s stable

Open an admin console to configure rvm:

    sudo -i

Set the autolibs flag in rvm:

    rvm autolibs enable

Use rvm to install ruby 1.9.3:

    rvm install 1.9.3

Set ruby 1.9.3 to be the default ruby version:

    rvm --default 1.9.3

Install bundler for management of ruby gem dependencies:

    gem install bundler

Close the admin console:

    exit

And finally set up rvm for a non-root user:

    source /etc/profile.d/rvm.sh
    rvm use 1.9.3
    rvm --default 1.9.3

Then clone the VistA Novo Test Stub repository from OSEHRA:

    git clone https://github.com/OSEHRA/vista-novo-test-stub.git

Navigate to the Test Stub directory:

    cd vista-novo-test-stub

Run bundler to install dependencies:

    bundle install

Run the default database migrations:

    bundle exec rake db:migrate

And finally, start the server:

    bundle exec rails s

Service Creation
----------------

Creating a New Service

Creating a service in VistA Novo is very straightforward because rails\_admin takes care of most of the behind the scenes legwork.  There are two steps to creating and configuring a service: creating the data model, and defining how rails_admin will display it for entry by the user. 


Creating a Data Model (example: Providers)

To create a data model in VistA Novo, a user simply creates a rails ActiveRecord migration. In the command line, from the test stub’s home directory:

    rails generate model providers name:string type:string

This command will automatically create a number of files, including the source code for the model in the app/models directory as well as a database migration file in the db/migrate directory that is prepended with a timestamp identifying the migration. The generated migration file will contain the following:

    class CreateProviders < ActiveRecord::Migration
      def change
        create_table :providers do |t|
          t.string :name
    	  t.string :type
        end
      end
    end

The previous step can be repeated to create as many data models with as many fields as desired.  To actually apply these migrations to the database, run the following:

    bundle exec rake db:migrate

You can also add additional fields to the table at a later time:

    rails generate migration AddLocationToProviders address:string city:string state:string

This will generate another migration file containing the following:

    class AddLocationToProviders < ActiveRecord::Migration
      def change
        add_column :providers, :address, :string
        add_column :providers, :city, :string
        add_column :providers, :state, :string
      end
    end

Once the migration has been created, run the migration rake task again:

    bundle exec rake db:migrate

More information on ActiveRecord and migrations can be found [here](http://guides.rubyonrails.org/migrations.html).


Configuring rails_admin for Data Model

The default settings for rails_admin automatically provides pages for creating, updating, and deleting models, so most of the time, no other changes are necessary. 

If there are some fields, however, that you would like ordered in a particularly way, hidden, or need to be displayed differently from the default setting, rails_admin allows configuration of how your data models are displayed when viewed or edited from the Test Stub admin panel. The corresponding model file in app/models is where each data model can be configured:

    class Provider < ActiveRecord::Base
    rails_admin do 
        	#fields labeled and ordered for display here
        edit do
        	#fields labeled and ordered for editing here
        end
      end
    end

Details on rails\_admin configuration options can be found [here](https://github.com/sferik/rails_admin/wiki/Railsadmin-DSL).


Using rails_admin to Populate Data Models

Now that your data model is created and migrated into the database and rails_admin is configured to display your data to your specifications, you can begin entering actual data.

To do this, start the test-stub rails server:

    bundle exec rails s

This will start the server on your local machine on the default port (3000).

Open a web browser, and navigate to http://localhost:3000/. Click on Sign Up if it is your first time using the test stub and create an account. This step is so those that have access to the test stub’s data at runtime don’t also have access to modify the data. All account information is stored locally.

Once you have logged in successfully, navigate to the Admin page by following the link on the header bar. The Admin page allows you to create, display, edit, and delete sample data.


Accessing Data With VistA Novo

Now that your data models are created and populated and rails\_admin has done the heavy lifting of creating routes for accessing the data, you can use VistA Novo to call the service. For more information on how rails_admin handles routes, run:

    rake routes

This is an app completed for a ruby on rails demo. to create an app that allows users to find and connect
with their favorite bartenders.


** PREFACE: If you encounter any errors during this tutorial, please copy and paste the error message into google. It is most likely**
** a common error that can be easily resolved.**

#RAILS Set up

First lets make sure rubygems installed on your system. Run the command 'gem' from the command line and make sure it exists
on your system. If not, you will need to install for RubyGems.

*RubyGems is used to install specific versions of ruby and of rails as well as to install plugins or 'gems'*

Download and install Sublime Text at http://www.sublimetext.com/2

*You don't need a heavy weight IDK with Rails. A simple text editor is all you need.*

Now from the console
```
\curl -sSL https://get.rvm.io | bash
rvm install 2.1.1
rvm use 2.1.1
gem install bundler
rvm ruby-2.1.1 do rvm gemset create bar_demo
```

#INSTALL DEPENDENCIES
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install postgresql
brew install -f imagemagick
```


#PROJECT SET UP- Pull from my existing base project to use as a basis for the project.

```
git clone https://github.com/logansease/ror_base.git demo
rm -rfd .git
git init
bundle install
```
* see the github page for more info on this project. This is a great starter project and has lots of stuff pre-built in.*
* we are just going to clone the project and then get rid of all the git files so that git thinks of it as a new repo*


# Setup config variables in CONSTANTS and FOG config files.

* in config/initializers/app_constants.rb and config.initializers/fog.rb several constants are set to configure*
* things like the app name for display purposes and facebook identifiers. Fog allows us to upload images to amazon s3*
* so we can add amazon settings to allow for this.*
* Note that we can do this later, and there will just be a few things that won't work yet.*

#Add your own seeded User to the database

in db/seeds.rb

```
user = User.create(:name => 'Your Name', :password => 'password', :password_confirmation => 'password', :email => 'youremail@gmail.com')
user.update_attribute("activated", true)
user.update_attribute("admin", true)
```

*This file contains data that is automatically added into the database any time the DB is reset.*

#Build the database

```
rake db:reset
```

*This command builds the database on your system. You can run this at any time to completely wipe your local db and*
*reseed it with data.*

Now from your console and your project directory run
```
rails s
```
* This will start a local server. Verify that the project is set up and running correctly by opening*
* http://localhost:3000 in your browser.*


#1- Perform a scaffold to add a bartender object
```
rails g scaffold Bartender bar:string user_id:integer is_working:boolean
rake db:migrate
```

*Scaffolds build several files into your system to get you a very basic working implementation for a specific Database object*
*by running that command, we now have a controller, model and views with routes to get, update, delete and list*
*that particular model object*
*it will even create a migration file, similar to an 'Evolution' in play which we can run to add the table to the database*
*without clearing your database data.*
*look at our config/routes.rb file to see we now have 'resource :bartender'. This line automatically creates all of the basic*
*REST paths for the bartender model which will run through the bartender controller.*

*Have a look at the files that were created, specifically views/bartender, controllers/bartenderController and Model/bartender*
*and the new migration file*

*rake db:migrate is the command we run to perform any migrations that have not yet occurred. If there is any problem running*
*our migration, nothing will occur. We do not have to worry about our database being in some inconsistent state that we have*
*to manually resolve.*


#- Improve Bartender Model
app/models/Bartender.rb

```
  attr_accessible :bar, :is_working, :user_id
  belongs_to :user
```

*the attr_accessible declares what properties of the model object are allowed to be updated via an post and the front end.*
*most properties should be included in this, but there are cases where you may only want the system to be able to set*
*and change a particular property.*

*By declaring the belongs_to user. We are declaring a relationship between the two models where the Bartender has a User*
*and the tables are joined by the Bartender.user_id = User.id columns.*
*now in our code we can access the Bartender.User where ever needed.*

app/models/User.rb
```
has_one :bartender
```
*by declaring has_one, we say that the User has exactly 1 bartender. We have now just declared a 1-1 relationship between the*
*two tables*

*The idea of Models is to encapsulate all the logic for a single Database Table, or an object represented by a row*
*from the database table in one place. Take a look at the User model to see what kind of cool stuff is inside. There are*
*methods to help with authenticating the user, validation*



#2- Add Bartenders to the admin panel
views/Pages/admin.html.erb

```
<p><%= link_to 'Bartenders', bartenders_path %>  </p>
```

*In Ruby <%=  %> is a tag that lets you embed ruby code into an ruby file. This works similar to php to let us create*
*dynamic html. But this can also be used with files like javascript as well. The link_to is a method that creates a hyperlink*
*the bartenders_path variable is a variable that was automatically created when we declared bartender as a resource.*
*a variable exists for all of the rest operations so we can easily add links in our code.*


#3- Add Json Formatter so we can call /bartenders/[id]?format=json from an API
in controllers/BartendersController.rb - index method

```
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bartenders }
    end
```

*The respond to tells the controller what to render based on the request format which is specified as a url parameter*
*we are saying that for the html format, just do what we would normally do, which would be to render with a view that matches*
*the method name from views/[model name]/[method name].html.erb*
*for json we are going to turn the @bartenders array into json and render that*
*note that @variables in ruby are request level variables. The controller can set them and the will persist to the view*
*to be accessed by the view.*


#- Improve Bartenders index page.
views/Bartenders/index.html.erb
```
<%= link_to 'New Bartender', new_bartender_path if current_user and current_user.admin? %>

<h1>Top Bartenders</h1>

<% @bartenders.each do |bartender| %>
    <%= render "bartender_thumb", :bartender => bartender %>
<% end %>
```

*Here we are just adding a link to a bartender and then we are looping through the bartenders list and rendering a partial*
*and passing the bartender object to that partial.*
*A partial is a way to separate out a small portion of html that can be included in other pages. Note that all partials are*
*prefaced with an underscore _partial.html.erb when they are named in the file system.*

*you may notice that the first and last lines are <% %> instead of <%= %>. The difference is that the former is only a logical*
*piece of code where as the latter will actually output HTML to the page.*


ADD views/bartenders/_bartender_thumb.html.erb

```
<div class="left padded block opaque”>
  <%= link_to image_for(bartender.user, :size => 100), bartender %>
  <p><%= link_to bartender.user.name, bartender %> </p>
  <p>Works at: <%= bartender.bar %> </p>
  <p class="<%= bartender.is_working ? "green" : "red" %>">
    <%= bartender.is_working ? "Working" :"Not Working" %>
  </p>
</div>
```

#Add CSS Class
to assets/stylesheets/boot_strapped.css

```
.red
{
    color:darkred;
}
.green
{
    color:darkgreen;
}
```
*Note that the assets folder encompasses what is called an assets pipeline in rails. This is essentially*
*some super fast and effecient way to deliver assets like images, stylesheets and javascripts to your app*
*you may also place things like this in the public folder and anything stored here will be available directly*
*from your server without having to go through any controllers, routing or authentication.*
*although using the public folder will not enable the asset pipeline to work its magic*


#4- Improve Bartender View Page
views/bartenders/show.html.erb

```
<p id="notice"><%= notice %></p>

<%= render "bartender_thumb", :bartender => @bartender %>

<div class="admin_actions block opaque left>
<% if current_user and ( current_user == @bartender.user or current_user.admin ) %>
    <%= link_to 'Edit', edit_bartender_path(@bartender), :class => "btn btn-primary" %>

    <%= link_to "delete", @bartender, :method => :delete, :data => { :confirm => "Are you sure?"},
                :title => "Delete #{@bartender.user.name}", :class => "btn btn-danger"%>

<% end %>
</div>
```

#5- Add Permissions for bartender to prevent unauthorized access and modification

controllers/bartendersController.rb
```
  before_filter :check_permissions, :only => [:edit, :update, :destroy]

    def check_permissions
      redirect_to(root_path, :flash => {:success =>"You Don't Have Access"}) unless  current_user and (current_user.admin or current_user.bartender == @bartender)
    end
```

*This will tell the controller that before we run methods, we should first call the check_permissions method.*
*but the only => Tells us only do that for the edit, update and destroy methods.*


#6- Add a link to the users' linked bartender on their settings page, or a link to create a new bartender for the user
#views/Users/edit.html.erb

```
<div class="well left">
  <h3>Bartender</h3>
  <% if @user.bartender %>
      <%= render "bartenders/bartender_thumb", :bartender => @user.bartender %>
  <% else %>
      <%= link_to "I tend bar", new_bartender_path, :class=> "btn btn-primary"%>
  <% end %>
</div>
```

#7- Add Nested Resource for Bartender so we can create a new bartender with /users/[id]/bartender/new
config/routes
```
resources :users do
  resources :bartenders, :only => [:create, :new]
```
*A nested resource is a way of telling rails that you want paths like user/id/bartender*
*this will just pass the userId specified in the URL into your bartenders controller methods as a normal parameter.**


#Update views/users/edit.html.erb to new path

```
<%= link_to "I tend bar", new_user_bartender_path(current_user), :class=> "btn btn-primary"%>
```


to new controllers/bartender controller

```
    if params[:user_id]
      @bartender.user_id = params[:user_id]
    end
```

views/bartenders/_form.html.erb

Remove user_id field from bartender change to hidden

```
  <div class="field">
    <%= f.hidden_field :user_id, :value => @bartender.user_id %>
  </div>
```

#8 - Add some validation to bartender
Bartender.rb

```
  validates :user_id, :presence => true
  validates :bar, :length => { :within => 4..30 }
```

**Just with these two lines, we have now added validation into the app. Before we try to save this object, we will run this validation**
**and if it fails, the app will display the validation error.**


#9- Add Connect Button
add relationship Type

config/initializers/app_constants.rb

```
RELATIONSHIP_TYPE_BARTENDER = "bartender"
```

In Relationships.rb
```
  belongs_to :followed_bartenders, -> {where(relationships: { relationship_type: RELATIONSHIP_TYPE_BARTENDER })}, :foreign_key => "followed_id", :class_name => "Bartender"

  def target
    if relationship_type == RELATIONSHIP_TYPE_BARTENDER
      Bartender.find(followed_id)
    end
  end
```

*This is one of the more complex relationships that you'll find, but it is a great example of how powerful conditional relationships can be*
*The Relationship here is a Model that allows for a many to many relationship between a bartender and users*
*The model is kept generic enough to support many types, so we could use this same model to relate a user with another user. We*
*would just set a different relationship type.*

*The belongs_to is declaring a complex relationship that says that it has an id on the table that points to child records.*
*our conditional relationship lets us look at only records with a particular relationship_type set. and the foreign key and*
*class name tell us what we should be joining on/to exactly.*

*the target method allows us to look at any relationship object and see who or what the user*
*is following with one single method*

Bartender.rb
```
  has_many :bartender_reverse_relationships, -> { where relationship_type: RELATIONSHIP_TYPE_BARTENDER }, :dependent => :destroy,
           :foreign_key => "followed_id",
           :class_name => "Relationship"
  has_many :followers, :through => :bartender_reverse_relationships, :source => :follower

  def follower_count
    followers.count
  end
```
*This is another complex relationship which essentially allows us to look at a bartender and see*
*what users are following them with bartender.followers. When you call this method, the app will*
*perform a query based on the relationship we've defined to determine the results.*
* You see that these relationships all piggyback off of each other by using :source and :through*

User.rb
```
  has_many :bartender_relationships, -> { where relationship_type: RELATIONSHIP_TYPE_BARTENDER }, :dependent => :destroy,
                           :foreign_key => "follower_id",
                           :class_name => "Relationship"

  has_many :following_bartenders,:through => :relationships, :source => :followed_bartenders
```

*We are doing the same thing we did with bartenders, only from the user. Now we can say*
*user.following_boartenders and find all the bartenders that a user is following.*
**See how we can go straight to the relationships we care about without having to care about the**
**Relationships model in our code. We can even easily render it this way in our json**

  views/pages/home.html.erb
```
    <h3>Following Bartenders</h3>
    <% current_user.following_bartenders.each do |bartender| %>
        <%= render "bartenders/bartender_thumb", :bartender => bartender %>
    <% end %>
```
*We are just adding a link to all of the bartenders we are following to the home page*


#Sort Bartenders by popularity

Controllers/BartenderController.rb - index method

```
    limit = 100
    if params[:limit]
      limit = params[:limit]
    end

    @bartenders = Bartender.select("count(relationships.id) as followers, bartenders.*")
    .joins("LEFT JOIN relationships ON relationships.followed_id = bartenders.id")
    .order("followers desc").group("relationships.id, bartenders.id")
    .limit(limit)
```

*Here our controller is looking at the parameter list that is passed into the controller**
**The dynamic parameters map allows a single controller method to support a wide range of implementations**
**We don't have to have a different method to support different sets of parameters**

*You also note that we are performing a rather complex query in our controller to select our bartenders*
*Sorted by the number of followers*

#10- Move query to a scope

Models/Bartender.rb
```
  scope :top_bartenders, -> (limit) { select("count(relationships.id) as followers, bartenders.*")
  .joins("LEFT JOIN relationships ON relationships.followed_id = bartenders.id")
  .order("followers desc").group("relationships.id, bartenders.id")
  .limit(limit)}
```

Controllers/BartendersController.rb - index method
```
@bartenders = Bartender.top_bartenders(limit)
```

*What we are doing here is moving this complex query into what we call a scope. a scope is a way*
*to encapsulate a complicated query like this into the model object so we can use it in many of*
*our controller methods in a simple way.*


#11- add a background

to views/bartender/show.html.erb
```
<%= render "shared/full_screen_image", :image => "http://pad1.whstatic.com/images/thumb/3/30/Get-Traveling-Bartender-Gigs-Step-8.jpg/670px-Get-Traveling-Bartender-Gigs-Step-8.jpg"%>
```

*Here we are adding some jquery that is stored as a partial. You see that this partial allows us to*
*with a single line of readable code, add a nice looking full screen background to any screen.*


#13- add image upload

in the console
```
rails g migration add_background_to_bartenders background:string

rake db:migrate
```

*We are going to add a new field to the bartender model. *

add :background to attr_accessible
and an image uploader

models/bartender.rb

```
attr_accessible :bar, :is_working, :user_id, :background
mount_uploader :background, ImageUploader
```
*this is a simple way to tell the app that we want to allow the background field to be allowed*
*to upload an image through a form submission. The ImageUploader Class will handle all the dirty work*

and :background to bartender_params in controllers/BartenderController.rb
```
  # Only allow a trusted parameter "white list" through.
  def bartender_params
    params.require(:bartender).permit(:bar, :user_id, :is_working, :background)
  end
```

add the file upload to the add / update bartender pages
views/bartenders/_form.html.erb
```
    <div class="field">
      <%= f.file_field :background %>
    </div>
```

Now if the background is set, pass that to the background partial

views/bartenders/show.html.erb

```
<% if @bartender.background %>
    <%= render "shared/full_screen_image", :image => @bartender.background %>
<% else %>
    <%= render "shared/full_screen_image", :image => "http://pad1.whstatic.com/images/thumb/3/30/Get-Traveling-Bartender-Gigs-Step-8.jpg/670px-Get-Traveling-Bartender-Gigs-Step-8.jpg"%>
<% end %>
```

#14- add search. 

views/pages/home.html.erb

```
<%= form_tag('/bartenders', :method => "GET") do %>
    <%= text_field_tag "search", nil, placeholder: "Search" %>
    <%= submit_tag "Go", :class => "search_button" %>
<% end %>
```

*Here we have added a simple form to our home page. This will add a small text field and go button*
*that will pass the entered text to our bartenders controller. By default, the /bartenders will go to*
*our BartendersController index method and it will automatically pass the search field as a parameter*


views/Bartenders/index.html.erb
```
    if(params[:search])
      @bartenders = @bartenders.joins(:user).where("lower(bar) like lower('%#{params[:search]}%') or lower(users.name) like lower('%#{params[:search]}%')")
    end
```

#15 Let's go Live

from the console
```
git add .
git commit -am 'completed demo'
heroku create
git push heroku master
heroku run rake db:reset
heroku open
```

* We are now live!*

#16 Lets play

from the console
```
heroku run console
User.all
User.where(:name => "Logan Sease")
```

*The console lets you run actual ruby code live on your server. You can perform queries and*
*look through objects stored in your system and modify them as desired.*

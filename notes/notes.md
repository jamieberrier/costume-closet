# TODONE
1. generate resources (migrations, models, controllers, view folders, routes)
  - dance studio
  - dancer
  - costume
  - costume assignments

2. add associations

3. generate sessions controller

4. add sessions helper methods
  - helpers/sessions_helper
    - current_user
    - logged_in?
    - require_logged_in!
    - redirect_to_login(message)
    - try_to_authenticate(user)
    - owner?
    - dancer?
    - log_in(user, message)
    - redirect_if_logged_in!
    - redirect_if_not_owner!
    - redirect_if_not_dancer!
  - controllers/application_controller

5. add root route and home page view (ApplicationController)
  - routes
    - root_path
  - controller action
    - home
  - view
    - home

6. add log in/log out functionality (SessionsController)
  - routes
    - login_path, logout_path
  - controller actions
    - new, create, google_auth, destroy
  - views
    - _form, sessions/new
  - authentication/validation

7. seeded db

8. add registration functionality (RegistrationsController)
  - routes
    - register_dance_studio_path, register_dancer_path, google_omniauth_path, dance_studio_google_register_path, dancer_google_register_path
  - controller actions
    - new, google_auth
  - views
    - new, google_auth
  - authentication/validation

9. add registrations helper methods
  - helpers/registrations_helper
    - create_empty_user
    - signing_up_as_dance_studio?
    - signing_up_as_dancer?
    - try_to_save(user)
  - controllers/application_controller

9. add omniauth - google

10. add dance studio functionality (DanceStudiosController)
  - routes
    - dance_studios_path, edit_dance_studio_path, dance_studio_path
  - controller actions
    - create, show, edit, update, destroy
  - views
    - _form, edit, show
  - validation
    - validates :password, confirmation: { case_sensitive: false }
    - validates :email, presence: true, uniqueness: { case_sensitive: false }
    - validates :studio_name, :owner_name, :password_confirmation, presence: true
  - authentication
    - has_secure_password

11. add dancer functionality (DancersController)
  - routes
    - dance_studio_dancers_path, edit_dancer_path, dancer_path, dancers_path
  - controller actions
    - create, show, index, edit, update, destroy
  - views
    - _form, edit, index, show
  - validation
    - validates :password, confirmation: { case_sensitive: false }
    - validates :email, presence: true, uniqueness: { case_sensitive: false }
    - validates :first_name, :last_name, :password_confirmation, presence: true
  - authentication
    - has_secure_password

12. add costume functionality (CostumesController)
  - routes
    - dance_studio_costumes_path, new_dance_studio_costume_path, edit_costume_path, costume_path
  - controller actions
    - new, create, show, index, edit, update, destroy
  - views
    - _form, edit, index, new, show
  - validation
    - validates :onepiece_description, presence: { message: "must enter a onepiece description if one piece costume OR a top & bottoms description if two piece costume" }, if: :onepiece_costume?
    - validates :top_description, :bottoms_description, presence: { message: "must enter a onepiece description if one piece costume OR a top & bottoms description if two piece costume" }, if: :twopiece_costume?

13. add costume assignments functionality
  - routes
    - dance_studio_costume_assignments_path, new_dance_studio_costume_assignment_path, edit_costume_assignment_path, costume_assignment_path, dancer_costumes_path, dancer_costume_path, assigned_costume_path, dancer_current_costumes_path, studio_current_costumes_path
  - controller actions
    - show, index, current_assignments
  - views
    - _table, current_assignments, dancer_assignments, index
  - validation

14. dance studio add dancers
  - enter first name, last name, and email
  - password & password confirmation are set for them

15. Verify actions protected
  - Application
    - before_action :require_logged_in, except: :home
  - Registrations
    - skip_before_action :require_logged_in
  - Sessions
    - skip_before_action :require_logged_in, except: :destroy
  - Costume Assignments
    - before_action :require_dance_studio_owner, only: :index
  - Dancers
    - skip_before_action :require_logged_in, only: :create
    - before_action :require_dance_studio_owner, only: %i[new index current_dancers]
    - before_action :require_studio_dancer, except: %i[new create index current_dancers]
    - before_action :find_dancer, except: %i[new create index current_dancers]
  - Dance Studios
    - skip_before_action :require_logged_in, only: :create
    - before_action :require_studio_ownership, except: :create
    - before_action :find_dance_studio, only: %i[show edit update destroy]
  - Costumes
    - before_action :require_dance_studio_owner, only: %i[new create index]
    - before_action :require_costume_ownership, only: %i[show]
    - before_action :require_studio_costume, except: %i[new create index show]
    - before_action :find_costume, except: %i[new create index delete_season_assignments]
    - before_action :find_season_costume_assignments, only: %i[season_assignments edit_season_assignments assign_costume]

16. DRY up
  - controllers
    - dancers
    - costumes
    - dance studios
    - costume assignments
    - registrations
    - application
  - models
    - dance studio
    - dancer
    - costume assignment
  - helpers
    - costume assignments
    - costumes
    - dance studios
    - dancers
    - registrations
    - application
   - views

17. field_with_errors (form_for)
  - dance studio registration form
  - edit dance studio
  - dancer registration form
  - edit dancer
  - new dancer
  - edit costume
  - new session form (form_with url)
  - new costume (form_with model)

# TODO
- update forms with field_with_errors
  - assign costume
  - edit season assignments
- fix select dancer(s) on 
  - new costume
  - assign costume
  - edit season assignments
- add search
- DRY up code
  - controllers
    - turn variable assignments into before_actions
    - sessions
  - helpers
    - sessions
  - views
    - partial for season_assignments and assign_costume
- using?
  - registrations helper
    def signing_up_as_dancer?
      params[:user_type] == 'dancer'
    end
- costumes
  - costume_assignments_attributes=(assignments_hashes)
    - ABC too high / too many lines
  - should delete_season_assignments be in costume assignments controller?
- costume assignments
  - update URLs

# ?s
  - nested form
    - can they be built off any model as long as it is associated to all other models in form?
    - built off join model? creating new instances of it?
  - how to nest form to post to /dance_studios/:id/dancers instead of /dancers
  - edit forms
    - password & password confirmation passing as blank

# STRETCH GOALS
- dancers#show
  - add total number of costumes by season and if new/used
- dancestudio#show
  - add total number of costumes by season
- when assigning a costume for 2nd, 3rd, etc time...change condition to used
- costumes
  - display by season - already have current season (current_costumes)
- change hair accessory from costume to costume_assignments

# URLs
## REGISTRATION
### DANCE STUDIOS
#### google_auth
GET /register/dance_studio
  present signup form
#### auth#google_oauth2
GET /auth/google_oauth2?user_type=dance_studio
  present google omniauth form
POST /dance_studios
  create dance studio in db and redirect
### DANCERS
#### google_auth
GET /register/dancer
  present signup form
#### auth#google_oauth2
GET /auth/google_oauth2?user_type=dancer
  present google omniauth form
POST /dancers
  create dancer in db and redirect

## SESSIONS
### LOGIN
#### new
GET /login
  present login form
#### auth#google_oauth2
GET /auth/google_oauth2?user_type=dance_studio
  present google omniauth form
#### auth#google_oauth2
GET /auth/google_oauth2?user_type=dancer
  present google omniauth form
#### create
POST /login
  create session and redirect
### LOGOUT
#### destroy
POST /logout
  destroy session

## DANCE STUDIO
### create
POST /dance_studios
  create dance studio in db and redirect
### show
GET /dance_studios/:id
  show details of dance studio
### edit
GET /dance_studios/:id/edit
  present form to edit details of dance studio
### update
PATCH /dance_studios/:id
PUT /dance_studios/:id
  take form data and update details of dance studio in db
### destroy
DELETE /dance_studios/:id
  delete dance studio in db

## DANCER
### create
POST /dancers
  take form data and create dancer in db
### index
GET /dance_studios/:dance_studio_id/dancers
  show all dancers
### show
GET /dancers/:id
  show details of individual dancer
### edit
GET /dancers/:id/edit
  present form to edit details of dancer
### update
PATCH /dancers/:id
PUT /dancers/:id
  take form data and update details of dancer in db
### destroy
DELETE /dancers/:id
  delete dancer in db

## COSTUME
### new
GET /dance_studios/:dance_studio_id/costumes/new
  present form to create new costume
### create
POST /dance_studios/:dance_studio_id/costumes
  take form data and create costume in db
### index
GET /dance_studios/:dance_studio_id/costumes
  show all costumes
### show
GET /costumes/:id
  show details of individual costume
### edit
GET /costumes/:id/edit
  present form to edit details of costume
### update
PATCH /costumes/:id
PUT /costumes/:id
  take form data and update details of costume in db
### destroy
DELETE /costumes/:id
  delete costume in db

##COSTUME ASSIGNMENT
### new
GET /dance_studios/:dance_studio_id/costume_assignments/new
### create
POST /dance_studios/:dance_studio_id/costume_assignments
### index
GET /dance_studios/:dance_studio_id/costume_assignments
### show
GET /costume_assignments/:id
### edit
GET /costume_assignments/:id/edit
### update
PATCH /costume_assignments/:id
PUT /costume_assignments/:id
### destroy
DELETE /costume_assignments/:id
### current_assignments
GET /dancers/:id/current_costumes
GET /dance_studios/:id/current_costumes






<% if @costume_assignments.nil? %>
  <!-- no current costumes -->
  <h2 class='subtitle'>No Costume Assignments For This Season</h2>
<% else %>
  <% displayed = 0 %>
  <% @costume_assignments.each do |assignment| %>
    <article class='media'>
      <% if displayed == 0 %>
        <% costume = Costume.find(assignment.costume_id) %>
        <!-- costume picture -->
        <figure class='media-left'>
          <p class='image is-64x64'>
            <%= link_to image_tag(costume.picture, width: 100), costume_path(costume.id) %>
          </p>
        </figure>
        <div class='media-content'>
          <!-- song name (genre) -->
          <div class='content'>
            <p>
              <strong><%= assignment.song_name.upcase %></strong> (<%= assignment.genre %>)
            </p>
            <!-- shoes and tights -->
            <p style='margin-left:3%;'>
              <strong>Shoes:</strong> <%= assignment.shoe %>
              <br>
              <strong>Tights:</strong> <%= assignment.tight %>
            </p>
            <table class='table is-narrow'>
              <!-- table of dancer name, their costume's size, and its condition -->
              <thead>
                <tr>
                  <th>Dancer</th>
                  <th>Size</th>
                  <th>Condition</th>
                </tr>
              </thead>
            </table>
          </div>
          <% displayed = 1 %>
      <% end %>
        <!-- nested media object -->
        <article class='media'>
          <!-- empty pic to indent -->
          <figure class='media-left'>
            <p class='image is-48x48'>
            </p>
          </figure>
          <!-- nested media content -->
          <div class='media-content'>
            <div class='content'>
              <table class='table is-narrow'>
                <tbody>
                  <tr>
                    <td><%= link_to Dancer.find(assignment.dancer_id).name, dancer_path(assignment.dancer_id) %></td>
                    <td><%= assignment.costume_size %></td>
                    <td><%= assignment.costume_condition %></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div><!-- end nested media content -->
        </article><!-- end nested media object -->
      </div><!-- end media content -->
    </article>
  <% end %>
<% end %>

## DOUBLE NESTED
### models
class Show < ApplicationRecord
    has_many :seasons
    accepts_nested_attributes_for :seasons
end
class Season < ApplicationRecord
  belongs_to :show, optional: true
  has_many :episodes
  accepts_nested_attributes_for :episodes
end
class Episode < ApplicationRecord
  belongs_to :season, optional: true
end
### shows_controller
def show_params
  params.require(:show).permit(:name, :seasons_attributes => [:number, :episodes_attributes => [:title]])
end
### _form
<%= form_with(model: show, local: true) do |form| %>
  <div class="field">
    <%= form.label :name %>
    <%= form.text_field :name %>
  </div>

  <!-- Show name and label -->
  <%= form.fields_for :seasons do |s| %>
    <%= s.label :number %>
    <%= s.number_field :number %>

    <%= s.fields_for :episodes do |e| %>
      <%= e.label :title %>
      <%= e.text_field :title %>
    <% end %>
  <% end %>

  <div class="actions">
    <%= form.submit %>
  </div>
<% end %>
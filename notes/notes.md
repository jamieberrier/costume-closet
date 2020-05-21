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
    - before_action :require_studio_costume, only: %i[costume_assignments season_assignments delete_season_assignments]
    - before_action :set_costume, only: %i[costume_assignments season_assignments]
    - before_action :set_season_costume_assignments, only: %i[season_assignments  delete_season_assignments]
    - before_action :set_shared_info, only: %i[season_assignments]
  - Dancers
    - skip_before_action :require_logged_in, only: :create
    - before_action :require_dance_studio_owner, only: %i[new index current_dancers]
    - before_action :require_studio_dancer, except: %i[new create index current_dancers]
    - before_action :set_dancer, except: %i[new create index current_dancers]
  - Dance Studios
    - skip_before_action :require_logged_in, only: :create
    - before_action :require_studio_ownership, except: :create
    - before_action :set_dance_studio, only: %i[show edit update destroy]
  - Costumes
    - before_action :require_dance_studio_owner, only: %i[new create index]
    - before_action :require_costume_ownership, only: %i[show]
    - before_action :require_studio_costume, except: %i[new create index show]
    - before_action :set_costume, except: %i[new create index]
    - before_action :set_season_costume_assignments, only: %i[assign_costume edit_season_assignments]
    - before_action :set_shared_info, only: %i[edit_season_assignments]
    - before_action :fetch_shared_assignment_info, only: %i[create assign]

16. DRY up
  - controllers
    - dancers
    - costumes
    - dance studios
    - costume assignments
    - registrations
    - application
    - sessions
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
  - new costume (form_with model, nested)
  - assign costume (form_with model, nested)
  - edit season assignments (form_with model, nested)

18. add view helpers
  - application
    - home
  - sessions
    - new
    - _form
  - registrations
    - new
    - google_auth
  - layouts
    - application
  - costume_assignments
    - index
    - _table
    - costume_assignments
    - season_assignments
  - dance_studios
    - _form
    - current_assignments
    - current_costumes
    - edit
    - show
    - unassigned_costumes
  - dancers
    - _error_notification
    - _form
    - current_assignments
    - current_dancers
    - dancer_assignments
    - edit
    - index
    - new
    - show
  - costumes
    - _create rows
    - _dancer_table
    - _display_shared_assignment_info
    - _display
    - _error_notification
    - _picture
    - _studio_controls
    - assign_costume
    - edit_season_assignments
    - edit
    - index
    - new
    - show

# TODO
- record walkthrough

# ?s
  - edit forms
    - password & password confirmation passing as blank

# STRETCH GOALS
- dancers#show
  - add total number of costumes by season and if new/used
- dancestudio#show
  - add total number of costumes by season
- when assigning a costume for 2nd, 3rd, etc time...change condition to used
- track previous costume ownership
- costumes
  - display by season - already have current season (current_costumes)
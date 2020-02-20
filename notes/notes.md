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
  - controllers/application_controller

5. add root route and home page view

6. add log in/log out functionality
  - routes
  - controller actions
  - views: sessions/new, dance_studios/show
  - authentication/validation

7. seeded db

8. add registration functionality
  - routes
  - controller actions
  - view: dance_studios/new
  - authentication/validation

9. 

# TODO
- omniauth



# URLs
## SIGNUP
GET /register
    present signup form
POST /users
    create user in db

## LOGIN
GET /login
    present login form
POST /login
    create session and redirect

## COSTUME
### new
GET /costumes/new
    present form to create new costume
### create
POST /costumes
    take form data and create costume in db
### show
GET /costumes
    show all costumes
GET /costumes/:id
    show details of individual costume

## DANCER
### new
GET /dancers/new
    present form to create new dancer
### create
POST /dancers
    take form data and create dancer in db
### show
GET /dancers
    show all dancers
GET /dancers/:id
    show details of individual dancer
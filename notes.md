# TODONE
1. generate resources (migrations, models, controllers, view folders, routes)
  - dance studio
  - dancer
  - costume
  - costume assignments

2. generate sessions controller

3. add sessions helper methods
  - helpers/sessions_helper
  - controllers/application_controller

4. 

#TODO
- 

# URLs
## SIGNUP
GET /signup
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
# [Rails URL Helpers](https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html)

## Introduction: Why We Care
- In this section, we will review how to leverage built-in URL helper methods instead of hard coding route paths into an application (along with why this is a good idea).

- Hard-coded path: `"/posts/#{@post.id}"`
- Route helper: `post_path(@post)`

**We want to use route helper methods as opposed to hard coding because:**
- Route helpers are more dynamic since they are methods and not simply strings. This means that if something changes with the route there are many cases where the code itself won't need to be changed at all
- Route helper methods help clean up the view and controller code and assist with readability. **On a side note, you cannot use these helper methods in your model files**
- It's more natural to be able to pass arguments into a method as opposed to using string interpolation. For example, `post_path(post, opt_in: true)` is more readable than `"posts/<%= post.id %>?opt_in=true"`
- Route helpers translate directly into HTML-friendly paths. In other words, if you have any weird characters in your URLs, the route helpers will convert them so they can be read properly by browsers. This includes items such as spaces or characters such as `&`, `%`, etc.

## Implementing Route Helpers

Let's look at the [Rails URL Helpers Lab](https://learn.co/tracks/full-stack-web-development-v8/module-13-rails/section-4-intro-to-actionview/rails-url-helpers-lab) as an example.

1. To begin, we're going to start with an application that has the MVC set up for `students`, with `index` and `show` actions currently in place. The route call looks like this:
```ruby
# config/routes.rb
resources :students, only: [:index, :show]
```

2. This will create routing methods for posts that we can utilize in our views and controllers. Running `rails routes` in the terminal will give the following output:
```
Prefix Verb URI Pattern                      Controller#Action
students GET  /students(.:format)              students#index
student GET  /students/:id(.:format)          students#show
activate_student GET  /students/:id/activate(.:format) students#activate
```

#### Let's break down these columns:
- **Column 1**: This column gives the prefix for the route helper methods. In the current application, `students` and `student` are the prefixes for the methods that you can use throughout your applications. The two most popular method types are `_path` and `_url`. So if we want to render a link to our students' index page, the method would be `students_path` or `students_url`. **The difference between `_path` and `_url` is that` _path` gives the relative path and `_url` renders the full URL.**

    **DEMO:**

    - In `rails console`, you can test these route helpers out.
    - Run `app.students_path` and see what the output is.
    - You can also run `app.students_url` and see how it prints out the **full path instead of the relative path**.

    NOTE: In general, it's best to use the `_path` version so that nothing breaks if your server domain changes

- **Column 2**: This is the HTTP verb

- **Column 3**: This column shows what the path for the route will be and what parameters need to be passed to the route. As you may notice, the second row for the show route calls for an ID. When you pass the `:show` argument to the `resources` method, it will automatically create this route and assume that you will need to pass the `id` into the URL string. Whenever you have `id` parameters listed in the path like this, you will need to pass the route helper method an ID, so an example of what our **show route code would look like is `student_path(@student)`**. Notice how **this is different than the `index` route of `students_path`**.  

    **DEMO:**
    * In `rails console` you can call the route helpers.
    * Run `app.student_path(1)` and see what the resulting output is.

    SUMMARY: Running route helpers in the rails console is a great way of testing out routes to see what their exact output will be

- **Column 4**: This column shows the controller and action with a syntax of `controller#action`

## Examples using `link_to`

Let's look at an example in the Rails URL Helpers Lab:

```html
<div>
  <% @students.each do |student| %>
    1. <div><a href='<%= "/students/#{student.id}" %>'><%= student.first_name %></a></div>
    2. <div><%= link_to student.to_s, "/students/#{student.id}" %></div>
    3. <div><%= link_to student.to_s, student_path(student.id) %></div>
    4. <div><%= link_to student.to_s, student_path(student) %></div>
  <% end %>
</div>
```
Let's inspect how the link_to method translates these paths in HTML.

1. Without using the `link_to` method OR URL helpers: `<a href='<%= "/students/#{student.id}" %>'><%= student.first_name %></a></div>`

2. Hard Coded Path: `<%= link_to student.to_s, "/student/#{student.id}" %>`
  - Not flexible, hard to read


3. Route Helper: `<%= link_to student.to_s, student_path(student) %>`

  - Not hard coded, making it flexible. Easier to read.

## Custom Routes

#### [Using the :as option](https://learn.co/tracks/full-stack-web-development-v8/module-13-rails/section-4-intro-to-actionview/rails-url-helpers)

**Custom Route:** `get "students/:id/activate", to: "students#activate", as: "activate_student"`

**Points to:**
```
def activate
  @student = Student.find(params[:id])
  @student.active = !@student.active
  @student.save
  redirect_to student_path(@student)
end
```
**Now we can use this path:** `activate_student_path`
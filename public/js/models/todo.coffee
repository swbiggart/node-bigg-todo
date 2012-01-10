define ['underscore', 'backbone'], (_, Backbone) ->
  TodoModel = class extends Backbone.Model
    
    #use _id instead of id to work with mongodb
    idAttribute: "_id"
    
    # UrlRoot to CRUD against
    urlRoot: '/todos'
    
    # Default attributes for the todo.
    defaults:
      content: "empty todo..."
      done: false

    # Ensure that each todo created has `content`.
    initialize: ->
      if !@get("content")
        @set {"content": @defaults.content}

    # Toggle the `done` state of this todo item.
    toggle: ->
      @save {done: !@get("done")}

    # Remove this Todo from server and delete its view.
    clear: ->
      @destroy 
        success: (model, response) => 
          @view.remove()
      

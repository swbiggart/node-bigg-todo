depends = [
  'jquery',
  'underscore', 
  'backbone',
  'cs!collections/todos',
  'cs!views/todos',
  'text!templates/stats.html'
]

define depends, ($, _, Backbone, Todos, TodoView, statsTemplate) ->
  AppView = class extends Backbone.View

    # Instead of generating a new element, bind to the existing skeleton of
    # the App already present in the HTML.
    el: $ "#todoapp"

    # Our template for the line of statistics at the bottom of the app.
    statsTemplate: _.template statsTemplate

    # Delegated events for creating new items, and clearing completed ones.
    events:
      "keypress #new-todo":  "createOnEnter"
      "keyup #new-todo":     "showTooltip"
      "click .todo-clear a": "clearCompleted"

    # At initialization we bind to the relevant events on the `Todos`
    # collection, when items are added or changed. Kick things off by
    # loading any preexisting todos that might be saved on server.
    initialize: ->
      _.bindAll @, 'addOne', 'addAll', 'render'

      @input = @$("#new-todo");

      Todos.bind 'add',     @addOne
      Todos.bind 'reset',   @addAll
      Todos.bind 'all',     @render

      Todos.fetch()

    # Re-rendering the App just means refreshing the statistics -- the rest
    # of the app doesn't change.
    render: ->
      done = Todos.done().length
      @$('#todo-stats').html @statsTemplate
        total:      Todos.length,
        done:       Todos.done().length,
        remaining:  Todos.remaining().length

    # Add a single todo item to the list by creating a view for it, and
    # appending its element to the `<ul>`.
    addOne: (todo) ->
      view = new TodoView {model: todo}
      @$("#todo-list").append view.render().el

    # Add all items in the **Todos** collection at once.
    addAll: ->
      Todos.each @addOne

    # Generate the attributes for a new Todo item.
    newAttributes: ->
      return {
        content: @input.val(),
        order:   Todos.nextOrder(),
        done:    false
      }

    # If you hit return in the main input field, create new **Todo** model,
    # persisting it to server.
    createOnEnter: (e) ->
      if e.keyCode != 13
        return
      Todos.create @newAttributes()
      @input.val ''

    # Clear all done todo items, destroying their models.
    clearCompleted: ->
      _.each Todos.done(), (todo) -> todo.clear()
      false

    # Lazily show the tooltip that tells you to press `enter` to save
    # a new todo item, after one second.
    showTooltip: (e) ->
      tooltip = @$(".ui-tooltip-top")
      val = @input.val()
      tooltip.fadeOut()
      if @tooltipTimeout
        clearTimeout @tooltipTimeout
      if val == '' || val == @input.attr 'placeholder'
         return
      show = -> tooltip.show().fadeIn()
      @tooltipTimeout = _.delay show, 1000

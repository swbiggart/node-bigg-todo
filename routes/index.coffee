Todo = require('mongoose').model('Todo')

exports.index = (req, res) ->
  res.render 'index', { title: 'Todos' }

exports.create = (req, res) ->
  todo = new Todo req.body
  todo.save (err) ->
    if err
      res.send err
    res.send todo

exports.read = (req, res) ->
  Todo.find {}, (err, docs) ->
    if err
      res.send err
    res.send docs

exports.update = (req, res) ->
  delete req.body._id #remove _id from put so mongodb doesn't complain
  Todo.update {_id: req.params._id}, req.body, (err) ->
    res.send err

exports.delete =  (req, res) ->
  Todo.remove {_id: req.params._id}, (err) ->
    res.send err  
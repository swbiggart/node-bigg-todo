mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.ObjectId;

Todo = new Schema
  content: String
  done: Boolean

module.exports = mongoose.model 'Todo', Todo
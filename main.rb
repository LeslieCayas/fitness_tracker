require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'pry' if development?
require 'httparty'

enable :sessions

require_relative 'db/db'
require_relative 'models/users'
require_relative 'models/workouts'
require_relative 'helpers/session'

require_relative 'controllers/sessions_controller'
require_relative 'controllers/users_controller'
require_relative 'controllers/workout_controller'
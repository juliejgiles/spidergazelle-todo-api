require "action-controller"
require "clear"
require "./application.cr"
require "../models/task.cr"
require "json"
require "../helpers/serialiser.cr"
require "http/client"
require "log" # https://crystal-lang.org/api/0.34.0/Log.html
require "xml"

# class TasksController < ActionController::Base
class TasksController < Application
  # include JSON::Serializable
  
  before_action :find_task, only: [:show, :update, :destroy]
  # Lazy initialization via getter macro - https://crystal-lang.org/api/0.36.1/Object.html#getter(*names,&block)-macro
  getter task : Task { find_task }
  Log = ::Log.for("controller")

  # Error handling
  rescue_from JSON::SerializableError do |error|
    render text: error.message, status: 500
  end
  
  rescue_from ArgumentError do |exception|
  #   # render xml: exception, status: 500
    render text: exception, status: 500
  end

  # Root
  base "/tasks"

  # CRUD methods
  # GET /tasks/
  def index
    array_of_tasks = Task.query.select.to_a
    if array_of_tasks.size == 0
      render text: "No records"
    else
      render text: array_of_tasks.to_json
    end
  end

  # GET /tasks/:id
  def show
    # Log.debug { show }
    render text: task.to_json
  end

  # POST /tasks/
  def create
    new_task = Task.new(from_json(request.body.as(IO)))
    new_task.save!
    render text: new_task.to_json

    if !new_task.save
      puts "Could not save task"
    end
  end

  # PATCH /tasks/:id
  def update
    # user_input = JSON.parse(request.body.as(IO)).as_h
    # user_input.each do |key, value|
    # case key
    # when "name" then task.name = value
    # when "description" then task.description = value
    # end
    # task.done = key == "done" && value == "true"
    # task.save!

    ###############

    task_body = TaskBody.from_json(request.body.as(IO))
    task_body.each do |key, value|
      key = key.to_s

      case key
      when "name"        then task.name = task_body.name
      when "description" then task.description = task_body.description
      end
      task.done = key == "done" && value == "true"
      task.save!
    end

    render text: task.to_json
    if !new_task.save
      puts "Could not save task"
    end

    # Log.debug { update }
  end

  # DELETE /tasks/:id
  def destroy
    task.delete
    render text: Task.query.select.to_a.to_json
    if !task.delete
      puts "Could not delete task"
    end
  end

  # CORS - allow access from any origin for the below methods
  # https://iridakos.com/programming/2018/03/28/custom-http-headers
  options "/" do
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, PATCH, DELETE, HEAD, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
  end

  options "/:id" do
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, PATCH, DELETE, HEAD, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
  end

  private def find_task
    task = Task.find(params["id"])
    # Task.query.select.to_a.find(raw("tasks.id") == params["id"])
  end
end

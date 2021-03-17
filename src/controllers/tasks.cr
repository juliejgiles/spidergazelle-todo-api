require "action-controller"
require "./application.cr"
require "clear"
require "../models/task.cr"
require "json"
require "./serialiser.cr"
require "http/client"
require "log" # https://crystal-lang.org/api/0.34.0/Log.html
require "xml"

# class TasksController < ActionController::Base
class TasksController < Application
  before_action :find_task, only: [:show, :update, :destroy]
  # Lazy initialization via getter macro - https://crystal-lang.org/api/0.36.1/Object.html#getter(*names,&block)-macro
  getter task : Task { find_task }
  Log = ::Log.for("controller")

  # Error handling
  rescue_from JSON::SerializableError do |error|
    render text: error.message, status: 500
  end

  rescue_from NotImplementedError do |exception|
    render text: exception.message, status: 501
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
      render json: array_of_tasks.to_json
    end
  end

  # GET /tasks/:id
  def show
    # Log.debug { show }
    if task
      render json: task.to_json
    else
      render text: "Task id: #{params["id"]} can't be found", status: 400
    end
  end

  # POST /tasks/
  def create
    new_task = JSON.parse(request.body.as(IO)).to_json
    new_task = Task.create_from_json!(new_task)
    render json: new_task.to_json

    if !new_task.save
      render json: {error: "Could not be saved", status: 500}
    end
  end

  # PATCH /tasks/:id
  def update
    # task_body = TaskBody.from_json(request.body.as(IO))
    # task_body.each do |key, value|
    #   key = key.to_s

    #   case key
    #   when "name"        then task.name = task_body.name
    #   when "description" then task.description = task_body.description
    #   end
    #   task.done = key == "done" && value == "true"
    #   task.save!
    # end

    ###############
 
    # io = IO::Memory.new
    # io << {name: "test3", description: "test3", done: true, id: 4}.to_json
    # io.rewind

    task_body = TaskBody.from_json(request.body.as(IO))
    task_body = task.update_from_json!(task_body)

    render json: task.to_json
    if !task_body.save
      render json: {error: "Could not be saved", status: 500}
    end

    # Log.debug { update }
  
  end

  # DELETE /tasks/:id
  def destroy
    task.delete
    render json: Task.query.select.to_a.to_json
    if !task.delete
      render json: {error: "Could not be deleted", status: 500}
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

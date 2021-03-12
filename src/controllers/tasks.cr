require "action-controller"
require "../models/task.cr"
require "json" # https://crystal-lang.org/api/0.18.7/JSON/Builder.html
require "http/client"
require "log" #https://crystal-lang.org/api/0.34.0/Log.html

class TasksController < ActionController::Base
  # Root
  base "/tasks" 

  before_action :find_task, only: [:show, :update, :destroy]
  #Lazy initialization via getter macro - https://crystal-lang.org/api/0.36.1/Object.html#getter(*names,&block)-macro
  getter task : Task { find_task }

  # CRUD methods
  # GET /tasks/
  def index
    array_of_tasks = Task.query.select.to_a
    array_of_tasks.size == 0 ?  (render text: "No records") : (render text: array_of_tasks.to_json)
    
    # respond_with do
    #   html template("index.ecr")
    #   text "#{array_of_tasks}"
    #   json ({tasks: array_of_tasks})
    # end
  end

  # GET /tasks/:id
  def show
    
    Log.debug { show }
    render text: task.to_json
    # respond_with do
    #   html template("show.ecr")
    #   text "#{task}"
    #   json ({task: task})
    # end
  end

  # POST /tasks/
  def create
    new_task = Task.new(JSON.parse(request.body.as(IO)))
    new_task.save!
    render text: new_task.to_json
    # respond_with do
    #   # html template("new_task.ecr")
    #   text "#{new_task}"
    #   json ({tasks: new_task})
    #   array [new_task]
    # end

    if !new_task.save
      raise Exception.new("Could not save task")
    end
  end

  # PATCH /tasks/:id
  def update
    # task = Task.find(params[:id]) 
    # user_input = JSON.parse(request.body.as(IO)).as_h
    # task["name"] = user_input["title"].to_s if user_input.has_key?("title")
    # task["description"] = user_input["description"].to_s if user_input.has_key?("description")
    # task["done"] = true if user_input.has_key?("done" ) && user_input.has_value?("true" || true )
    # task.save! 
    # render text: task.to_json
    # if !new_task.save
    #   raise Exception.new("Could not save task")
    # end
  end

  # DELETE /tasks/:id
  def destroy
    # task.delete
    # render text: Task.query.select.to_a.to_json
    # if !task.delete
    #   raise Exception.new("Could not delete task")
    # end
  end

  # CORS - allowed methods for which requests can be made
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


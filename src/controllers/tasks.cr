require "action-controller"
require "../models/task.cr"
require "json" # https://crystal-lang.org/api/0.18.7/JSON/Builder.html
require "http/client"

class TasksController < ActionController::Base
  #Root
  base "/tasks"

  before_action :find_task, only: [:show, :update, :destroy]
  getter :array_of_tasks, :task

  #CRUD methods
  # GET /tasks/
  def index
    array_of_tasks = Task.query.select.to_a
    render json: ({array_of_tasks, 200})
    # respond_with do
    #   html template("index.ecr")
    #   text "#{array_of_tasks}"
    #   json ({tasks: array_of_tasks})
    # end
  end

  # GET /tasks/:id
  def show
    render json: ({task, 200})
    # respond_with do
    #   html template("show.ecr")
    #   text "#{task1}"
    #   json ({task: task1})
    # end
  end

  # GET "/tasks/new"
  # def new
  # end

  # POST /tasks/
  def create
   
    new_task = Task.new(JSON.parse(request.body.as(IO)))
    new_task.save!
    render json: ({new_task, 201})
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
  end

  # DELETE /tasks/:id
  def destroy
    task.delete
    render json: ({array_of_tasks, 200})
    if !task.delete 
      raise Exception.new("Could not delete task")
    end

  end

  #CORS - Allowed origins and allowed methods at which requests can be made
  #https://iridakos.com/programming/2018/03/28/custom-http-headers
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS"

  private def find_task
    task = Task.find(params[:id].to_i) || array_of_tasks.find( raw("tasks.id") == params[:id].to_i)  
  end
end

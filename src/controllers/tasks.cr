require "action-controller"
require "../models/task.cr"
require "xml"
require "json" # https://crystal-lang.org/api/0.18.7/JSON/Builder.html

class TasksController < ActionController::Base
  base "/tasks"

  before_action :find_task, only: [:show, :update, :destroy]
  getter :array_of_tasks, :task

  # GET /tasks/
  def index
    array_of_tasks = Task.query.select.to_a
    respond_with do
      html template("index.ecr")
      text "#{array_of_tasks}"
      json ({tasks: array_of_tasks})
    end
  end

  # GET /tasks/:id
  def show
    respond_with do
      html template("show.ecr")
      text "#{task1}"
      json ({task: task1})
    end
  end

  # GET "/tasks/new"
  # def new
  # end

  # POST /tasks/
  def create
   
    new_task = Task.new(JSON.parse(request.body.as(IO)))
    new_task.save!
    respond_with do
      html template("new_task.ecr")
      text "#{new_task}"
      json ({tasks: new_task})
    end 

    if !new_task.save 
      raise Exception.new("Could not save task")
    end
  end

  # PATCH /tasks/:id
  def update
  end

  # DELETE /tasks/:id
  def destroy
  end

  private def find_task
    # task = Task.find(params[:id])
    task = Task.query.where { raw("tasks.id") == id }
  end
end

require "action-controller"
require "../models/task.cr"
require "xml"

class TasksController < ActionController::Base
  base "/tasks"

  before_action :find_task, only: [:show, :update, :destroy]

  # GET /tasks/
  def index
    # task = Task.create(name: "test", description: "test", done: false)
    # task.save
    
    array_of_tasks = Task.query.first.inspect
    respond_with do
      html template("index.ecr")
      text "#{array_of_tasks}.to_s"
      json({tasks: array_of_tasks})
    end
  end

  # GET /tasks/:id
  def show
    
  end

  # GET "/tasks/new"
  def new
    
  end

  # POST /tasks/
  def create
    # task = Task.create(name: "test", description: "test", done: false)
    # task.save
    # respond_with do
    #         html template("index.ecr")
    #         text "#{task}.to_json"
    #         json({task: task})
    # end
  end

  # PATCH /tasks/:id
  def update
  end

  # DELETE /tasks/:id
  def destroy
    
  end

  private def find_task
    # task = Task.find(params[:id])
    task = Task.query.where{ raw("tasks.id") == id}
  end
end

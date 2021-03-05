require "action-controller"
require "../models/task.cr"


class TasksController < Application
base "/tasks"

before_action :find_task, only: [:show, :update, :destroy]

    #GET /tasks/
    def index
    end    

    #GET /tasks/:id
    def self.show 
    end

    #GET "/tasks/new"
    def new
    end

    #POST /tasks/
    def create
    end

    #PATCH /tasks/:id
    def update
    end  

    # DELETE /tasks/:id
    def destroy
    end

    private def find_task
        task = Task.find(params[:id])
    end

end 
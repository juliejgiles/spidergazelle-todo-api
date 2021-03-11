require "active-model"
require "clear"

class Task
  include Clear::Model

  self.table = "tasks"

  column name : String
  column description : String
  column done : Bool

  column id : Int32, primary: true, presence: false
end

require "json"
require "clear"

# https://crystal-lang.org/api/0.36.1/JSON/Serializable.html
class TaskBody
  include JSON::Serializable

  getter name : String
  getter description : String
  getter done : Bool
  getter id : Int32
end

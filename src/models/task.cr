include "active-model"
include "clear"

class Task < ActiveModel::Model
    include Clear::Model

    column name : String
    column description : String
    column done : Bool

    column id : Int32, primary: true, presence: false
end
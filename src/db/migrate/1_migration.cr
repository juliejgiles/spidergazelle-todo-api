include "clear"

class CreateTable1
    include Clear::Migration
    
    def change(direction)
        direction.up do
            execute("CREATE TABLE tasks(id serial primary key not null, name string not null, description string not null, done boolean)")
        end

        direction.down do
            execute("DROP TABLE tasks")
        end

    end

    
end 
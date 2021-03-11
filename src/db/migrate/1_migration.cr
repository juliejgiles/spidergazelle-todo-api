require "clear"

class CreateTable1
  include Clear::Migration

  # Error message fro reverting a migration that is irreversible
  include Clear::ErrorMessages

  class IrreversibleMigration < Exception; end

  def change(direction)
    direction.up do
      execute("CREATE TABLE tasks(id serial primary key not null, name text not null, description text not null, done boolean)")
    end

    direction.down do
      execute("DROP TABLE tasks")
    end
  end
end

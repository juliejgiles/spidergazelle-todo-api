# Spider-Gazelle To-do-list API

## Documentation

ROUTES:

- GET **/tasks** to view all tasks
- GET **/tasks/:id** to view one task
- POST **/tasks** to add a new task
- PATCH **/tasks/:id** to update a task
- DELETE **/tasks/:id** to delete a task

## Running app

- Run `crystal /src/app.cr` to run in development mode

## Testing

- Run `crystal spec`
- to run in development mode `crystal ./src/app.cr`

## Compiling

`crystal build ./src/app.cr`

### Deploying

Once compiled you are left with a binary `./app`

- for help `./app --help`
- viewing routes `./app --routes`
- run on a different port or host `./app -b 0.0.0.0 -p 80`

require "./spec_helper"
Clear::SQL.init(App::POSTGRES_URL)
# ################ Controller Specs ###############

describe "TasksController" do
  task_test = Task.new
  Spec.before_each do
    task_test.name = "Test Name"
    task_test.description = "Test description"
    task_test.done = false
    task_test.save!
  end

  Spec.after_each do
    task_test.delete
  end

  # Index method
  with_server do
    it "should list all tasks", focus: true do
      result = curl("GET", "/tasks")
      result.status_code.should eq(200)
    end
  end

  # with_server do
  #   it "should say 'no records' if there are none", focus:true do
  #     result.body.length == 0
  #     result = curl("GET", "/tasks")
  #     result.body.should eq("No records")
  #   end
  # end

  # Show method
  it "shows a task", focus: true do
    result = curl("GET", "/tasks/#{task_test.id}")
    JSON.parse(result.body).as_h["id"].should eq(task_test.id)
    result.status_code.should eq(200)
  end

  # Create method
  it "creates a task", focus: true do
    newtask_test = Task.new({name: "Test Name 2", description: "Test Description 2", done: false})
    result = curl("POST", "/tasks", body: newtask_test.to_json)
    result.status_code.should eq(200)
    JSON.parse(result.body).as_h["name"].should eq(newtask_test.name)
  end

  # Update method
  with_server do
    pending "updates a task" do
      task_test.name = "Changed name"
      result = curl("PATCH", "/tasks/#{task_test.id}", body: task_test.to_json)
      result.status_code.should eq(200)
      JSON.parse(result.body).as_h["name"].should eq(task_test.name)
    end
  end
  # Delete method
  with_server do
    pending "deletes a task" do
      result = curl("DELETE", "/tasks/#{task_test.id}")
      result.status_code.should eq(200)
    end
  end
end

# ############ Model Specs #################

describe "Model" do
  task_test = Task.new
  Spec.before_each do
    task_test.name = "Test Name"
    task_test.description = "Test description"
    task_test.done = false
    task_test.save!
  end

  Spec.after_each do
    task_test.delete
  end

  pending "should retain new entries" do
    Task.query.select.first.empty?.should be_false
  end

  pending "should dispose of deleted entries" do
    task_test.delete
    Task.query.select.first.empty?.should be_true
  end
end

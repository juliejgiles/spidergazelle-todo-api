require "./spec_helper"

################# Controller Specs ###############

describe Controller do
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
  
  #Index method
    with_server do
      pending "should list all tasks" do
        result = curl("GET", "/tasks")
        result.status_code.should eq(200)
      end
    end
  
  #Show method
    pending "shows a task" do
      result = curl("GET", "/tasks/#{task_test.id}")
      JSON.parse(result.body)as_h["id"].should eq(task_test.id)
      result.status_code.should eq(200)
    end 

  #Create method
    pending "creates a task" do
      newtask_test = Task.new({name: "Test Name 2", description: "Test Description 2", done: false})
      result = curl("POST", "/tasks", body: newtask_test.to_json)
      result.status_code.should eq(200)
      JSON.parse(result.body)as_h["name"].should eq(newtask_test.name)
    end 

#Update method
    pending "updates a task" do
      task_test.name = "Changed name"
      result = curl("PATCH", "/tasks/#{task_test.id}", body: task_test.to_json)
      result.status_code.should eq(200)
      JSON.parse(result.body)as_h["name"].should eq(task_test.name)
    end

#Delete method
    pending "deletes a task" do
      result = curl("DELETE", "/tasks")
      result.status_code.should eq(200)
    end

end


############# Model Specs #################

describe Model do
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
    Task.query.select.first.empty?should be_false
  end

  pending "should dispose of deleted entries" do
    task_test.delete
    Task.query.select.first.empty?should be_true
  end
end
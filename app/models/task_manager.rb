class TaskManager
  attr_reader :database

  def initialize(database)
    @database ||= database
  end

  def create(task)
    database.transaction do
      database['tasks'] ||= []
      database['total'] ||= 0
      database['total'] += 1
      database['tasks'] << { "id" => database['total'], "title" => task[:title], "description" => task[:description] }
    end
  end

  def raw_tasks
    database.transaction do
      database['tasks'] || []
    end
  end

  def all
    raw_tasks.map {|data| Task.new(data)}
  end

  def raw_task(id)
    raw_tasks.find { |task| task["id"] == id }
  end

  def find(id)
    Task.new(raw_task(id))
  end

  def update(task, id)
    database.transaction do
      task_to_update = database['tasks'].find {|task| task["id"] == id }
      task_to_update["title"] = task[:title]
      task_to_update["description"] = task[:description]
    end
  end

  def delete(id)
    database.transaction do
      database['tasks'].delete_if { |task| task["id"] == id }
    end
  end

  def delete_all
    database.transaction do
      database['tasks'] = []
      database['total'] = 0
    end
  end

end

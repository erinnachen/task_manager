require_relative '../test_helper'

class TaskManagerTest < Minitest::Test
  include TestHelpers
  def test_can_create_a_task
    title = "my title"
    description = "whatevs"
    create_single_task(title, description)
    task = task_manager.all.last

    assert task.id
    assert_equal title, task.title
    assert_equal description, task.description
  end

  def test_all_returns_a_bunch_of_tasks
    n = 4
    create_multiple_tasks(n)

    tasks = task_manager.all
    assert_equal n, tasks.length
    assert_kind_of Task, tasks.first
  end

  def test_find_a_task_by_id
    n = 25
    id_num = 23
    create_multiple_tasks(n)

    task = task_manager.find(id_num)
    assert_kind_of Task, task
    assert_equal id_num, task.id
  end

  def test_raises_an_exception_if_id_cant_be_found
    assert_raises NoMethodError do
      task_manager.find(35)
    end
  end

  def test_can_update_a_task
    create_single_task
    id_num = task_manager.all.first.id

    new_data  = {
      title: "Cool title",
      description: "Juicier description"
    }
    task_manager.update(new_data, id_num)
    task = task_manager.find(id_num)

    assert_equal "Cool title", task.title
    assert_equal "Juicier description", task.description
  end

  def test_can_delete_a_task
    create_single_task
    id_num = task_manager.all.first.id

    refute_empty task_manager.all
    task_manager.delete(id_num)
    assert_empty task_manager.all
  end

  def test_doesnt_change_database_when_deleting_a_non_existant_task
    title = "Another title"
    create_single_task(title)
    id_num = task_manager.all.first.id

    assert_equal 1, task_manager.all.length
    task_manager.delete(id_num+2)
    assert_equal 1, task_manager.all.length
    assert_equal title, task_manager.all.first.title
  end

  def create_single_task(title = "Title", description = "Description")
    data  = {
      title: title,
      description: description
    }
    task_manager.create(data)
  end

  def create_multiple_tasks(n)
    n.times do |i|
      create_single_task("Title #{i}", "Some description: #{i}")
    end
  end
end

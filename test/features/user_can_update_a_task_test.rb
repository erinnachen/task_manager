require_relative '../test_helper'

class UserUpdatesTaskTest < Minitest::Test
  include Capybara::DSL
  include TestHelpers

  def test_user_can_update_a_task
    task_manager.create({title: "Capybara update test",
    description: "wonderful test"})
    refute_empty task_manager.all
    id = task_manager.all.last.id

    visit '/tasks'
    click_link("Edit")
    assert_equal "/tasks/#{id}/edit", current_path
    fill_in('task[title]', with: "Test website with Capybara")
    fill_in('task[description]', with: "Should test update things")
    click_button("Submit")
    within(".tasks") do
      assert page.has_content? ("Test website with Capybara")
    end
    click_link("Test website with Capybara")
    within(".task-description") do
      assert page.has_content? ("Should test update things")
    end
  end

end

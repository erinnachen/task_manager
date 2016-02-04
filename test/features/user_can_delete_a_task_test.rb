require_relative '../test_helper'

class UserCreatesTaskTest < Minitest::Test
  include Capybara::DSL
  include TestHelpers

  def test_user_can_delete_a_task
    title = "Capybara test"
    description = "Hi Capybara do you like me"
    data  = {
      title: title,
      description: description
    }
    task_manager.create(data)

    visit '/tasks'
    within(".tasks") do
      assert page.has_content? (title)
    end
    click_button("Delete")
    within(".tasks") do
      refute page.has_content? (title)
    end
  end

end

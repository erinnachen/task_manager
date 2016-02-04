require_relative '../test_helper'

class UserCreatesTaskTest < Minitest::Test
  include Capybara::DSL
  include TestHelpers

  def test_with_valid_attributes
    visit '/'
    click_link("New Task")
    fill_in('task[title]', with: "Test website with Capybara")
    fill_in('task[description]', with: "Should test things")
    click_button("Submit")
    assert_equal "/tasks", current_path
    within(".tasks") do
      assert page.has_content? ("Test website with Capybara")
    end
  end
end

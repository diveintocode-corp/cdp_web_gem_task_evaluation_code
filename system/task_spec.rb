require 'rails_helper'
RSpec.describe do
  5.times do |n|
    let!(:"task#{n+1}") { FactoryBot.create(:"task#{n+1}") }
  end
  describe '1. All tasks should be displayed in the task list screen.' do
    it 'All tasks should be displayed.' do
      visit tasks_path
      expect(page).to have_content 'task title 1'
      expect(page).to have_content 'task title 12'
      expect(page).to have_content 'task title 3'
      expect(page).to have_content 'task title 4'
      expect(page).to have_content 'task title 5'
    end
  end
  describe '2. Ability to do a fuzzy search for both title and description in one form.' do
    it 'Fuzzy search by title should function properly.' do
      visit tasks_path
      find('input[type="search"]').set('title 1')
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 1'
      expect(page).to have_content 'task title 12'
      expect(page).not_to have_content 'task title 3'
      expect(page).not_to have_content 'task title 4'
      expect(page).not_to have_content 'task title 5'
    end
    it 'Fuzzy search by description should function properly.' do
      visit tasks_path
      find('input[type="search"]').set('description 3')
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 3'
      expect(page).to have_content 'task title 4'
      expect(page).not_to have_content 'task title 1'
      expect(page).not_to have_content 'task title 12'
      expect(page).not_to have_content 'task title 5'
    end
  end
  describe '3. Searches by time period must be above or below the specified date.' do
    it '`_gteq` and `_lteq` must be used' do
      visit tasks_path
      expect(page).to have_selector '#q_deadline_gteq'
      expect(page).to have_selector '#q_deadline_lteq'
    end
  end
  describe '4. Ability to search by time period.' do
    it 'Searching for a range of years, months, and dates should function properly.' do
      visit tasks_path
      fill_in "q_deadline_gteq", with: Date.parse("2023-01-01")
      fill_in "q_deadline_lteq", with: Date.parse("2024-01-01")
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 3'
      expect(page).to have_content 'task title 4'
      expect(page).not_to have_content 'task title 1'
      expect(page).not_to have_content 'task title 12'
      expect(page).not_to have_content 'task title 5'
    end
  end
  describe '5. Searching by time period should be possible for either start or end alone.' do
    it 'Searching by start period only should work properly.' do
      visit tasks_path
      fill_in "q_deadline_gteq", with: Date.parse("2023-01-01")
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 3'
      expect(page).to have_content 'task title 4'
      expect(page).to have_content 'task title 5'
      expect(page).not_to have_content 'task title 1'
      expect(page).not_to have_content 'task title 12'
    end
    it 'Searching by end period only should function properly.' do
      visit tasks_path
      fill_in "q_deadline_lteq", with: Date.parse("2023-01-01")
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 1'
      expect(page).to have_content 'task title 12'
      expect(page).to have_content 'task title 3'
      expect(page).not_to have_content 'task title 5'
      expect(page).not_to have_content 'task title 4'
    end
  end
  describe '6. Search function by status should be implemented with radio buttons.' do
    it 'The radio button must be present.' do
      visit tasks_path
      expect(page).to have_selector 'input[type="radio"]'
    end
  end
  describe '7. Search by status should function properly.' do
    it 'All tasks should be displayed when searching with the status "unspecified".' do
      visit tasks_path
      choose 'q_status_eq_'
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 1'
      expect(page).to have_content 'task title 12'
      expect(page).to have_content 'task title 3'
      expect(page).to have_content 'task title 4'
      expect(page).to have_content 'task title 5'
    end
    it 'When searching for tasks with the status "todo", only tasks with the status "todo" should be displayed.' do
      visit tasks_path
      choose 'q_status_eq_0'
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 1'
      expect(page).to have_content 'task title 4'
      expect(page).not_to have_content 'task title 12'
      expect(page).not_to have_content 'task title 3'
      expect(page).not_to have_content 'task title 5'
    end
    it 'When searching for tasks with a status of "doing", only tasks with a status of "doing" will be displayed.' do
      visit tasks_path
      choose 'q_status_eq_1'
      find('input[type="submit"]').click
      expect(page).to have_content 'task description 2'
      expect(page).to have_content 'task description 5'
      expect(page).not_to have_content 'task description 1'
      expect(page).not_to have_content 'task description 3'
      expect(page).not_to have_content 'task description 34'
    end
    it 'When searching for tasks with a status of "done," only tasks with a status of "done" will be displayed.' do
      visit tasks_path
      choose 'q_status_eq_2'
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 3'
      expect(page).not_to have_content 'task title 1'
      expect(page).not_to have_content 'task title 12'
      expect(page).not_to have_content 'task title 4'
      expect(page).not_to have_content 'task title 5'
    end
  end
  describe '8. Status must be selected as "unspecified" by default.' do
    it 'Radio buttons must be checked "unspecified" by default.' do
      visit tasks_path
      expect(find("#q_status_eq_")).to be_checked
    end
  end
  describe '9. Searching by multiple criteria should function properly.' do
    it 'Search by keyword and search period should function properly' do
      visit tasks_path
      find('input[type="search"]').set('task title 1')
      fill_in "q_deadline_gteq", with: Date.parse("2020-01-01")
      fill_in "q_deadline_lteq", with: Date.parse("2020-12-31")
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 1'
      expect(page).not_to have_content 'task title 12'
      expect(page).not_to have_content 'task title 3'
      expect(page).not_to have_content 'task title 4'
      expect(page).not_to have_content 'task title 5'
    end
    it 'Search by keyword, start period, and status should function properly.' do
      visit tasks_path
      find('input[type="search"]').set('task description 3')
      fill_in "q_deadline_gteq", with: Date.parse("2023-12-31")
      choose 'q_status_eq_0'
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 4'
      expect(page).not_to have_content 'task title 1'
      expect(page).not_to have_content 'task title 12'
      expect(page).not_to have_content 'task title 3'
      expect(page).not_to have_content 'task title 5'
    end
  end
  describe '10. A sorting function by time period should be implemented.' do
    it 'Click the sort link to display tasks in descending order, click again to display tasks in ascending order' do
      visit tasks_path
      find('.sort_link').click
      sleep 0.5
      task_list = all('tr')
      expect(task_list[1]).to have_content 'task title 1'
      expect(task_list[2]).to have_content 'task title 12'
      expect(task_list[3]).to have_content 'task title 3'
      expect(task_list[4]).to have_content 'task title 4'
      expect(task_list[5]).to have_content 'task title 5'
      find('.sort_link').click
      sleep 0.5
      task_list = all('tr')
      expect(task_list[1]).to have_content 'task title 5'
      expect(task_list[2]).to have_content 'task title 4'
      expect(task_list[3]).to have_content 'task title 3'
      expect(task_list[4]).to have_content 'task title 12'
      expect(task_list[5]).to have_content 'task title 1'
    end
  end
  describe '11. Search function allows sorting of tasks that have been narrowed down' do
    it 'Sorting on tasks searched by start period and status works properly' do
      visit tasks_path
      fill_in "q_deadline_gteq", with: Date.parse("2021-01-01")
      choose 'q_status_eq_1'
      find('input[type="submit"]').click
      find('.sort_link').click
      sleep 0.5
      task_list = all('tr')
      expect(task_list[1]).to have_content 'task title 12'
      expect(task_list[2]).to have_content 'task title 5'
      find('.sort_link').click
      sleep 0.5
      task_list = all('tr')
      expect(task_list[1]).to have_content 'task title 5'
      expect(task_list[2]).to have_content 'task title 12'
    end
  end
end

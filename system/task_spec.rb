require 'rails_helper'
RSpec.describe do
  Task.destroy_all
  5.times do |n|
    let!(:"task#{n+1}") { FactoryBot.create(:"task#{n+1}") }
  end
  describe '1. タスク一覧画面にすべてのタスクが表示されること' do
    it 'すべてのタスクが表示されること' do
      visit tasks_path
      expect(page).to have_content 'task title 1'
      expect(page).to have_content 'task title 12'
      expect(page).to have_content 'task title 3'
      expect(page).to have_content 'task title 4'
      expect(page).to have_content 'task title 5'
    end
  end
  describe '2. 1つのフォームでtitleとdescriptionのどちらでもあいまい検索ができること' do
    it 'titleによるあいまい検索が正常に機能すること' do
      visit tasks_path
      find('input[type="search"]').set('title 1')
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 1'
      expect(page).to have_content 'task title 12'
      expect(page).not_to have_content 'task title 3'
      expect(page).not_to have_content 'task title 4'
      expect(page).not_to have_content 'task title 5'
    end
    it 'descriptionによるあいまい検索が正常に機能すること' do
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
  describe '3. 期間による検索は、指定した年月日以上・以下で検索すること' do
    it '`_gteq`と`_lteq`が使用されていること' do
      visit tasks_path
      expect(page).to have_selector '#q_deadline_gteq'
      expect(page).to have_selector '#q_deadline_lteq'
    end
  end
  describe '4. 期間による検索ができること' do
    it '年月日の範囲を指定した検索が正常に機能すること' do
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
  describe '5. 期間による検索は、開始と終了のどちらか一方だけでも検索できること' do
    it '開始期間のみによる検索が正常に機能すること' do
      visit tasks_path
      fill_in "q_deadline_gteq", with: Date.parse("2023-01-01")
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 3'
      expect(page).to have_content 'task title 4'
      expect(page).to have_content 'task title 5'
      expect(page).not_to have_content 'task title 1'
      expect(page).not_to have_content 'task title 12'
    end
    it '終了期間のみによる検索が正常に機能すること' do
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
  describe '6. ステータスによる検索機能がラジオボタンで実装されていること' do
    it 'ラジオボタンが存在すること' do
      visit tasks_path
      expect(page).to have_selector 'input[type="radio"]'
    end
  end
  describe '7. ステータスによる検索が正常に機能すること' do
    it 'ステータスを「指定なし」で検索した場合、すべてのタスクが表示されること' do
      visit tasks_path
      choose 'q_status_eq_'
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 1'
      expect(page).to have_content 'task title 12'
      expect(page).to have_content 'task title 3'
      expect(page).to have_content 'task title 4'
      expect(page).to have_content 'task title 5'
    end
    it 'ステータスを「todo」で検索した場合、ステータスが「todo」のタスクのみ表示されること' do
      visit tasks_path
      choose 'q_status_eq_0'
      find('input[type="submit"]').click
      expect(page).to have_content 'task title 1'
      expect(page).to have_content 'task title 4'
      expect(page).not_to have_content 'task title 12'
      expect(page).not_to have_content 'task title 3'
      expect(page).not_to have_content 'task title 5'
    end
    it 'ステータスを「doing」で検索した場合、ステータスが「doing」のタスクのみ表示されること' do
      visit tasks_path
      choose 'q_status_eq_1'
      find('input[type="submit"]').click
      expect(page).to have_content 'task description 2'
      expect(page).to have_content 'task description 5'
      expect(page).not_to have_content 'task description 1'
      expect(page).not_to have_content 'task description 3'
      expect(page).not_to have_content 'task description 34'
    end
    it 'ステータスを「done」で検索した場合、ステータスが「done」のタスクのみ表示されること' do
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
  describe '8. ステータスは、デフォルトで「指定なし」が選択されていること' do
    it 'ラジオボタンはデフォルトで「指定なし」にチェックされていること' do
      visit tasks_path
      expect(find("#q_status_eq_")).to be_checked
    end
  end
  describe '9. 複数条件による検索が正常に機能すること' do
    it 'キーワードと検索期間による検索が正常に機能すること' do
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
    it 'キーワードと開始期間とステータスによる検索が正常に機能すること' do
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
  describe '10. 期間に対し、ソート機能が実装されていること' do
    it 'ソートリンクをクリックすると降順に、もう一度クリックすると昇順にタスクが表示される' do
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
  describe '11. 検索機能で絞り込んだタスクをソートできること' do
    it '開始期間とステータスによる検索後のソートが正常に機能する' do
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

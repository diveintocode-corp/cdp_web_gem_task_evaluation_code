FactoryBot.define do
  factory :task1, class: Task  do
    title { 'task title 1' }
    description { 'task description 1' }
    status { 'todo' }
    deadline { '2020-01-01' }
  end
  factory :task2, class: Task  do
    title { 'task title 12' }
    description { 'task description 2' }
    status { 'doing' }
    deadline { '2021-01-01' }
  end
  factory :task3, class: Task  do
    title { 'task title 3' }
    description { 'task description 3' }
    status { 'done' }
    deadline { '2023-01-01' }
  end
  factory :task4, class: Task  do
    title { 'task title 4' }
    description { 'task description 34' }
    status { 'todo' }
    deadline { '2024-01-01' }
  end
  factory :task5, class: Task  do
    title { 'task title 5' }
    description { 'task description 5' }
    status { 'doing' }
    deadline { '2025-01-01' }
  end
end

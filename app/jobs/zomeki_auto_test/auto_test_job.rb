module ZomekiAutoTest
  class AutoTestJob < ApplicationJob
    queue_as :default

    def perform(test)
      require 'open3'
      require 'csv'
      scenarios = ''
      results = ''
      error = ''
      s = ''

      for count in 0..125
        scenario, error, s = Open3.capture3("bundle exec rspec /var/www/zomeki_auto_test_files/spec/features/ボタンクリック.feature -e '_" + (count+1).to_s + " '")
        CSV.open('/var/www/zomeki_auto_test_files/error.csv','w') do |test|
          test.flock(File::LOCK_EX)
          test << [scenario, error, s]
        end
        scenarios = scenario.match(%r{ /\}\n\n:(.+?)_[0-9]})[1]
        if scenario.include?('[ログアウト完了]')
          results = '〇'
        else
          results = '×'
        end
        if count == 0
          CSV.open('/var/www/zomeki_auto_test_files/test_result.csv','w') do |test|
            test.flock(File::LOCK_EX)
            test << [scenarios, results]
          end
        else
          CSV.open('/var/www/zomeki_auto_test_files/test_result.csv','a') do |test|
            test.flock(File::LOCK_EX)
            test << [scenarios, results]
          end
        end
      end
    end
  end
end

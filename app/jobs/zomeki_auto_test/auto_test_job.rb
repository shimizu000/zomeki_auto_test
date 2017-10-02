module ZomekiAutoTest
  class AutoTestJob < ApplicationJob
    queue_as :default

    def perform(file_name)
      require 'open3'
      require 'csv'
      require "date"
      scenarios = ''
      results = ''
      error = ''
      s = ''
      daytime = DateTime.now
      daytime = daytime.strftime("%Y/%m/%d %H:%M:%S")

      scenario, error, s = Open3.capture3('bundle exec rspec /var/www/zomeki_auto_test_files/spec/features/' + file_name + '.feature')
      Dir.mkdir('/var/www/zomeki_auto_test_files/results/') unless Dir.exist?('/var/www/zomeki_auto_test_files/results/')
      CSV.open('/var/www/zomeki_auto_test_files/results/' + file_name + '_scenario.csv','w') do |test|
        test << [scenario]
      end
      CSV.open('/var/www/zomeki_auto_test_files/results/' + file_name + '_error.csv','w') do |test|
       test << [error]
      end
      texts = scenario.split('::')

      for n in 0..(texts.count-1)
        if n == 0
          CSV.open('/var/www/zomeki_auto_test_files/results/' + file_name + '_result.csv','w') do |test|
            test << [daytime]
          end
        else
          scenarios = texts[n].match(%r{(.+?)_[0-9]})[1]
          if texts[n].include?('[ログアウト完了]')
            results = '〇'
          else
            results = '×'
          end
          CSV.open('/var/www/zomeki_auto_test_files/results/' + file_name + '_result.csv','a') do |test|
            test << [scenarios, results]
          end
          break if texts[n].include?('Failures:') || texts[n].include?('Pending:')
        end
      end
    end
  end
end

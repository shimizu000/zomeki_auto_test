class ZomekiAutoTest::TestsController < Cms::Controller::Admin::Base
  include ZomekiAutoTest
  layout  'admin/cms'
  require 'open3'
  require 'csv'

  def pre_dispatch
    return http_error(403) unless Core.user.root?
  end

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    Rails.logger.error "auto_testレコードは見つかりませんでした。"
  end

  def start
    start = Open3.capture3("./bin/delayed_job --queue=default start")
    AutoTestJob.perform_later(1)
    redirect_to root_path, notice: '自動テストを開始しました。'
  end

  def index
    scenarios = Array.new(0)
    results = Array.new(0)
    if File.exist?('spec/test_result.csv')
      data_list = CSV.read('spec/test_result.csv')
      n = 0
      while n >= 0
        break if data_list[n] == nil
        scenarios[n] = data_list[n][0]
        results[n] = data_list[n][1]
        n += 1
      end
      if n < 126
        scenarios[n] = 'テスト実行中...'
        results[n] = ''
      end
    else
      scenarios[0] = 'no data'
      results[0] = 'no data'
    end

    @auto_test_scenarios = scenarios
    @auto_test_results = results
  end

end

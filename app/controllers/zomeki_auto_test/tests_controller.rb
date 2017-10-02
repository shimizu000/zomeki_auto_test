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
    AutoTestJob.perform_later(params[:id])
    text = '自動テスト"' + params[:id] + '"を開始しました。'
    redirect_to root_path, notice: text
  end

  def import
    if params[:file].blank?
      redirect_to root_path, alert: 'インポートするファイルを選択してください(対応形式:CSV・feature)'
    else
      file_data = params[:file]
      @original_name = file_data.original_filename
      @content_type = file_data.content_type
      @read = file_data.read

      if File.extname(@original_name) == '.csv'
        Dir.mkdir('/var/www/zomeki_auto_test_files/csv_files/') Dir.exist?('/var/www/zomeki_auto_test_files/csv_files/')
        File.open('/var/www/zomeki_auto_test_files/csv_files/' + @original_name, 'wb') do |of|
          of.write(@read)
        end

        read, error, s = Open3.capture3('ruby /var/www/zomeki_auto_test_files/spec/read_csv.rb /var/www/zomeki_auto_test_files/csv_files/' + @original_name)
        redirect_to root_path
      elsif File.extname(@original_name) == '.feature'
        File.open('/var/www/zomeki_auto_test_files/spec/features/' + @original_name, 'wb') do |of|
          of.write(@read)
        end
        redirect_to root_path
      else
        redirect_to root_path, alert: 'このファイルはインポートできません(対応形式:CSV・feature)'
      end
    end
  end

  def index
    files = Array.new(0)
    Dir.glob("/var/www/zomeki_auto_test_files/**/*.feature").each do |file_name|
      names = file_name.match(%r{\/features\/(.+?)\.feature})[1]
      files << names
    end
    files.sort! do |a, b|
      ret = a.casecmp(b)
      ret == 0 ? a <=> b : ret
    end
    @auto_test_file_names = files

    days = Array.new(0)
    for n in 0..(@auto_test_file_names.count-1)
      file_name = @auto_test_file_names[n]
      Dir.mkdir('/var/www/zomeki_auto_test_files/results/') Dir.exist?('/var/www/zomeki_auto_test_files/results/')
      if File.exist?('/var/www/zomeki_auto_test_files/results/' + file_name + '_result.csv')
        data_list = CSV.read('/var/www/zomeki_auto_test_files/results/' + file_name + '_result.csv')
        days[n] = data_list[0][0]
      else
        days[n] = 'no data'
      end
    end
    @auto_test_days = days
  end

  def result
    scenarios = Array.new(0)
    results = Array.new(0)
    file_name = params[:id]
    Dir.mkdir('/var/www/zomeki_auto_test_files/results/') Dir.exist?('/var/www/zomeki_auto_test_files/results/')
    if File.exist?('/var/www/zomeki_auto_test_files/results/' + file_name + '_result.csv')
      data_list = CSV.read('/var/www/zomeki_auto_test_files/results/' + file_name + '_result.csv')
      n = 1
      while n >= 1
        break if data_list[n] == nil
        scenarios[n-1] = data_list[n][0]
        results[n-1] = data_list[n][1]
        n += 1
      end
    else
      scenarios[0] = 'no data'
      results[0] = 'no data'
    end

    @auto_test_scenarios = scenarios
    @auto_test_results = results
    @auto_test_id = params[:id]
  end

  def scenario
    output = ''
    texts = ''
    file_name = params[:id]
    Dir.mkdir('/var/www/zomeki_auto_test_files/results/') Dir.exist?('/var/www/zomeki_auto_test_files/results/')
    if File.exist?('/var/www/zomeki_auto_test_files/results/' + file_name + '_scenario.csv')
      output = File.read('/var/www/zomeki_auto_test_files/results/' + file_name + '_scenario.csv')
      output.gsub!(/""/, '"')
    else
      output = 'no data'
    end

    @scenario_output = output
    @auto_test_id = params[:id]
  end

  def detail
    output = ''
    file_name = params[:id]
    if File.exist?('/var/www/zomeki_auto_test_files/spec/features/' + file_name + '.feature')
      output = File.read('/var/www/zomeki_auto_test_files/spec/features/' + file_name + '.feature')
    else
      output = 'no data'
    end

    @scenario_output = output
    @auto_test_id = params[:id]
  end

  def destroy
    file_name = params[:id]
    File.delete('/var/www/zomeki_auto_test_files/spec/features/' + file_name + '.feature') if File.exist?('/var/www/zomeki_auto_test_files/spec/features/' + file_name + '.feature')
    File.delete('/var/www/zomeki_auto_test_files/results/' + file_name + '_result.csv') if File.exist?('/var/www/zomeki_auto_test_files/results/' + file_name + '_result.csv')
    File.delete('/var/www/zomeki_auto_test_files/results/' + file_name + '_error.csv') if File.exist?('/var/www/zomeki_auto_test_files/results/' + file_name + '_error.csv')
    File.delete('/var/www/zomeki_auto_test_files/results/' + file_name + '_scenario.csv') if File.exist?('/var/www/zomeki_auto_test_files/results/' + file_name + '_scenario.csv')
    File.delete('/var/www/zomeki_auto_test_files/csv_files/' + file_name + '.csv') if File.exist?('/var/www/zomeki_auto_test_files/csv_files/' + file_name + '.csv')

    text = 'ファイル"' + params[:id] + '"を削除しました。'
    redirect_to root_path, notice: text
  end
end

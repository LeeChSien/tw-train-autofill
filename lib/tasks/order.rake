namespace :order do

  desc "default"
  task :default => :environment do
    browser = Watir::Browser.new :firefox
    browser.goto 'http://railway.hinet.net/'

    menu_frame = browser.frame(:name, 'lMenu')
    main_frame = browser.frame(:name, 'cMain')
    menu_frame.wait_until_present(60)

    menu_order_single_btn = menu_frame.img(alt: '訂去回票')
    menu_order_single_btn.wait_until_present(10)

    menu_order_single_btn.click

    menu_order_single_by_number = menu_frame.a(title: '車次訂去回票')
    menu_order_single_by_number.wait_until_present(10)

    menu_order_single_by_number.click

    input_person_id = main_frame.text_field(id: 'person_id')
    input_person_id.wait_until_present(10)

    # 正式跑記得改身分證
    input_person_id.set 'F111111111'

    select_from_station = main_frame.select_list(id: 'from_station')
    select_from_station.wait_until_present(10)
    select_from_station.select '100-台北'

    select_to_station = main_frame.select_list(id: 'to_station')
    select_to_station.wait_until_present(10)
    select_to_station.select '004-台東'


    #### 去程
    select_getin_date = main_frame.select_list(id: 'getin_date')
    select_getin_date.wait_until_present(10)

    # 正式跑記得改正式日期
    select_getin_date.select '2015/10/02【五】'
    # select_getin_date.select '2015/10/09【五】'

    input_train_no = main_frame.text_field(id: 'train_no')
    input_train_no.wait_until_present(10)

    # 正式跑記得選要的班次
    # input_train_no.set '616'
    input_train_no.set '5628'

    begin
      select_order_qty_str = main_frame.select_list(id: 'order_qty_str')
      select_order_qty_str.select '4'
    rescue
      select_order_qty_str = main_frame.select_list(id: 'n_order_qty_str')
      select_order_qty_str.select '4'
    end


    #### 回程
    select_getin_date = main_frame.select_list(id: 'getin_date2')
    select_getin_date.wait_until_present(10)

    # 正式跑記得改正式日期
    select_getin_date.select '2015/10/05【一】'
    # select_getin_date.select '2015/10/12【ㄧ】'

    input_train_no = main_frame.text_field(id: 'train_no2')
    input_train_no.wait_until_present(10)

    # 正式跑記得選要的班次
    # input_train_no.set '441'
    input_train_no.set '5443'

    # avoid freeze, holy shit.
    main_frame.label(for: 'order_qty_str2').click

    select_order_qty_str = main_frame.select_list(id: 'z_order_qty_str2')
    select_order_qty_str.wait_until_present(10)
    select_order_qty_str.select '4'

    button_submit = main_frame.button(type: 'submit')
    button_submit.click

    # 幹！captcha解不開
    # image_idRandomPic = main_frame.image(id: 'idRandomPic')
    # image_idRandomPic.wait_until_present(10)

    # md5 = Digest::MD5.hexdigest(image_idRandomPic.src)
    # img_path = "tmp/captcha-#{md5}.jpeg"

    # agent = Mechanize.new
    # file = agent.get(image_idRandomPic.src)
    # file.save(img_path)
    # browser.close
  end

  desc "captcha"
  task :captcha => :environment do
    captcha = RTesseract.read("tmp/morphology.jpeg", options: :digits) do |img|
      img = img.normalize
      img = img.contrast(2.5)
      img = img.quantize(16, Magick::GRAYColorspace)

      histogram = []
      Hash[img.color_histogram.sort_by{|k,v| v}].each do |color, count|
        puts "#{color} / #{count}"
        histogram.push({color: color, count: count})
      end

      histogram.each do |c|
        #if c[:count] < 20
        #  img = img.white_threshold(c[:color].red, c[:color].green, c[:color].blue, c[:color].opacity)
        #end
      end

      img.write('tmp/output.jpeg')
      img
    end

    puts captcha.to_s
  end

end

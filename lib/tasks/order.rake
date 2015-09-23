namespace :order do

  desc "default"
  task :default => :environment do
    Robot.run
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

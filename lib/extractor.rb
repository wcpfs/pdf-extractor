require 'docsplit'
require 'fileutils'
require 'pdfinfo'

class Extractor
  attr_reader :metadata
  def initialize
    @metadata = {}
  end

  def extract_assets(pdf_file, base_dir)
    info = Pdfinfo.new(pdf_file)
    if (info.title)
      name = File.basename(info.title, '.pdf')
      output_dir = "#{base_dir}/#{name}"
      if Dir.exist? output_dir
        STDERR.puts "Skipping #{output_dir}"
      else
        STDERR.puts "Unpacking #{pdf_file} to #{output_dir}"
        FileUtils.mkdir_p(output_dir)
        extract_chronicle(pdf_file, output_dir, info.page_count)
        extract_images(pdf_file, output_dir)
        @metadata[name] = {
          title: info.title,
          filename: File.basename(pdf_file)
        }
      end
      return output_dir
    end
    STDERR.puts "No title info for #{pdf_file}"
  end

  private

  def extract_chronicle(filename, output_dir, length)
    name = File.basename(filename, '.pdf')
    Docsplit.extract_images(filename, size: '628x816', format: :png, pages: [length], output: output_dir)
    FileUtils.move("#{output_dir}/#{name}_#{length}.png", "#{output_dir}/chronicle.png")
  end

  def extract_images(filename, output_dir)
    name = File.basename(filename, '.pdf')
    Kernel.system('pdfimages', '-j', filename, "#{output_dir}/img")
    Kernel.system('convert', "#{output_dir}/*.ppm", ".jpg")
    Dir.glob("#{output_dir}/*.ppm").each { |f| File.delete(f) }
    Dir.glob("#{output_dir}/*.jpg").each do |f| 
      color_count = `identify -format %k #{f}`.to_i
      if color_count < 10000
        File.delete(f)
      end
    end
  end
end

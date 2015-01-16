require 'docsplit'
require 'fileutils'
require 'pdfinfo'
require 'statblocks'
require 'json'

class Extractor
  attr_reader :metadata
  def initialize(pdf_file, base_dir)
    @info = Pdfinfo.new(pdf_file)
    @pdf_file = pdf_file
    @base_dir = base_dir
    @metadata = {}
  end

  def write_images
    output_dir = asset_dir('images')
    FileUtils.mkdir_p(output_dir)
    Kernel.system('pdfimages', '-j', @pdf_file, "#{output_dir}/img")
    Kernel.system('convert', "#{output_dir}/*.ppm", ".jpg")
    Dir.glob("#{output_dir}/*.ppm").each { |f| File.delete(f) }
    Dir.glob("#{output_dir}/*.jpg").each do |f| 
      color_count = `identify -format %k #{f}`.to_i
      if color_count < 10000
        File.delete(f)
      end
    end
  end

  def write_chronicle
    name = File.basename(@pdf_file, '.pdf')
    Docsplit.extract_images(@pdf_file, size: '628x816', format: :png, pages: [@info.page_count], output: asset_dir)
    FileUtils.move("#{output_dir}/#{name}_#{length}.png", "#{output_dir}/chronicle.png")
  end

  def write_metadata
    {
      id: scenario_id,
      title: scenario_id, #legacy
      filename: File.basename(@pdf_file)
    }
  end

  def write_statblocks
    statblocks = StatBlocks.find_statblocks(pdf_text)
    File.write(asset_dir('statblocks.json'), statblocks.to_json)
  end

  private

  def pdf_text
    raw_text = `pdftotext -nopgbrk -raw #{@pdf_file} -`.force_encoding("ASCII-8BIT")
    raw_text.encode('UTF-8', :invalid => :replace, :undef => :replace)
  end

  def asset_dir(path='')
    "#{@base_dir}/#{scenario_id}/#{path}"
  end

  def scenario_id
    File.basename(@info.title, '.pdf')
  end
end

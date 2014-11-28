require 'json'
class Indexer

  def build_index(asset_dir)
    puts Dir.glob("#{asset_dir}/*.jpg")
  end
end

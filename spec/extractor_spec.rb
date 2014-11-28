require 'extractor'

describe Extractor do
  let (:extractor) { Extractor.new }
  let (:f) { double File }
  let (:data) { StringIO.new 'file data' }

  before( :each ) do
    allow(FileUtils).to receive('mkdir_p')
    allow(Docsplit).to receive(:extract_images)
    allow(Docsplit).to receive(:extract_length) { 10 }
    allow(File).to receive(:delete)
    allow(File).to receive(:mkdir_p)
    allow(Kernel).to receive(:system)
    allow(Dir).to receive(:glob) { [] }
    allow(f).to receive(:write)
  end

  it "extracts the chronicle sheet" do
    expect(Docsplit).to receive(:extract_images).with('testdata/sample.pdf', {
      size: '628x816',
      format: :png,
      pages: [10],
      output: 'out/PZOPSSINTRO1E'
    })
    expect(FileUtils).to receive(:move).with('out/PZOPSSINTRO1E/scenario_10.png', 'out/PZOPSSINTRO1E/chronicle.png')
    extractor.extract_assets('testdata/sample.pdf', 'out') 
  end

  it "extracts the PDF images" 

  it "Converts .PPM files to JPG" 
end

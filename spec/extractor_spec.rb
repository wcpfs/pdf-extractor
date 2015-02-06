require 'extractor'

describe Extractor do
  let (:extractor) { Extractor.new('testdata/sample.pdf', 'tmp') }
  let (:statblocks) { [double(StatBlocks)] }

  it "can extract the statblocks" do
    file = double 'file'
    allow(statblocks.first).to receive(:print) { "printed" }
    expect(extractor).to receive(:pdf_text).and_return 'text'
    expect(StatBlocks).to receive(:find_statblocks).with('text').and_return(statblocks)
    expect(file).to receive(:write).with('printed')
    expect(File).to receive(:open).with('tmp/sample/statblocks.txt', "w").and_yield file
    extractor.write_statblocks
  end

  it "extracts scenario metadata" do
    expect(extractor.metadata).to eq({
      :id => "PZOPSSINTRO1E",
      :name => "First Steps, Part I:",
      :description => "A Pathfinder Society Scenario for Tier 1",
      :author => "First Steps, Part I:", # This works in season 6 and later
      :filename => "sample.pdf"
    })
  end
end

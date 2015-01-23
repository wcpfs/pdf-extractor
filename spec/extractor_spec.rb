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
end

require 'extractor'

describe Extractor do
  let (:extractor) { Extractor.new('testdata/sample.pdf', 'tmp') }

  it "can extract the statblocks" do
    statblocks = [{
      "header" => 'Ledford CR 1/2'
    }]
    expect(extractor).to receive(:pdf_text).and_return 'text'
    expect(StatBlocks).to receive(:find_statblocks).with('text').and_return(statblocks)
    expect(File).to receive(:write).with('tmp/sample/statblocks.json', statblocks.to_json)
    extractor.write_statblocks
  end
end

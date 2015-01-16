require 'statblocks'

describe StatBlocks do
  before( :all ) do
    @text = File.read('testdata/sample.txt')
    @stat_blocks = StatBlocks.find_statblocks(@text)
  end

  it "extracts normal stat blocks" do
    headers = @stat_blocks.map { |s| s["header"] }
    expect(headers).to eq([
      "Auntie Gilga BaltwinCR 1",
      "Deandre DulayCR 1/2",
      "Halli FostaCR 1/2",
      "Larkin WaeverCR 1/2",
      "LedfordCR 1/2"
    ])
  end

  describe "when parsing a statblock" do
    let(:ledford) { @stat_blocks.last }

    it "includes the header" do
      expect(ledford["header"]).to eq("LedfordCR 1/2")
    end

    it "includes single line stats" do
      expect(ledford["init"]).to eq("Init +2; Senses Perception +7")
    end

    it "extracts the gender, race, and classes" do
      expect(ledford["male"]).to eq("Male halfling barbarian 1")
    end

    it "includes multiline stats" do
      expect(ledford["morale"]).to eq("Morale While raging, Ledford fights to the death. If fatigued at the end of his 6 rounds of rage and reduced to 4 or fewer hit points, Ledford offers to call the fight a draw. Disgusted with his performance, Deandre may strike the failed barbarian.")
    end

    it "Includes full combat tactics" do
      expect(ledford["tactics"]).to eq("Tactics Before Combat Eager to brawl, only Deandre's intimidation keeps Ledford from rushing in before her signal. During Combat On his first turn, Ledford begins his rage ability, moves to the first PC he can reach, and attacks using power attack. He maintains his rage for the following 6 rounds, but stops using Power Attack if his first two attacks miss a particular PC. If given a choice of targets, Ledford always chooses the biggest, strongest PC. Gleeful at finally being paid to fight people, Ledford shouts out taunts with each blow, followed with a short laugh. He clearly enjoys combat.")
    end

    it "includes all available stats" do
      expect(ledford.keys).to eq(["header", "male", "ce", "init", "defense", "ac", "hp", "fort", "offense", "speed", "melee", "tactics", "morale", "base", "statistics", "str", "feats", "skills", "languages", "sq"])
    end

    xit "multi word stats are included" do
      # Multi-word stats don't work, like 'base statistics' or 'base atk'
    end
  end

  it "normalizes the text" do
    lines = StatBlocks.normalize(@text)
    words = lines.flatten
    expect(words).to_not include "408428"
    expect(words).to_not include "paizo.com, lyle hayhurst <sozinsky@gmail.com>, Aug 6, 2011"
  end
end

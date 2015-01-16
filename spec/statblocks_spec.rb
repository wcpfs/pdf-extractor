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
  end

  it "normalizes the text" do
    lines = StatBlocks.normalize(@text)
    words = lines.flatten
    expect(words).to_not include "408428"
    expect(words).to_not include "paizo.com, lyle hayhurst <sozinsky@gmail.com>, Aug 6, 2011"
  end

#LedfordCR 1/2
#Male halfling barbarian 1
#CE Small humanoid (halfling)
#Init +2; Senses Perception +7
#Defense
#AC 15, touch 11, flat-footed 13 (+4 armor, +2 Dex, ­2 rage,
#+1 size)
#hp 17 (1d12+5)
#Fort +7, Ref +3, Will +4; +2 vs. fear
#Offense
#Speed 30 ft.
#Melee greataxe +5 (1d10+4/×3)
#Special Attacks rage (6 rounds/day)
#Tactics
#Before Combat Eager to brawl, only Deandre's intimidation
#keeps Ledford from rushing in before her signal.
#During Combat On his first turn, Ledford begins his rage
#ability, moves to the first PC he can reach, and attacks
#using power attack. He maintains his rage for the
#following 6 rounds, but stops using Power Attack if his
#first two attacks miss a particular PC. If given a choice of
#targets, Ledford always chooses the biggest, strongest
#PC. Gleeful at finally being paid to fight people, Ledford
#shouts out taunts with each blow, followed with a short
#laugh. He clearly enjoys combat.
#Morale While raging, Ledford fights to the death. If fatigued
#at the end of his 6 rounds of rage and reduced to 4 or
#fewer hit points, Ledford offers to call the fight a draw.
#Disgusted with his performance, Deandre may strike the
#failed barbarian.
#Base Statistics When not raging, Ledford's statistics are
#AC 17, touch 13, flat-footed 15; hp 15; Melee greataxe +3
#(1d10+1/×3); Str 13, Con 14; CMB +1, CMD 13; Climb +6
#Statistics
#Str 17, Dex 15, Con 18, Int 10, Wis 12, Cha 10
#Base Atk +1; CMB +3; CMD 13
#Feats Power Attack
#Skills Acrobatics +7, Climb +8, Intimidate +4, Perception +7
#Languages Common, Halfling
#SQ fast movement
#Combat Gear potion of cure light wounds; Other Gear
#masterwork chain shirt, greataxe, block of wax in a metal
#tin, fine comb with a long handle, bottle of whiskey and four
#silver cups, 25 gp
#Rewards: If the PCs survive the ambush, give each
#player 129 gp.
#Conclusion
  
end

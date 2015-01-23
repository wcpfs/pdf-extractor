require 'stringio'

class StatBlock
  attr_reader :header
  def initialize(header)
    @header = header
    @stats = []
  end

  def add(name, stat)
    @stats << {:name => name, :content => stat}
  end

  def append(name, new_content)
    stat = @stats.find {|s| s[:name] == name }
    if stat
      stat[:content] += " " + new_content
    end
  end

  def print
    s = StringIO.new
    s.puts @header
    @stats.each do |stat|
      s.puts stat[:content]
    end
    s.puts "\n"
    s.string
  end

  def stats
    @stats.map { |s| s[:name] }
  end

  def find(name)
    stat = @stats.find {|s| s[:name] == name }
    stat[:content] if stat
  end
end

class StatBlocks
  def self.find_statblocks(pdf_text)
    lines = self.normalize(pdf_text)
    statblocks = []
    lines.each_with_index do |line, i|
      if line.match(/^[A-Za-z0-9()\s]+\s*CR\s*\d?\/?\d+/)
        chunk = lines[i, 60]
        if self.statblock? chunk
          statblocks << parse_statblock(chunk)
        end
      end
    end
    statblocks
  end

  def self.normalize(pdf_text)
    lines = pdf_text.each_line.to_a.map do |line|
      line.chomp
    end
    lines.reject do |line|
      not line.match (/[a-z]+/i) or
      line.match(/^paizo\.com,/)
    end
  end

  private

  KNOWN_STATBLOCK_WORDS = ['male', 'female', 'tactics', 'lg', 'ln', 'le', 'ng', 'n', 'ne', 'cg', 'cn', 'ce', 'init', 'defense', 'ac', 'hp', 'fort', 'offense', 'speed', 'melee', 'special attacks', 'tactics', 'morale', 'base', 'statistics', 'str', 'base atk', 'feats', 'skills', 'languages', 'sq', 'combat gear', 'other gear']

  def self.statblock?(chunk)
    leaders = chunk.map do |l| 
      if m = l.match(/\w+/)
        m[0].downcase
      end
    end
    features = leaders & KNOWN_STATBLOCK_WORDS
    return (features.length.to_f / KNOWN_STATBLOCK_WORDS.length) > 0.25
  end

  def self.parse_statblock(chunk)
    statblock = StatBlock.new(chunk[0])
    current_stat = nil
    chunk[1..-1].each do |line|
      keyword, stats = parse_line(line)
      if keyword 
        stats ||= ""
        if KNOWN_STATBLOCK_WORDS.include? keyword
          statblock.add(keyword, stats)
          current_stat = keyword
        else
          if current_stat
            statblock.append(current_stat, stats)
          end
        end
      end
    end
    statblock
  end

  def self.parse_line(line)
    m = line.match(/^(\w+).*$/)
    [m[1].downcase, m[0] || ""] if m
  end

end

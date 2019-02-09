require "http"

class Emoji::Regex::DataLoader
  property :data_lines, :sequences_lines, :zwj_sequences_lines, :variation_sequences_lines

  @data_lines : Array(String)
  @sequences_lines : Array(String)
  @zwj_sequences_lines : Array(String)
  @variation_sequences_lines : Array(String)

  BASE_URL = "http://unicode.org/Public/emoji/12.0/"
  # <codepoint(s)> ; <property> # <comments>
  DATA_REGEX = /(?<codepoint>[0-9A-F.]+)\s+;\s+(?<property>\S+)\s*?\#[^\S]*(?<comments>.*)/
  # code_point(s) ; type_field ; description # comments
  SEQUENCES_REGEX = /^(?<codepoints>[0-9A-F ]+?)\s*?;\s+?(?<type_field>.+?)\s*?;(\s+)?(?<description>.+?)\s*?#\s*?(?<comments>.*)/

  def initialize
    @data_lines = read_lines_from_file("emoji-data.txt")
    @sequences_lines = read_lines_from_file("emoji-sequences.txt")
    @zwj_sequences_lines = read_lines_from_file("emoji-zwj-sequences.txt")
    @variation_sequences_lines = read_lines_from_file("emoji-variation-sequences.txt")
  end

  def data_codepoints_regex
    data_codepoints = [] of Array(String)
    data_lines.each do |line|
      if m = DATA_REGEX.match(line)
        if ["Emoji_Presentation"].includes?(m["property"])
          if range = /(.+)\.\.(.*)/.match(m["codepoint"])
            data_codepoints << [range[1], range[2]]
          else
            data_codepoints << [m["codepoint"]]
          end
        end
      end
    end

    data_codepoints_regex = data_codepoints.map { |name|
      name.map { |codepoint| escape_hexadecimal(codepoint) }.join("-")
    }.join

    "[#{data_codepoints_regex}]"
  end

  def emoji_zwj_sequences_regex
    # zero-width joiner
    zwj = "200D"

    emoji_sequences = {} of String => Array(Array(String))

    zwj_sequences_lines.each do |line|
      if m = SEQUENCES_REGEX.match(line)
        codepoints = m["codepoints"]
        head, tail = codepoints.split(zwj, 2).map(&.strip)

        if emoji_sequences.has_key?(head)
          emoji_sequences[head] << tail.split
        else
          emoji_sequences[head] = [tail.split]
        end
      end
    end

    emoji_zwj_sequences_array = [] of String

    emoji_sequences.each do |k, v|
      io = String::Builder.new
      io << "(?:"
      io << k.split.push(zwj).map { |codepoint| escape_hexadecimal(codepoint) }.join
      io << ")"

      io << "(?:"
      array = [] of String
      v.sort_by(&.size).reverse.each do |vv|
        array << vv.map { |codepoint| escape_hexadecimal(codepoint) }.join
      end
      io << array.join("|")
      io << ")"

      emoji_zwj_sequences_array << io.to_s
    end

    emoji_zwj_sequences_array.join("|")
  end

  def emoji_variation_sequences_regex
    variation_selector = "\\\\\\\\x{FE0F}"

    emoji_variations = [] of String
    text_variations = [] of String

    variation_sequences_lines.each do |line|
      if m = SEQUENCES_REGEX.match(line)
        if m["type_field"] == "emoji style"
          codepoints = m["codepoints"].split

          if ascii?(codepoints[0])
            text_variations << codepoints[0]
          else
            emoji_variations << codepoints[0]
          end
        end
      end
    end

    emoji_regex = emoji_variations.map { |codepoint| escape_hexadecimal(codepoint) }.join
    text_regex = text_variations.map { |codepoint| escape_hexadecimal(codepoint) }.join

    "(?:[#{emoji_regex}]#{variation_selector}?)|(?:[#{text_regex}]#{variation_selector})"
  end

  def emoji_keycap_sequences_regex
    enclosing_keycap = ["FE0F", "20E3"]
    enclosing_keycap_regex = enclosing_keycap.map { |codepoint| escape_hexadecimal(codepoint) }.join

    keycaps = [] of String

    sequences_lines.each do |line|
      if m = SEQUENCES_REGEX.match(line)
        if ["Emoji_Keycap_Sequence"].includes?(m["type_field"])
          keycaps << m["codepoints"].split(2).first
        end
      end
    end

    keycaps_regex = keycaps.map { |codepoint| escape_hexadecimal(codepoint) }.join

    "(?:[#{keycaps_regex}]#{enclosing_keycap_regex})"
  end

  # http://www.unicode.org/reports/tr51/#def_emoji_tag_sequence
  def emoji_tag_sequence_regex
    tag_base = ["1F3F4", "E0067", "E0062"]
    tag_term = ["E007F"]
    tag_specs = [] of Array(String)

    sequences_lines.each do |line|
      if m = SEQUENCES_REGEX.match(line)
        if ["Emoji_Tag_Sequence"].includes?(m["type_field"])
          codepoints = m["codepoints"].split
          tag_spec = codepoints[3..-2]
          tag_specs << tag_spec
        end
      end
    end

    tag_base_regex = tag_base.map { |codepoint| escape_hexadecimal(codepoint) }.join
    tag_term_regex = tag_term.map { |codepoint| escape_hexadecimal(codepoint) }.join

    tag_spec_array = [] of String
    tag_specs.each do |tag|
      tag_spec_array << tag.map { |codepoint| escape_hexadecimal(codepoint) }.join
    end

    tag_spec_regex = tag_spec_array.join("|")

    "(?:#{tag_base_regex}(?:#{tag_spec_regex})#{tag_term_regex})"
  end

  def emoji_sequences_regex
    emoji_sequences = {} of String => Array(String)

    sequences_lines.each do |line|
      if m = SEQUENCES_REGEX.match(line)
        if ["Emoji_Flag_Sequence", "Emoji_Modifier_Sequence"].includes?(m["type_field"])
          codepoints = m["codepoints"].split

          if emoji_sequences.has_key?(codepoints[0])
            emoji_sequences[codepoints[0]] << codepoints[1]
          else
            emoji_sequences[codepoints[0]] = [codepoints[1]]
          end
        end
      end
    end

    emoji_sequences_array = [] of String

    emoji_sequences.each do |pair|
      io = String::Builder.new
      io << escape_hexadecimal(pair[0])
      io << "["
      pair[1].each do |codepoint|
        io << escape_hexadecimal(codepoint)
      end
      io << "]"

      emoji_sequences_array << io.to_s
    end

    emoji_sequences_regex = emoji_sequences_array.join("|")

    "(?:#{emoji_sequences_regex})"
  end

  private def read_lines_from_file(filename) : Array(String)
    response = HTTP::Client.get(BASE_URL + filename)
    response.body.lines
  end

  def escape_hexadecimal(codepoint)
    if codepoint == "FE0F"
      "\\\\\\\\x{#{codepoint}}?"
    else
      "\\\\\\\\x{#{codepoint}}"
    end
  end

  def ascii?(codepoint)
    codepoint.to_i(16).chr.ascii?
  end
end

data_loader = Emoji::Regex::DataLoader.new

emoji_zwj_sequences_regex = data_loader.emoji_zwj_sequences_regex
emoji_sequences_regex = data_loader.emoji_sequences_regex
emoji_tag_sequence_regex = data_loader.emoji_tag_sequence_regex
emoji_keycap_sequences_regex = data_loader.emoji_keycap_sequences_regex
emoji_variation_sequences_regex = data_loader.emoji_variation_sequences_regex
data_codepoints_regex = data_loader.data_codepoints_regex

print "#{emoji_zwj_sequences_regex}|#{emoji_sequences_regex}|#{emoji_tag_sequence_regex}|#{emoji_keycap_sequences_regex}|#{emoji_variation_sequences_regex}|#{data_codepoints_regex}"

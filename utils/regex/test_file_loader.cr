require "http"

base_url = "https://unicode.org"
filename = "/Public/emoji/13.1/emoji-test.txt"

response = HTTP::Client.get(base_url + filename)

lines = response.body.lines

test_line_regex = /(?<codepoint>[0-9A-F ]+?)\s+;\s+(?<status>\S+)\s*?\#[^\S]*(?<emoji>.*?)\s(?<emoji_name>.+)/

result = [] of Array(String)

lines.each do |line|
  if m = test_line_regex.match(line)
    result << [m["codepoint"], m["emoji"], m["emoji_name"], m["status"]]
  end
end

puts result

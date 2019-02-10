macro generate_source(data)
<<-EOT
# THIS FILE IS AUTOMATICALLY GENERATED, DO NOT EDIT !

require "../spec_helper"
{% for name in data %}
it "`{{name[0].id}}` ({{name[3].id}}) should match `{{name[2].id}}` ({{name[1].id}})" do
  if m = "{{name[1].id}}".match(Emoji::EMOJI_REGEX)
    m[0].should eq("{{name[1].id}}")
  else
    fail("`{{name[0].id}}` doesn't match `{{name[2].id}}` ({{name[1].id}})")
  end
end
{% end %}
EOT
end

macro create_source_file
  source = generate_source({{run("./test_file_loader.cr").id}})
  File.write("./spec/emoji/regex_spec.cr", source)
end

create_source_file

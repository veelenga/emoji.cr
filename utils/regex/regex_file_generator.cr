macro generate_source(data)
<<-EOT
# THIS FILE IS AUTOMATICALLY GENERATED, DO NOT EDIT !

module Emoji
  GENERATED_EMOJI_REGEX = /{{data.id}}/
end

EOT
end

macro create_source_file
  source = generate_source("{{run("./data_loader.cr")}}")
  File.write("./src/emoji/regex.cr", source)
end

create_source_file

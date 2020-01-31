# Generate source and spec files for Unicode Emoji, Version 13.0

<http://www.unicode.org/reports/tr51/#Emoji_Properties_and_Data_Files>

<https://www.unicode.org/Public/emoji/13.0/ReadMe.txt>

Generate [src/emoji/regex.cr](https://github.com/veelenga/emoji.cr/blob/master/src/emoji/regex.cr):

```console
cd repository_root
crystal utils/regex/regex_file_generator.cr
```

Generate [spec/emoji/regex_spec.cr](https://github.com/veelenga/emoji.cr/blob/master/spec/emoji/regex_spec.cr):

```console
cd repository_root
crystal utils/regex/spec_file_generator.cr
```

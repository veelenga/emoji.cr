# Generate source and spec files for Emoji regex

http://www.unicode.org/reports/tr51/#Emoji_Properties_and_Data_Files

Generate [src/emoji/regex.cr](https://github.com/veelenga/emoji.cr/blob/master/src/emoji/regex.cr):

```console
cd repository_root
crystal utils/regex/regex_file_generator.cr
```

Generate [spec/emoji/regex_spec.cr](https://github.com/veelenga/emoji.cr/blob/master/spec/emoji/regex_spec.cr):

```console
cd repository_root
crystal utils/regex/regex_file_generator.cr
```

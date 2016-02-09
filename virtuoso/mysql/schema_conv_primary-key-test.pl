#!/usr/bin/env perl

# open(my $fh, "+>", \$tmp)

while (<>) {
  # also double quotes around column names in PRIMARY KEY statement:
  if (/PRIMARY KEY/) {
    s/([\(,])(.*?)([,\)])/\1\"\2\"\3/gi;
  }
  print;
}

# Multi-line stuff (must be done outside <> loop):
# remove comma on final line before ); (should also do the primary key one...) Note: the question mark in .*? makes .* ungreedy. The /s and /m modifiers make . and $ deal with newlines too (see http://docstore.mik.ua/orelly/perl/cookbook/ch06_07.htm).
# s/,(.*?)\);$/\1\);/smg;
# s/,\n\);/\n\);/m;
# print;

# The above multi-line stuff doesn't work. Use Python to do multiline editing!
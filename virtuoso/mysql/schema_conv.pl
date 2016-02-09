#!/usr/bin/env perl

# open(my $fh, "+>", \$tmp)

while (<>) {
  # remove ENGINE=... blabla after TABLE creation
  s/\) ENGINE\=.*/\)\;/;

  # replace backticks around column names by double quotes (not single quotes!)
  s/^  \`(.*)\`/  \"\1\"/;
  # also double quotes around column names in PRIMARY KEY statement:
  if (/PRIMARY KEY/) {
    s/`(.*?)`/\"\1\"/gi;
  }
  # backticks (or normal quotes in column/table names) not used
  s/\`//g;

  # remove COMMENTs at the end of lines
  s/ COMMENT.*/,/;

  # prepend CollectionName.username. to table names
  s/CREATE TABLE /CREATE TABLE Hadrianus.hadrianus./;

  # no unsigned integers
  s/int\([0-9]*\) unsigned/integer/;
  # no tinyint
  s/tinyint\([0-9]*\)/smallint/;
  # change integer type of certain size to generic integer type
  s/int\([0-9]*\)/integer/;
  # AUTO_INCREMENT is not used (including DEFAULT!); use IDENTITY
  s/integer.*AUTO_INCREMENT/integer IDENTITY/;

  # change varchar type of certain size to generic varchar type
  s/varchar\([0-9]*\)/varchar/;
  # change char type of certain size to generic varchar type
  s/char\([0-9]*\)/varchar/;

  # language -> lang no longer necessary, because of double quotes around column names:
  # s/language/lang/g;  # language is an SQL reserved word!

  # remove comma on final line after primary key, if it's there
  s/\)\,$/\)/;

  # remove lines starting with --, /* or DROP, and also KEY (KEY means 'index it', it's purely optimization)
  s/^(--|\/\*|DROP|  KEY|  UNIQUE KEY).*//;

  # remove empty or whitespace lines
  s/^\s$//g;

  print;
}

# Multi-line stuff (must be done outside <> loop):
# remove comma on final line before ); (should also do the primary key one...) Note: the question mark in .*? makes .* ungreedy. The /s and /m modifiers make . and $ deal with newlines too (see http://docstore.mik.ua/orelly/perl/cookbook/ch06_07.htm).
# s/,(.*?)\);$/\1\);/smg;
# s/,\n\);/\n\);/m;
# print;

# The above multi-line stuff doesn't work. Use Python to do multiline editing!
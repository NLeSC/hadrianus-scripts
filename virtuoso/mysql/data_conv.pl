#!/usr/bin/env perl
while (<>) {
  s/\`//g;  # backticks (or normal quotes in column/table names) not used
  s/INSERT INTO ([^ ]*) VALUES/INSERT INTO Hadrianus\.hadrianus\.\1 VALUES/;  # prepend CollectionName.username. to table names
  s/^\s$//g;  # remove empty or whitespace lines
  print unless /^(--|\/\*|LOCK|UNLOCK).*/;  # remove lines starting with --, /* or (UN)LOCK
}
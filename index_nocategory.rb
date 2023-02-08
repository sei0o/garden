require 'yaml'
require 'date'

root = ARGV[0] ? ARGV[0].chomp : "/home/sei0o/Sync/obsidian/"
index = Dir.open(root)
  .each_child
  .filter { |x| x.end_with?(".md") && x != "_index.md" && x != "_index_header.md" }
  .to_a
  .map { |x|
    "- [[" + x[0..-4] + "]]" }
  .join("\n")

header = File.read(root + "_index_header.md")

puts(header + "\n" + index)

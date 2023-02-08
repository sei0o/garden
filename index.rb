require 'yaml'
require 'date'

root = ARGV[0] ? ARGV[0].chomp : "/home/sei0o/Sync/obsidian/"
index = Dir.open(root)
  .each_child
  .group_by { |x|
    fullpath = root + x
    if x == "_index.md" || x == "_index_header.md"
      :noindex
    elsif fullpath.end_with?(".md")
      frontmatter = YAML::load_file fullpath, permitted_classes: [Symbol, Date]
      if frontmatter != nil && frontmatter["category"]
        frontmatter["category"]
      else
        "uncategorized"
      end
    else
      :noindex
    end
  }
  .to_a
  .filter { |(c, f)| c != :noindex }
  .sort_by{ |(c1, f1), (c2, f2)|
    if c1 == "uncategorized" then 1
    elsif c2 == "uncategorized" then -1
    else (c1 <=> c2) end
  }
  .map { |category, filenames|
    "\n## #{category}\n" +
    filenames.map {|x| "- [[" + x[0..-4] + "]]" }.join("\n")
  }
  .join

header = File.read(root + "_index_header.md")

puts(header + index)

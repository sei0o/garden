dirname = ARGV[0] || '.'
notes = Dir.children dirname

notes.each do |path|
  abspath = dirname + "/" + path
  next if File.directory? abspath
  next unless abspath.end_with? ".md"
  
  lines = IO.readlines abspath
  in_frontmatter = false
  pos = 0
  lines.map(&:chomp).each_with_index do |line, i|
    if in_frontmatter
      if line == "---"
        us = (Time.now.to_f * 1000000).floor
        lines.insert(i, "slug: \"#{us}\"\n")
        break
      end
      
      k, v = line.split ": "
      break if k == "slug"
    else
      if line == "---"
        in_frontmatter = true
      end
    end
  end

  IO.write abspath, lines.join
end

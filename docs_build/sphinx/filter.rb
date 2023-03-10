require 'fileutils'

index='./_build/html/genindex.html'
#system("sed -i .bak 's/(C\+\+ class)/(MATLAB class)/g' #{index}");
#system("sed -i .bak 's/(C\+\+ function)/(MATLAB function)/g' #{index}");
system("sed -i .bak 's/(C\+\+ class)/(class)/g' #{index}");
system("sed -i .bak 's/(C\+\+ function)/(function)/g' #{index}");
FileUtils.rm "#{index}.bak"

Dir.glob("./_build/html/api-matlab/*.html").each do |f|
  puts "filter: #{f}"
  out = "";
  File.open(f,"r") do |file|
    file.each_line do |line|
      line.gsub!(/<span class="pre">::<\/span>,*/,'.');
      line.gsub!(/<span class="pre">in<\/span><\/span><span class="w"> <\/span><span class="n sig-param"><span class="pre">(this|ignoredArg)<\/span><\/span>, */,'');
      line.gsub!(/<span class="n"><span class="pre">in<\/span><\/span><span class="w"> */,'');
      line.gsub!(/<em><span class="pre">(this|ignoredArg)<\/span><\/em>,? */,'');
      line.gsub!(/<span class="pre">(this|ignoredArg)\)<\/span>/,'<span class="sig-paren">)</span>');
      line.gsub!(/<\/span><span class="n sig-param"><span class="pre">(this|ignoredArg)<\/span><\/span>/,'');
      line.gsub!(
        /<span class="pre">(in<\/span> *)/,
        '<span class="sig-paren">()</span>'
      )
      line.gsub!(
        /<span class="pre">\(in<\/span> *<span class="pre">(this|ignoredArg)\)<\/span>/,
        '<span class="sig-paren">()</span>'
      )
      out += line;
    end
  end
  File.open(f,"w") do |file|
    file.write(out)
  end
end

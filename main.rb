require 'time'
require_relative 'styles'
require_relative 'cli_parse'
require_relative 'help_func'
require_relative 'scanner'






log_temp = merge_wordlists($wordlists)

if check_last_session()
  $resume = resume_last_session()
end

#fix trailing '/' issues
url = $url.end_with?('/') ? $url.chomp('/') : "#{$url}"
#puts "URL_BASE: #{url}"



def banner(resume = false)
  puts footer("Disclaimer: This tool is still under development so many features aren't added or stable yet", true, false)
  puts header("YADIRB v#{Version} - by Jonathan B. Owusu (ph4mished)", false, false)
  puts "START TIME: #{Time.now.strftime("%a %d-%b-%Y %H:%M:%S")}"
  if resume
    puts "URL: #{$resume[:url]}"
  else
    puts "URL: #{$url}"
  end
  if resume 
    puts "WORDLIST(S): #{$resume[:filename]}"
  else
    puts "WORDLIST(S): #{$wordlists.join(', ')}"
  end
  puts "THREADS: #{$options[:threads]}"
  puts "TIMEOUT: #{$options[:timeout]}"
  puts "DELAY: #{$options[:delay]} ms"
  print if_empty("RECURSION DEPTH: #{$options[:depth]}\n", $options[:depth])
  print if_empty("OUTPUT FILE: #{$options[:output]}\n", $options[:output])
  print if_empty("EXTENSIONS: #{$options[:extensions]&.join(', ') || ""}\n", $options[:extensions])
  print if_empty("OPTIONS: Not Recursive\n", $options[:recursive])
  print if_empty("OPTIONS: Quiet Mode\n", $options[:quiet])
  print if_empty("OPTIONS: Follow Redirect\n", $options[:redirect])
  print if_empty("OPTIONS  Not Stopping On Warning Messages\n", $options[:warn])
  if resume
    puts "GENERATED WORDS: #{count_lines(rewrite_resume_wordlists($resume[:filename], $resume[:word], $resume[:num_line]))}"
  else
    puts "GENERATED WORDS: #{count_lines(merge_wordlists($wordlists))}"
  end
  puts header("end of user defined options", true, false)
  puts "\n"
  if resume
    puts header("SCANNING URL: #{$resume[:url]}", false, false)
  else
    puts header("SCANNING URL: #{$url}", false, false)
  end
end


#resume question
if check_last_session && $resume[:options] != nil
  ARGV.clear
  #all that is needed is a "y"
  puts header("yadirb  #{Version} - yet another directory buster")
  puts "Would you like to resume last terminated process? [Y/N]"
  resp = gets.chomp!
  if resp.downcase == 'y'
    $options = $resume[:options]&.empty? ? $options :  $resume[:options]
    banner(true)
    log_temp = rewrite_resume_wordlists($resume[:filename], $resume[:word], $resume[:num_line])
    brute_dir($resume[:url], log_temp, $resume[:options])
    
  else
    banner()
    brute_dir($url, log_temp, $options)
  end
else
  banner()
  brute_dir($url, log_temp, $options)
end

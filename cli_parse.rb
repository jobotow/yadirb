require 'optparse'

Version = "0.1.0"
Github = "https://github.com/ph4mished/yadirb"



$options = {threads: 10, timeout: 10, delay: 10, recursive: true, depth: 2} #default for threads is 10
#[] is for empty array
#{} is for empty hash/dictionary/key-value store
  
  
  #allHelp.add(help.flag.apply("-R", "--interactive-recursion", "Interactive recursion (Asks for each directory)"))
  

OptionParser.new do |opts|
  opts.program_name = "yadirb"
  opts.separator header("yadirb  #{Version} - yet another directory buster")
  opts.separator ""
  opts.separator "yadirb is inspired by the legendary dirb"
  opts.separator ""
  opts.separator "Usage: yadirb <URL> [<WORDLIST_FILE(S)>] [OPTIONS]"
  opts.version = "v#{Version} by ph4mished (#{Github})"
  opts.separator ""
  opts.separator "ARGUMENTS:"
  opts.separator "    <URL>                            Target URL (eg. http://example.com)"
  opts.separator "    <WORDLIST_FILE(S)>               List of wordlist files (can be one or more)"
  opts.separator ""

  opts.separator "GENERAL OPTIONS:"
  opts.separator "    -h, --help                       Show this help message."
  opts.separator "    -v, --version                    Show version information."
  opts.separator ""
  opts.separator "COMMON OPTIONS:"

  #option with short and long flags
  opts.on("-t", "--threads NUM", Integer, "Number of worker threads.[default: 10 threads]")
  opts.on("-T", "--timeout SECONDS", Integer, "Request timeout in secondes. [default: 10 sec]")
  opts.on("-r", "--recursive","Stop recursive directory enumeration.") do
    $options[:recursive] = false
  end
  opts.on("-d", "--delay MS", Integer, "Delay between requests in milliseconds [default: 10 ms]")
  #opts.on("-R", "--resume","Resume last process")
  opts.on("-D", "--depth NUM", Integer, "Depth of recursion")
  opts.on("-s", "--status LIST", Array, "Show only these status codes (eg. 200,301,404).")
  opts.on("-L", "--redirects","Follow HTTP redirects")
    #$options[:redirects] = false
  #end
  opts.on("-H", "--header 'X: Y'", String, "Add custom header (can be used multiple times)")
  opts.on("-x", "--extensions LIST", Array, "Append extensions (eg. php,bak,html,js)")
  opts.on("-N", "--ignore LIST", Array, "Ignore responses with these HTTP codes.\n")
  opts.on("-o", "--output FILE", String, "Save results to file.")
  opts.on("-w", "--warn", "Don't stop on warning messages.")
  opts.on("-q", "--quiet", "Quiet mode. Suppress non-critical information (Don't show tested words).")
  opts.on("-V", "Show all NOT_FOUND PAGES\n")



  opts.separator ""
  opts.separator "EXAMPLES:"
  opts.separator "  #Basic scan"
  opts.separator "    yadirb http://target.com common.txt"
  opts.separator "    yadirb http://target.com common1.txt common2.txt common3.txt"
  opts.separator ""
  opts.separator "  #Basic scan with custom threads"
  opts.separator "    yadirb http://target.com common.txt -t 20 "
  opts.separator ""
  opts.separator "  #Scan with extensions and save results"
  opts.separator "    yadirb http://target.com common.txt -x 'php,txt,js' -o results.txt"
  opts.separator ""
  opts.separator "  #Filter by status codes and add headers"
  opts.separator "    yadirb http://target.com common.txt -s '200,301,404' -H 'X-API-key: secret' "
  opts.separator ""
  opts.separator "  #Recursive scan with authentication"
  opts.separator "    yadirb http://target.com common.txt --proxy http://localhost:8080 --json"
  opts.separator ""
  opts.separator ""
  opts.separator "NOTES:"
  opts.separator "  -Wordlists are combined and deduplicated."
  opts.separator "  -URL trailing slash is preserved."
  opts.separator "  -Use quotes for values containing spaces or special characters."
  opts.separator footer("Disclaimer: This tool is still under development so many features aren't added or stable yet", true, false)
  opts.separator footer("end of help information")
end.parse!(into: $options)

$url = ARGV[0]
wordlists = ARGV[1..-1]
$wordlists = wordlists.empty? ? ["wordlists/common.txt"] : wordlists 

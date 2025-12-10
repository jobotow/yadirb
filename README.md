# YADIRB - Yet Another Directory Buster
`Yadirb` is a directory bruteforcing tool inspired by `dirb`.

Although still under development, it works as a supposed tool **(multithreaded)**.

# Help Info Of Yadirb
```
$ruby main.rb --help
                 ============================================================
                          YADIRB  0.1.0 - YET ANOTHER DIRECTORY BUSTER
                 ============================================================

yadirb is inspired by the legendary dirb

Usage: yadirb <URL> [<WORDLIST_FILE(S)>] [OPTIONS]

ARGUMENTS:
    <URL>                            Target URL (eg. http://example.com)
    <WORDLIST_FILE(S)>               List of wordlist files (can be one or more)

GENERAL OPTIONS:
    -h, --help                       Show this help message.
    -v, --version                    Show version information.

COMMON OPTIONS:
    -t, --threads NUM                Number of worker threads.[default: 10 threads]
    -T, --timeout SECONDS            Request timeout in secondes. [default: 10 sec]
    -r, --recursive                  Stop recursive directory enumeration.
    -d, --delay MS                   Delay between requests in milliseconds [default: 10 ms]
    -D, --depth NUM                  Depth of recursion
    -s, --status LIST                Show only these status codes (eg. 200,301,404).
    -L, --redirects                  Follow HTTP redirects
    -H, --header 'X: Y'              Add custom header (can be used multiple times)
    -x, --extensions LIST            Append extensions (eg. php,bak,html,js)
    -N, --ignore LIST                Ignore responses with these HTTP codes.
    -o, --output FILE                Save results to file.
    -w, --warn                       Don't stop on warning messages.
    -q, --quiet                      Quiet mode. Suppress non-critical information (Don't show tested words).
    -V                               Show all NOT_FOUND PAGES

EXAMPLES:
  #Basic scan
    yadirb http://target.com common.txt
    yadirb http://target.com common1.txt common2.txt common3.txt

  #Basic scan with custom threads
    yadirb http://target.com common.txt -t 20 

  #Scan with extensions and save results
    yadirb http://target.com common.txt -x 'php,txt,js' -o results.txt

  #Filter by status codes and add headers
    yadirb http://target.com common.txt -s '200,301,404' -H 'X-API-key: secret' 

  #Recursive scan with authentication
    yadirb http://target.com common.txt --proxy http://localhost:8080 --json


NOTES:
  -Wordlists are combined and deduplicated.
  -URL trailing slash is preserved.
  -Use quotes for values containing spaces or special characters.
==============================================================================================
DISCLAIMER: THIS TOOL IS STILL UNDER DEVELOPMENT SO MANY FEATURES AREN'T ADDED OR STABLE YET
==============================================================================================
==============================================================================================
                                    END OF HELP INFORMATION
==============================================================================================
```

# Missing Features
**Yadirb is missing so many features as its still under development**

The listed missing features are those that are visible in the help info (Its to create awareness that not all flags have their functions implemented).
- Timeout
- Recursive
- Delay
- Depth
- Status
- Redirects
- Header
- Extensions
- Ignore
- Warn
- Quiet
- Not found pages

**Thread, wordlists and url args are the only ones that work(at the moment).**

# Footer
Even with those missing features, yadirb isn't lacking in speed, its four times faster (and more) than its predecessor, dirb.

Yadirb also doesn't have issue resuming after a terminated process. It asks the user if they want to resume or start a new process.


# Yadirb In Action
``` 
$ruby main.rb https://target.com -t 100
==============================================================================================
DISCLAIMER: THIS TOOL IS STILL UNDER DEVELOPMENT SO MANY FEATURES AREN'T ADDED OR STABLE YET
==============================================================================================
================================================================
YADIRB v0.1.0 - by Jonathan B. Owusu (ph4mished)
================================================================
START TIME: Wed 10-Dec-2025 01:48:09
URL: https://target.com
WORDLIST(S): wordlists/common.txt
THREADS: 100
TIMEOUT: 10
DELAY: 10 ms
RECURSION DEPTH: 2
OPTIONS: Not Recursive
GENERATED WORDS: 4613
===========================================
END OF USER DEFINED OPTIONS
===========================================

================================================
SCANNING URL: https://target.com
================================================
Queue: 3649 left | Done: 964/4613
```

# Yadirb Resume
```
$ruby main.rb https://example.com -t 45 -d 15 -T 12
                 ============================================================
                          YADIRB  0.1.0 - YET ANOTHER DIRECTORY BUSTER
                 ============================================================
Would you like to resume last terminated process? [Y/N]
y
==============================================================================================
DISCLAIMER: THIS TOOL IS STILL UNDER DEVELOPMENT SO MANY FEATURES AREN'T ADDED OR STABLE YET
==============================================================================================
================================================================
YADIRB v0.1.0 - by Jonathan B. Owusu (ph4mished)
================================================================
START TIME: Wed 10-Dec-2025 01:52:23
URL: https://target.com
WORDLIST(S): yadirb_log.txt
THREADS: 100
TIMEOUT: 10
DELAY: 10 ms
RECURSION DEPTH: 2
OPTIONS: Not Recursive
GENERATED WORDS: 3649
===========================================
END OF USER DEFINED OPTIONS
===========================================

================================================
SCANNING URL: https://target.com
================================================
Queue: 2485 left | Done: 200/2685
```
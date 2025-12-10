require 'net/http'
require 'uri'
require_relative 'cli_parse'
require_relative 'help_func'



def erase_line()
  print "\033[2K\r"
end



def get_404_baseline(target_url, random_path = "/nonexistent-#{rand(10000)}")
  #some non existent sites show 200 and also same body size, playing tricks on the directory bruteforcer
  uri = URI.parse(target_url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == 'https' ? true : false
  response = http.get(random_path)
  {
    length: response.body.length,
    title: response.body[/<title>(.*?)<\/title>/i, 1],
    body: response.body[0..500] #first 500 chars
  }
end



def brute_dir(target_url, wordlist, opt)
  uri = URI.parse(target_url)
  host = uri.host
  port = uri.port
  scheme = uri.scheme

  base_path = uri.path#.chomp('/') + '/'
  #base_path = uri.path.empty? ? '/' : uri.path.chomp('/') + '/'
  #pre parse URI components
  #base_uri = "#{scheme}://#{host}:#{port}"#.freeze

  #read wordlist once
  words = File.readlines(wordlist).map(&:chomp).reject(&:empty?)
  total_words = words.size
  num_line = 0

  queue = Queue.new
  words.each {|word| queue << word}

  baseline_404 = get_404_baseline(target_url)
  #terminate = false
  #Signal.trap("INT") do
   # puts "\n\n[!] Ctrl+C received. Stopping scan..."
    #store resume data here
    #terminate = true

  #Persistent connection per thread
  workers = Array.new(opt[:threads]) do
    Thread.new do
      #begin
      #one http connection per thread
      http = Net::HTTP.new(host, port)
      http.read_timeout = opt[:timeout]
      http.open_timeout = opt[:timeout]

      if scheme == 'https'
        http.use_ssl = true
        # http.verify_mode = OpenSSL::SSL::VERIFY_NONE #optional, for speed
      end

      #start connection
      http.start

      while !queue.empty? 
        word = queue.pop(true) rescue break
        num_line = num_line + 1
        $resume_word = word
        path = base_path + word
        #path = word
          #create request
          #request = Net::HTTP.Get.new(path)
          #request = http.get(path)
          #request['User-Agent'] = 'Mozilla/5.0' #helps avoid blocks
          #request['Connection'] = 'keep-alive'
          #send request
          #response = http.request(request)

          #progress update
        queue_size = queue.size
        words_done = total_words - queue_size
        erase_line
        print "\rQueue: #{queue_size} left | Done: #{words_done}/#{total_words}"
        $stdout.flush
        #path = queue.pop(true) rescue break

        begin
          #response = Net::HTTP.get_response(URI.parse("#{target}/#{path}"))
          #path = "login"
          response = http.get("/#{path}")
          #erase_line
          #print "\r#{target}/#{path}"
          #$stdout.flush
          #baseline_404 = get_404_baseline(target_url)
          case response.code.to_i
          when 200..299
            if response.body.length != baseline_404[:length]
              erase_line
              puts "[CODE:#{response.code}]   #{response.message}:   #{target_url}/#{path}   (SIZE:#{response.body.length})"
            end
          when 300..399
            if response.body.length != baseline_404[:length]
              erase_line
              puts "[CODE:#{response.code}]   #{response.message}:   #{target_url}/#{path}   (SIZE:#{response.body.length})"
            end
          when 401
            if response.body.length != baseline_404[:length]
              erase_line
              puts "[CODE:#{response.code}]   #{response.message}:   #{target_url}/#{path}   (SIZE:#{response.body.length})"
            end
          when 403
            if response.body.length != baseline_404[:length]
              erase_line
              puts "[CODE:#{response.code}]   #{response.message}:   #{target_url}/#{path}   (SIZE:#{response.body.length})"
            end
          end
        #rescue SocketError, Errno::ECONNREFUSED, Errno::ETIMEDOUT, Net::ReadTimeout
          #skip connection errors
          #end
      rescue => e
          #retry
          #http.finish
          #http.start
          #retry
          #handle errors without infinte retries
          puts "\nError with #{word}: #{e.message}" if $DEBUG
          #other errors
      end
      end
      ensure
        #ensure connection is closed
      #close connection when thread is done
        http.finish if http&.started?
      end
    end
  #end
  begin
    workers.each(&:join)
    puts "\n\nEND TIME: #{Time.now.strftime("%a %d-%b-%Y %H:%M:%S")}"
    puts footer("end of directory bruteforcing", true, false)
    #ended successfully so delete session file
    File.delete("session.txt")
  rescue Interrupt
    puts "\nProgram terminated by user"
    save_to_resume(wordlist, $resume_word, num_line, target_url, $options)
    exit 1
  end

end
          


def count_lines(file_path)
  if File.exists?(file_path)
    File.readlines(file_path).count()
  else
    puts "ERROR: #{file_path} not  found or doesn't exists."
    return 0
  end
end

def if_empty(input, test_word)
  test_word.len > 0 ? input : ""
end

def if_empty(input, condition)
  condition ? input : ""
end



def merge_wordlists(wordlists)
  file = "yadirb_temp.txt"
  log_temp = "yadirb_log.txt"
  File.open(file, "a") do |f|
    wordlists.each do |wordlist|
      f.write(File.read(wordlist) + "\n")
    end
  end

  all_lines = []
  File.foreach(file) do |line|
    all_lines << line.chomp unless line.strip.empty? #Unless empty lines
  end

  uniq_lines = all_lines.uniq
  File.write(log_temp, uniq_lines.join("\n"))

  #Remove temporary file
  File.delete(file) if File.exists?(file)

  log_temp
end

def rewrite_resume_wordlists(wordlist, word, num_line)
  words = File.readlines(wordlist)
  #copy all file content to "words array"
  words = words[num_line..-1]
  #delete and rewrite to temp file
  File.delete(wordlist) if File.exists?(wordlist)
  File.write(wordlist, words.join(""))
  return wordlist
end


def save_to_resume(filename, word, num_line, url, options)
  file = "session.txt"
  if File.exists?(file)
    File.delete(file)
  end
  #options are needed
  File.open(file, "w") do |f|
    f.write("===SESSION OF #{Time.now.strftime("%a %d-%b-%Y %H:%M:%S")}===\n")
    f.write("Filename: #{filename}\n")
    f.write("URL: #{url}\n")
    f.write("Word Of Line: #{word}\n")
    f.write("Line Number: #{num_line}\n")
    f.write("OPTIONS: #{options}")
  end
end

def check_last_session()
  filename = "session.txt"
  return File.exists?(filename)
end

def resume_last_session()
  result = {}
  File.readlines("session.txt").each do |f|
    if f.start_with?("Filename: ")
      result[:filename] = f[10..-1].strip
    elsif f.start_with?("URL: ")
      result[:url] = f[4..-1].strip
    elsif f.start_with?("Word Of Line: ")
      result[:word] = f[14..-1].strip
    elsif f.start_with?("Line Number: ")
      result[:num_line] = f[12..-1].strip.to_i
    elsif f.start_with?("OPTIONS: ")
      result[:options] = eval(f[9..-1].strip)
    end
  end
  result
end

require 'io/console'

def terminal_width 
  IO.console.winsize[1] rescue 80
end

def header(title, to_upper = true, center_align = true)
  terminal_width = terminal_width()
  title_word = to_upper ? title.upcase : title
  
  
  padding = " " * ((terminal_width - title_word.length) / 2)
  border_padding = " " * ((terminal_width - title_word.length - 16) / 2)
  border = "=" * (title_word.length + 16)
  if center_align
    "#{border_padding}#{border}\n #{padding}#{title_word}\n#{border_padding}#{border}\n"
  else
    "#{border}\n#{title_word}\n#{border}\n"
  end
end


def footer(foot, to_upper = true, center_align = true)
  terminal_width = terminal_width()
  end_width = foot.length >= terminal_width ? foot.length / 3 : foot.length
  foot_word = to_upper ? foot.upcase : foot
  
  
  padding = " " * ((terminal_width - end_width) / 2)
  border = "=" * (terminal_width)
  if center_align
    "#{border}\n #{padding}#{foot_word}\n#{border}\n"
  else
    "#{border}\n#{foot_word}\n#{border}\n"
  end
end

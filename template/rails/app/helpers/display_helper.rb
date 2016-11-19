module DisplayHelper
  # Example
  #   scrap_word(long_text, 120)
  #   scrap_word(long_text, 120, "Read More", read_more_url)
  def scrap_word(text, char_count_limit, more_text = nil, more_link = nil, style='')
    # remove HTML tags
    text = text.to_s.gsub(/<\/?[^>]*>/, " ")
    # remove additional spaces
    text = text.to_s.gsub(/[ ]+/, " ")
    if text.length < char_count_limit
      return text
    end
    teaser = ""
    words = text.split(/ /)
    words.each do |word|
      if word.length > 0
        if (teaser + word).length > char_count_limit
          if more_text && more_link
            teaser = teaser + " " + link_to(more_text, more_link,:style=>style, :target=>"_blank")
          else
            teaser = teaser.strip + "..."
          end
          break;
        else
          teaser = teaser + word + " "
        end
      end
    end
    return teaser
  end

  def display_time(time)
    distance_of_time_in_words_to_now(time) + (time > Time.now ? " from now" : " ago")
  end

  def stringify_date(date)
    date.strftime("%A %d %b %Y")
  end
end
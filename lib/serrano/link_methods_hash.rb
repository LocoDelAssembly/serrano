# Hash methods
class Hash
  def links(just_urls = false)
    if self['message']['items'].nil?
      tmp = self['message']['link'].reject { |c| c.empty? }
    else
      tmp = self['message']['items'].collect { |x| x['link'] }.reject { |c| c.empty? }
    end

  	return parse_links(tmp, just_urls)
  end
end

class Hash
  def links_xml(just_urls = false)
  	return parse_links(pull_links(self, '^application\/xml$|^text\/xml$'), just_urls)
  end
end

class Hash
  def links_pdf(just_urls = false)
  	return parse_links(pull_links(self, '^application\/pdf$'), just_urls)
  end
end

class Hash
  def links_plain(just_urls = false)
  	return parse_links(pull_links(self, '^application\/plain$|^text\/plain$'), just_urls)
  end
end

def pull_links(x, y)
	return x['message']['items'].collect { |x| x['link'].select { |z| z['content-type'].match(/#{y}/) } }.reject { |c| c.empty? }
end

def parse_links(x, just_urls)
	if x.empty?
		return x
	else
  	if just_urls
  		return x.collect { |x| x.collect { |z| z['URL'] }}.flatten
  	else
  		return x
  	end
  end
end

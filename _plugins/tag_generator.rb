Jekyll::Hooks.register :posts, :post_write do |post|
    all_existing_tags = Dir.entries("pages/tags")
    .map { |t| t.match(/(.*).md/) }
    .compact.map { |m| m[1] }

    tags = post['tags'].reject { |t| t.empty? }
    tags.each do |tag|
    generate_tag_file(tag) if !all_existing_tags.include?(tag)
    end
end

def generate_tag_file(tag)
    # generate tag file
    File.open("pages/tags/#{tag}.md", "wb") do |file|
    file << "---\nlayout: page_no_title\ntitle: #{tag}\npermalink: /tags/#{tag}\ntags: #{tag}\n---\n\n
{% assign title = page.title | downcase %}
{% assign titleup = page.title | upcase %}
<h1>Archive of posts with '{{ page.title }}'</h1>
<ul class=\"posts\">
{% for post in site.posts %}
  {% if post.tags contains title or post.tags contains titleup or post.tags contains page.title %}
    <li>
      <span class=\"post-date\">{{ post.date | date: \"%b %-d, %Y\" }}</span>
      <a class=\"post-link\" href=\"{{ post.url | relative_url }}\">{{ post.title }}</a>
    </li>
  {% endif %}
{% endfor %}
</ul>
<p>
			<h4>All Tags</h4>
			{% assign all_tags = \"\" | split:\"\" %}
			{% for tag in site.tags %}
				{% capture temp_tag %}{{ tag[0] }}{% endcapture %}
				{% assign all_tags = all_tags | push: temp_tag %}
			{% endfor %}
			{% assign alpha_tags = all_tags | sort_natural %}
			{% for tagname in alpha_tags %}
			  <a href=\"/tags/{{ tagname }}.html\"><code class=\"highligher-rouge\"><nobr>{{ tagname }}</nobr></code></a>
			{% endfor %}
			</p>"
    end
    # generate feed file
    # File.open("feeds/#{tag}.xml", "wb") do |file|
    # file << "---\nlayout: feed\ntags: #{tag}\n---\n"
    # end
end
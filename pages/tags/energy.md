---
layout: page_no_title
title: energy
permalink: /tags/energy
tags: energy
---


{% assign title = page.title | downcase %}
{% assign titleup = page.title | upcase %}
<h1>Archive of posts with '{{ page.title }}'</h1>
<ul class="posts">
{% for post in site.posts %}
  {% if post.tags contains title or post.tags contains titleup or post.tags contains page.title %}
    <li>
      <span class="post-date">{{ post.date | date: "%b %-d, %Y" }}</span>
      <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endif %}
{% endfor %}
</ul>
<p>
			<h4>All Tags</h4>
			{% assign all_tags = "" | split:"" %}
			{% for tag in site.tags %}
				{% capture temp_tag %}{{ tag[0] }}{% endcapture %}
				{% assign all_tags = all_tags | push: temp_tag %}
			{% endfor %}
			{% assign alpha_tags = all_tags | sort_natural %}
			{% for tagname in alpha_tags %}
			  <a href="/tags/{{ tagname }}.html"><code class="highligher-rouge"><nobr>{{ tagname }}</nobr></code></a>
			{% endfor %}
			</p>
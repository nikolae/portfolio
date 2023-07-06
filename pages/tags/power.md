---
layout: page_no_title
title: power
permalink: /tags/power
tags: power
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
			{% capture temptags %}
			  {% for tag in site.tags %}
				{{ tag[1].size | plus: 1000 }}#{{ tag[0] }}#{{ tag[1].size }}
			  {% endfor %}
			{% endcapture %}
			{% assign sortedtemptags = temptags | split:' ' | sort | reverse %}
			{% for temptag in sortedtemptags %}
			  {% assign tagitems = temptag | split: '#' %}
			  {% capture tagname %}{{ tagitems[1] }}{% endcapture %}
			  <a href="/tags/{{ tagname }}.html"><code class="highligher-rouge"><nobr>{{ tagname }}</nobr></code></a>
			{% endfor %}
			</p>
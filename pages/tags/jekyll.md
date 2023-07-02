---
layout: page_no_title
title: jekyll
permalink: /tags/jekyll
tags: jekyll
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
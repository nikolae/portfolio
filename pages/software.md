---
layout: page
title: Software
permalink: /tags/software.html
---

{% assign title = page.title | downcase %}
<h1>Archive of posts with '{{ page.title }}'</h1>
<ul class="posts">
  {% for post in site.posts %}
    {% if post.tags contains title %}
      <li>
        <span class="post-date">{{ post.date | date: "%b %-d, %Y" }}</span>
        <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </li>
    {% endif %}
  {% endfor %}
</ul>
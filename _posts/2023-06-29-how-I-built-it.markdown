---
layout: page
title:  "How I Built It"
teaser: "In which I go off the 'Rails'"
date:   2023-06-29 15:03:15 -0700
categories: software web
tags: web software jekyll DNS
published: true
---
# Welcome!

![Duck](/assets/images/Donald_Duck.png){: height="250" }

After recently being inspired to finally do something with the horde of domains I'm sitting on, today I'm going to lay out how exactly I was able to get my personal portfolio up and running with Cloudflare and Github Pages. 

This guide is for Windows.

# Goals:
* To be able to have a place to remember how I did _that one thing_
* To be able to showcase anything (marginally) cool I built
* To be able to use markdown as a means for creating content (HTML is just _so 90s_, man)
* To spend as little as possible (having monkeying with websites for 20+ years, I'm over dealing with hosting providers [for now])
* To have more control over the content, formatting, and layout without installing bloat or increase attack surface
* To feel smug about having a domain that has my name


# Requirements
For this effort, I'm using a domain name and Github pages. This is optional; you can just use the URL provided by Github directly.
* Github account
* Computing device
* Base understanding of Git (here's a [refresher][conversational-git])
* Some time and/or coffee

# Ruby
Download and install [ruby][ruby]. 

When it's done installing, make sure to check the `ridk` box.
![RubyInstall](/assets/images/guides/ruby_install.jpg)

This opens a new prompt. Enter in options `1,3`

![RubyInstall2](/assets/images/guides/ruby_install2.jpg){: height="250" }

Finally, open a new command prompt window from Start, and type `ridk enable`.

# Bundler
Open a _Powershell_ window. Run `gem install bundler`. This is successful if you see the "1 gem installed" message

# Git
If you don't already have it installed, install [Git][git].

Also create a new repository on GitHub on your account. Once created, go to that repo and click on Settings (1), then Pages on the left (2). Here, you need to select which branch you want to auto-build from (3) with an optional embedded directory. In mine, that's `prod`. Optionally, type in your domain name (4).
![GitHubPages](/assets/images/guides/github_pages.jpg)

If you are, using your DNS provider, enure `www` is pointing to your domain apex (@). Then, create a `CNAME` record to `<USER>.github.io`, where `<USER>` is your github username. Give it up to an hour to propagate, then come back and check the settings to ensure it linked correctly.

# Jekyll
Open a new command prompt window from Start, and run `gem install jekyll bundler`. When it's done, run `jekyll -v` to verify it was installed properly (you'll see a version).
![jekyllv](/assets/images/guides/jekyll.jpg)

# Build it!
We'll need a place to store our site, so go choose one now. Create an empty folder there - that will be what everything (the site, git repo, assets, etc) is stored in. From here on out, we'll be using Git Bash to do our command line kung-fu, so open that.

In Git Bash type, 

{% highlight sh %}
git init REPO
cd REPO
git checkout --orphan BRANCH
{% endhighlight %}
where `REPO` is your remote repository name and `BRANCH` is your build branch from earlier.

Now, let's make your Jekyll site. This will create the new instantiation of Jekyll in our previously navigated to directory (`.`). The `--force` flag ignores and Readme.md or other files created by GitHub. Optionally, delete everything here before running the next command.
{% highlight sh %}
jekyll new --skip-bundle . --force
{% endhighlight %}

Navigate to where you made the site in Windows Exporer. Open the Gemfile that Jekyll made. Add `#` to the beginning of the line that starts with gem `jekyll` to comment out this line. Now, add the github-pages gem by editing the line starting with `# gem "github-pages"`. Change this line to:
{% highlight sh %}
gem "github-pages", "~> GITHUB-PAGES-VERSION", group: :jekyll_plugins
{% endhighlight %}
Replace GITHUB-PAGES-VERSION with the latest supported version of the github-pages gem (e.g., 228). Check the version [here][gpages]. Save and close. 

Going back to the Bash window, run `bundle install`. When we deploy, a different version (most likely) of Jekyll will be isntalled as a dependency of the github-pages gem that is compatible with GitHub so it can auto-build.

Assuming everything has gone right, you're ready to test your site locally by running `bundle exec jekyll serve`! It can be found at `http://http://localhost:4000/`

# Push it. Push it real good.
Once you're happy with the content, don't forget to add, commit and push your files to the cloud. If you're not commiting to your build branch (please don't), make a pull request and let GitHub handle the rest!


# References
The info for this post was concatenated from the following sources:
* [https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/creating-a-github-pages-site-with-jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/creating-a-github-pages-site-with-jekyll)
* [https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/testing-your-github-pages-site-locally-with-jekyll](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/testing-your-github-pages-site-locally-with-jekyll)
* [https://jekyllrb.com/docs/configuration/default/](https://jekyllrb.com/docs/configuration/default/)
* [https://www.geeksforgeeks.org/how-to-install-ruby-bundler-on-windows/#](https://www.geeksforgeeks.org/how-to-install-ruby-bundler-on-windows/#)
* [https://jekyllrb.com/docs/installation/windows/](https://jekyllrb.com/docs/installation/windows/)

---


[conversational-git]: https://alanhohn.com/extras/conversational-git/
[ruby]: https://www.ruby-lang.org/en/documentation/installation/
[git]: https://gitforwindows.org/
[gpages]: https://pages.github.com/versions/
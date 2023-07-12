---
layout: page
title:  "Jekyll on Mac"
teaser: "The definition of insanity is doing it again and again."
date:   2023-07-12 07:00:00 -0600
categories: software web
tags: web software jekyll guides mac
---
## Do it again

I recently posted a [guide](https://nickaroneseno.com/software/web/how-I-built-it/) on how to use Jekyll as a static site generator on Windows. Time to do it again! This guide is for Mac.

<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

## Requirements
* Github account (optional, but recommended)
* Computing device
* Base understanding of Git (here's a [refresher][conversational-git])

## Brew
While Mac comes with Ruby, it's usually a bit outdated from the latest. For instance, a June 2023 Mac ships with Ruby from April 2022. We don't necessarily want to remove that version. For this reason, we will be installing [Homebrew](https://brew.sh) - a package manager. As of July 2023, paste this into Terminal: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`, or go to the [website](https://brew.sh) and look for the latest command.

![mac01](/assets/images/guides/mac01.jpg)

Once it's installed, you might want to consider adding it to your PATH variable to easily call it. As two separate commands, run `(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/USER/.zprofile` (where USER is your Unix short name) and `eval "$(/opt/homebrew/bin/brew shellenv)"`.

## Ruby
Now that we have a nice package manager installed, let's grab the Ruby version we need: `brew install chruby ruby-install xz`. 

![mac02](/assets/images/guides/mac02.jpg)

Now, `ruby-install ruby 3.1.3` (this will take a bit).

![mac03](/assets/images/guides/mac03.jpg)

Configure Terminal to call chruby by default:
* `echo "source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh" >> ~/.zshrc`
* `echo "source $(brew --prefix)/opt/chruby/share/chruby/auto.sh" >> ~/.zshrc`
* `echo "chruby ruby-3.1.3" >> ~/.zshrc # run 'chruby' to see actual version`

Quit Terminal and re-open it. Run `chruby` to make sure the above PATH updates worked and `ruby -v` to check the right version of Ruby is now being used.

## Jekyll
This is pretty straightforward. Type and run `gem install jekyll`.

![mac04](/assets/images/guides/mac04.jpg)

You are now at the point of cloning your existing website (if you have one) or making a new one. If you have an existing one, clone (see [previous guide](https://nickaroneseno.com/software/web/how-I-built-it/#git)) and navigate to your site's directory. Don't forget to run `bundle install`, or you will get some bad news:
![mac05](/assets/images/guides/mac05.jpg)

To create a new site, navigate to the directory you want and type: `jekyll new --skip-bundle . --force`.

Once you have a site generated or cloned, preview the website with `bundle exec jekyll serve` or generate the HTML files with `bundle exec jekyll build`.

![mac06](/assets/images/guides/mac06.png)

## References
* [https://jekyllrb.com/docs/installation/macos/](https://jekyllrb.com/docs/installation/macos/)
* [https://www.moncefbelyamani.com/which-shell-am-i-using-how-can-i-switch/](https://www.moncefbelyamani.com/which-shell-am-i-using-how-can-i-switch/)
* [https://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/](https://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)
* [https://nickaroneseno.com/software/web/how-I-built-it/](https://nickaroneseno.com/software/web/how-I-built-it/)

[conversational-git]: https://alanhohn.com/extras/conversational-git/
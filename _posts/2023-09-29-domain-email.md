---
layout: page
title:  "Send and Receive email with custom domain"
teaser: "Expanding the power of your domain name by creating custom email addresses."
date:   2023-09-29 07:00:01 -0700
categories: web software
tags: software web email
published: true
header: no
---
<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

## Custom email 
Having a custom domain is just the first step, especially if you are looking to start a business or have a more transportable email (the public facing address can be used with different providers over time).

## Receiving
Many domain providers allow you to create email aliases and assign behind-the-scenes addresses for incoming mail to forward to. Here are the settings with Cloudflare:

![email1](/assets/images/guides/email01.jpg)
>Cloudflare email forwarding.

It's pretty simple. Create a new address for the domain and assign it to one of the email's that you've added to your account. Nice!

## Sending
Sending is a bit more complicated, but not overly so. Here are the steps for Gmail

### App password
Before we can even begin configuring the send portion in Gmail's settings, we need to create a new app password for this specific address to access your Gmail account.
1. Manage your account
2. Security
3. 2 Step Verification
4. Scroll down and click on app password
5. Give it a name (I recommend the new address you want to use)
 * Remember the password it generates. You will need this in the next few steps.

![email2](/assets/images/guides/email02.jpg)
>Create an app password.

### Configure Gmail
Go to Gmail, and click `Settings`, then `See all settings`. Go the `Accounts and Import` tab, then click `Add another email` address about mid-way down the page.
![email3](/assets/images/guides/email03.jpg)
>Add another email address.

The next window will ask for a name, which is the display name when you send the email (who is it from) and the address you added on the Receive side. Populate these both, leave the `Treat as an alias` box checked, then click `Next Step`.

![email4](/assets/images/guides/email04.jpg)
>Add your send-as name and new email address.

The final step is to add your mail exchange server (if using gmail, leave as `smtp.gmail.com` and either port 465 or 587), your Google account username, and the app password you made before. Spaces do not matter. Click Add account and refresh Gmail. You will receive a test email from the server to verify, which should already forward to you - this is why we configure Receive before Send. Confirm the email and that's it!

![email5](/assets/images/guides/email05.jpg)
>Configure the new address.


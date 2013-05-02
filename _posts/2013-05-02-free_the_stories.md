---
layout: post
title: Free the Stories
category: design
tag: rizon

type: default
short: Free the Stories was a planned fiction site/network, which I was designing for. 

search_desc: fts, rizon, web design, jquery
---

# {{ page.title }}

Free the Stories was a little fiction site project I joined, with a few guys from Rizon who were dissatisfied with [Fanfiction.net's](http://fanfiction.net/) way of running things. Basically, to try and create somewhere authors could post their stories, and not worry about the seemingly archaic way they were running their site, policing stories, and the like.

So I came on a little later than everyone else, and made a visual identity and design for the site. It was my first time using jQuery in a design, to make it a little more dynamic than most of my stuff, and I think it turned out well.

Of course, I overused jQuery like crazy, didn't make it compatible with anything but Firefox/Chrome, and didn't make it accessible to users with small screens, but for a design preview I think it turned out fairly well.

## Idea

So basically, my idea for FtS was for differing story universes to be separated, similarly to [Reddit's](http://reddit.com/) subreddits. As subreddits are used to separate different ideas, interests, and just groups in general, different universes would be used to separate distinct story universes.

For instance, *Harry Potter*, *Discworld*, and *Twilight* would be different universes. As this is primarily designed for stories with a specific universe in mind, stuff like fanfiction and the like, original stories are put under the annoyingly hacky solution of the *Originals* universe.

## Database Design

This is one of those fun projects where I was able to help out with our database design (something I love!). Fairly standard design for a fiction site, with the universes tagging each of our stories (and a story being able to be part of multiple universes, such as for crossovers).

So yeah, fairly standard, I'll throw the MySQL Workbench file up later.

## Graphic Design and Theme

With Free the Stories, the name was already set in stone before I arrived. Not that I mind of course, it's a nice name. Thinking about it got me thinking of being free, open, nice and airy, which is why I went with quite a subdued colour palate for the main site.

The FtS wordmark took a few iterations to get right, the contrast of the smaller, and grey *t* in the middle was a little bit of work. But all in all, it turned out quite nice.

Quite a lot of the site design was based on another fiction site, [FimFiction.net](http://fimfiction.net/). Their method of displaying stories (at least, when this was around) was quite polished, nicely displayed, and quite good to look at. I eventually leaned away from that, though – especially as I refined and worked out what sort of information we wanted, and didn't want, to display.

One very important thing to know in design, programming, any creative craft really, is to know when to copy, when to modify to your own purposes, and when to simply go your own way entirely. If you never, ever copy, you'll never get any actual work done. If you always copy, you'll never get any *original* work done. It's similar to knowing when to use libraries and where to write your own code, when programming. Knowing where to strike that balance is key.

## The Site

Ah, the site itself, finally. If you wanna take a look, [here's](http://fts.danneh.net/) the design I ended up with, and let me explain how I got there.

So this is just after I'd learned about and started using jQuery, my favorite Javascript library right now. So, quite a lot of the animations are done with it (despite probably being able to work with CSS animations and smoothing), and a lot of dynamic features litter the site, despite it being just and only a design mockup.

Firstly, the universe list up the top closely resembles the subreddit inspiration, and seemed like a nice way to display them. The auto-scrolling was rejected by the team, so we went with little scroll buttons instead.

The Genres list, and clicking to add/remove them was, I though, quite a nice, dynamic touch. Thinking back on it, I would probably add them to the extended search drop-down bar, and have a way to specify whether you want a genre included, or excluded, but I think it's an interesting concept, and a nice way to handle it.

Of course, if the project had gotten any further, I'd have worked on those issues more, improved the cross-browser compatibility, hopefully toned down a lot of the jQuery, and given the whole thing a bit more 'identity'. But as it stands, I think it turned out quite well, and was a very nice learning experience.

You can find Free the Stories' design [here.](http://fts.danneh.net/)

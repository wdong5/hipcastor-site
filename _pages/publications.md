---
title: "HiPCastor - Publications"
layout: gridlay
excerpt: "HiPCastor -- Publications."
sitemap: true
permalink: /publications/
---


# Publications

## Group highlights

**Highlighted recent publications from the group; scroll down for [an extended list of publications](#full-publication-list).**


{% for publi in site.data.publist %}
{% if publi.highlight == 1 %}
<div class="hpc-card hpc-pub-card">
  <a href="{{ publi.link.url }}" class="stretched-link"></a>
  <pubtit>{{ publi.title }}</pubtit>
  <img src="{{ site.url }}{{ site.baseurl }}/images/pubpic/{{ publi.image }}" class="img-fluid" width="33%" style="float: left" loading="lazy" alt="{{ publi.title }}" />
  <p>{{ publi.description }}</p>
  <p><em>{{ publi.authors }}</em></p>
  <kbd>{{ publi.series }}</kbd>
  <p>In {{ publi.link.display }}</p>
  <p class="text-danger"><strong>{{ publi.news1 }}</strong></p>
  <p>{{ publi.news2 }}</p>
</div>
{% endif %}
{% endfor %}

<p> &nbsp; </p>

## Full Publication List

{% for publi in site.data.publist %}

  <kbd> {{ publi.series }} </kbd> <a href="{{ publi.link.url }}">{{ publi.title }}</a> <br />
  <em>{{ publi.authors }} </em><br/>In {{ publi.link.display }}

{% endfor %}

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


{% assign number_printed = 0 %}
{% for publi in site.data.publist %}

{% assign even_odd = number_printed | modulo: 2 %}
{% if publi.highlight == 1 %}

{% if even_odd == 0 %}
<div class="row">
{% endif %}

<div class="col-sm-6 clearfix">
 <div class="well">
  <pubtit><a href="{{publi.link.url}}">{{ publi.title }}</a></pubtit>
  <img src="{{ site.url }}{{ site.baseurl }}/images/pubpic/{{ publi.image }}" class="img-responsive" width="33%" style="float: left" loading="lazy" />
  <p>{{ publi.description }}</p>
  <p><em>{{ publi.authors }}</em></p>
  <kbd>{{ publi.series }}</kbd>
  <p>In {{ publi.link.display }}</p>
  <p class="text-danger"><strong> {{ publi.news1 }}</strong></p>
  <p> {{ publi.news2 }}</p>
 </div>
</div>

{% assign number_printed = number_printed | plus: 1 %}

{% if even_odd == 1 %}
</div>
{% endif %}

{% endif %}
{% endfor %}

{% assign even_odd = number_printed | modulo: 2 %}
{% if even_odd == 1 %}
</div>
{% endif %}

<p> &nbsp; </p>

## Full Publication List

{% for publi in site.data.publist %}

  <kbd> {{ publi.series }} </kbd> <a href="{{ publi.link.url }}">{{ publi.title }}</a> <br />
  <em>{{ publi.authors }} </em><br/>In {{ publi.link.display }}

{% endfor %}

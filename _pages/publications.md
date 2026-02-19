---
title: "HiPCastor - Publications"
layout: gridlay
excerpt: "HiPCastor -- Publications."
sitemap: true
permalink: /publications/
---


<p class="text-center">Highlighted recent publications from the group.</p>

<p class="text-center"><a href="#full-publication-list" class="hpc-arrow-link">All publications</a></p>


{% for publi in site.data.publist %}
{% if publi.highlight == 1 %}
<div class="hpc-card hpc-pub-card">
  <a href="{{ publi.link.url }}" class="stretched-link"></a>
  <pubtit>{{ publi.title }}</pubtit>
  <img src="{{ '/images/pubpic/' | append: publi.image | relative_url }}" class="img-fluid" width="33%" style="float: left" loading="lazy" alt="{{ publi.title }}" />
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
{% if publi.link.url != "" %}
<div class="hpc-item hpc-pub-card" markdown="0">
  <a href="{{ publi.link.url }}" class="stretched-link"></a>
  <pubtit>{{ publi.title }}</pubtit>
  <p class="mb-0"><kbd>{{ publi.series }}</kbd> <em>{{ publi.authors }}</em></p>
</div>
{% else %}
<div class="hpc-item" markdown="0">
  <pubtit>{{ publi.title }}</pubtit>
  <p class="mb-0"><kbd>{{ publi.series }}</kbd> <em>{{ publi.authors }}</em></p>
</div>
{% endif %}
{% endfor %}

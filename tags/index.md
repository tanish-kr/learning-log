## Tags

{% assign tags_list = site.tags %}

<div class="container page-tags">
<div class="tags are-medium">
{% for tag in tags_list %}<a href="/tags/{{ tag[0] | slugify }}/"><span class="tag is-primary">{{ tag[0] | url_decode }}({{ tag[1] | size }})</span></a>
{% endfor %}
</div>
</div>

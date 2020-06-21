{% assign base_url = '/PG/scala/' %}

### [scala]({{ base_url }})

{% for node in site.html_pages %}
  {% if node.url contains base_url %}
    {% assign node_url_parts = node.url | split: '/' %}
    {% assign node_url_parts_size = node_url_parts | size %}
    {% assign filename = node_url_parts | last %}
    {% if node.url != base_url %}
- [{{ node.title }}]({{ node.url }})
    {% endif %}
  {% endif %}
{% endfor %}

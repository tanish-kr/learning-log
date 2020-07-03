{% assign root_path = include.root_path %}
{% assign base_url = '/PG/JavaScript/' %}
{% assign react_url = root_path | append: 'React/index.md' %}

### [JavaScript]({{ base_url }})

{% for node in site.html_pages %}
  {% if node.url contains base_url %}
    {% assign node_url_parts = node.url | split: '/' %}
    {% assign node_url_parts_size = node_url_parts | size %}
    {% assign filename = node_url_parts | last %}
    {% unless node.url == base_url or node.url contains 'React' or node.url contains 'Backbone' or node.url contains 'node' %}
- [{{ node.title }}]({{ node.url }})
    {% endunless %}
  {% endif %}
{% endfor %}

{% include_relative {{react_url}} %}

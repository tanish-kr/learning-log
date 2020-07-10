## Categories

{% assign categories_list = site.categories %}

{% for category in categories_list %}
- [{{ category[0] | url_decode }}](/categories/{{ category[0] | slugify }}/) ({{ category[1] | size }})
  {% for page in category[1] %}
  - [{{ page.title }}]({{ page.url }})
  {% endfor %}
{% endfor %}

{% assign root_path = include.root_path %}
{% assign ruby_url = root_path | append: 'Ruby/index.md' %}
{% assign php_url = root_path | append: 'PHP/index.md' %}
{% assign python_url = root_path | append: 'Python/index.md' %}
{% assign javascript_url = root_path | append: 'JavaScript/index.md' %}
{% assign javascript_path = root_path | append: 'JavaScript/' %}
{% assign java_url = root_path | append: 'Java/index.md' %}
{% assign go_url = root_path | append:  'golang/index.md' %}
{% assign android_url = root_path | append: 'Android/index.md' %}

## [PG](/PG/)

{% include_relative {{ruby_url}} %}
{% include_relative {{php_url}} %}
{% include_relative {{python_url}} %}
{% include_relative {{javascript_url}} root_path=javascript_path %}
{% include_relative {{java_url }} %}
{% include_relative {{go_url}} %}
{% include_relative {{android_url}} %}

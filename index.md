---
title: Top
---

## About this website

こちらでは主に書籍や公式ドキュメントから学習した内容を、写経したり、まとめたものをアウトプットしています。
新しい情報よりは、主に概出の情報が溜まっています。
誤字等ありましたら、[Issue](https://github.com/tanish-kr/learning-log/issues)の方に上げて頂けると幸いです。

{% include recent_articles.html %}

{% assign categories_list = site.categories %}
{% for category in categories_list %}
{% unless category[0] == 'Programming' %}
- [{{ category[0] | url_decode }}](/categories/{{ category[0] | slugify }}/) ({{ category[1] | size }})
  {% for page in category[1] %}
  - [{{ page.title | url_decode }}]({{ page.url }})
  {% endfor %}
{% endunless %}
{% endfor %}

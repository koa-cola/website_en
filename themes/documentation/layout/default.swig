<!DOCTYPE html>
<html>
<head>
  <meta charSet='utf-8' />
  <title>{{config.title + ' - ' + page.title}}</title>
  <link href='{{ url_for("css/docs.css") }}' rel='stylesheet'>
  <link href='{{ url_for("css/github-markdown.css") }}' rel='stylesheet'>
  <script>
    window.onunload = function(){
      var scollTop = document.getElementsByClassName('menu-nav')[0].scrollTop;
      document.cookie = 'scollTop=' + scollTop;
    }
    window.onload = function(){
      var scrollTop = /scollTop=(\d+)/.test(document.cookie) && RegExp.$1;
      document.getElementsByClassName('menu-nav')[0].style.overflowY='scroll'
      document.getElementsByClassName('menu-nav')[0].scrollTop = scrollTop || 0;
      document.getElementsByClassName('menu-nav')[0].style.overflowY='hidden'
    }
  </script>
</head>
<body>
  <div class='menu'>
    <div class='logo'>
      <a href="https://www.github.com/hcnode/koa-cola"><img src="/doc/images/github.png" width="25"></a>&nbsp;&nbsp;Koa-cola
    </div>
    <nav class='menu-nav' style="max-height: 87%;" onmouseover="this.style.overflowY='scroll'"  onmouseout="this.style.overflowY='hidden'">
      {% for section in site.data.nav %}
        <ul class='nav'>
          <span>{{ section.title }}</span>
          <ul class='nav'>
            {% for item in section.items %}
              <li>
              {% if item.items %}
                <a href='{{item.href || url_for(item.id + ".html") }}'{% if item.id == page.id %} class='active'{% endif %} style="padding:0px">{{item.title}}</a>
                <ul class='nav' style="padding-top:0px">
                  {% for item2 in item.items %}
                    <li style="height:28px">
                      <a href='{{item2.href || url_for(item2.id + ".html") }}'{% if item2.id == page.id %} class='active'{% endif %}>{{item2.title}}</a>
                    </li>
                  {% endfor %}
                </ul>
              {% else %}
                 <a href='{{item.href || url_for(item.id + ".html") }}'{% if item.id == page.id %} class='active'{% endif %}>{{item.title}}</a>
              {% endif %}
              </li>
            {% endfor %}
          </ul>
        </ul>
      {% endfor %}
    </nav>
  </div>
  <div class='page'>
    <div class='page-content'>
      <h1>{{page.title}}</h1>
      <div style="
          float: right;
          top: -60px;
          position: relative;
          margin-right: 10px;
      "><a href="https://github.com/koa-cola/website_en/blob/master/source/{{page.id}}.md">Edit</a></div>
      {{page.content}}
    </div>
  </div>
  <div class='switch-page'>
    {% if page.prev %}
      <a class='previous' href='{{ url_for(page.prev) }}'>Previous</a>
    {% endif %}
    {% if page.next %}
      <a class='next' href='{{ url_for(page.next) }}'>Next</a>
    {% endif %}
  </div>
</body>
</html>

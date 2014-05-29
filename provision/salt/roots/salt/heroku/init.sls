{% set heroku = pillar.get('heroku', {}) -%}

get-heroku:
  file.managed:
    - name: /usr/local/heroku/heroku-client.tgz
    - source: salt://heroku/files/heroku-client.tgz
    - makedirs: True
  cmd.wait:
    - cwd: /usr/local/heroku
    - names:
      - tar -zxvf heroku-client.tgz
    - watch:
      - file: /usr/local/heroku/heroku-client.tgz

install-heroku:
  file.symlink:
    - name: /usr/local/bin/heroku
    - target: /usr/local/heroku/heroku-client/bin/heroku
  watch:
    - file: /usr/local/heroku/heroku-client/bin/heroku

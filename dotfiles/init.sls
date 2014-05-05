{% from "dotfiles/map.jinja" import packages with context %}
{% set user = salt['pillar.get']('dotfiles:user', 'root') %}
{% set group = salt['pillar.get']('dotfiles:group', 'root') %}
{% set home = salt['pillar.get']('dotfiles:home', '/root') %}

dotfiles_packages:
  pkg.installed:
    - pkgs: {{ packages }}

{{ home }}/dotfiles:
  file.recurse:
    - source: salt://dotfiles/files
    - user: {{ user }}
    - group: {{ group }}
    - clean: True
    - require:
        - pkg: dotfiles_packages

{% for name in ['bashrc', 'emacs', 'gitconfig', 'tmux.conf'] %}
{{ home }}/.{{ name }}:
  file.symlink:
    - target: {{ home }}/dotfiles/{{ name }}
    - force: True
    - require:
        - file: {{ home }}/dotfiles
{% endfor %}

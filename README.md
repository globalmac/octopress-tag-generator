# Octopress Tag Generator Plugin

### Установка:

- Скачиваем [архив](https://github.com/globalmac/octopress-tag-generator/archive/master.zip)
- Файл **tag_generator.rb** кидаем в папку **PATH_TO_OCTOPRESS/plugins**
- Файл **tag_feed.xml** кидаем в папку **PATH_TO_OCTOPRESS/source**
- Файл **tags_index.html** кидаем в папку **PATH_TO_OCTOPRESS/source/_layouts**
- Правим конфиг **_config.yml** прописываем:
  - tag_title_prefix: "Тэг: "
  - tag_meta_description_prefix: "Тэг: "
  - tags_dir: blog/tags
- И теперь в нужном нам месте, например в шаблоне поста **(PATH_TO_OCTOPRESS/source/_includes/article.html)**, вставляем - **{{ page.tags | tag_links }}**

Как Вы поняли, адреса страниц будут такие : **SITE_URL/blog/tags/мой_тэг**

Если требуется поправить вывод ссылок или кастомизировать что-то открываем - **tag_generator.rb**

Все готово, рестартим rake и проверяем =)



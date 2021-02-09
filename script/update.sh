#!/bin/bash
git_md_home="/junsom/git/hexo-md"
git_md_dir="${git_md_home}/md"

blog_home="/junsom/blog"
blog_post_dir="${blog_home}/source/_posts"

cd ${git_md_home}
sudo git pull

cd ${blog_post_dir}
sudo rm -rf *

sudo cp -r ${git_md_dir}/* .

cd ${blog_home}

sudo hexo clean
sudo hexo generate





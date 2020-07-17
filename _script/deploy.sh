#!/usr/bin/env sh

deploy_dir="_site"
html_files=`find $deploy_dir -name '*.html' -type f`
s3_bucket="s3://www.tanish-kr.com"

for file in $html_files; do
  if [[ ! $file =~ 'index.html' ]]; then
    reprace_name=`echo $file | sed -r 's/\.html//'`
    mv $file $reprace_name
  fi
done

aws s3 sync $deploy_dir $s3_bucket --exclude "*.md" --exclude "*.js" --exclude "*.css" --exclude "*.xml" --exclude ".DS_Store" --acl public-read --content-type "text/html"
aws s3 sync $deploy_dir $s3_bucket --exclude "*.md" --include "*.js" --include "*.css" --include "*.xml" --exclude ".DS_Store" --acl public-read

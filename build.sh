sudo rm -rf public \
&& docker run --rm -v $(pwd):/src klakegg/hugo:latest -e production --minify \
&& sudo chown -R $USER:$USER public

FROM jekyll/builder:4.0 as build
COPY Gemfile* /srv/jekyll/
RUN bundle install
COPY . /srv/jekyll
RUN jekyll build

FROM nginx:alpine
COPY --from=build /srv/jekyll/_site /usr/share/nginx/html

# HiPCastor Group Website

This is the website of our HPC group at Oregon State University

This website is powered by Jekyll and some Bootstrap, Bootwatch. It is based on [allanlab](https://www.allanlab.org/).

Go to *aboutwebsite.md*  to learn how to copy and modify this page for your own purposes. 


Copyright 2026 HiPCastor @ OSU. Code released under MIT License.

To preview run locally:
```shell
docker run --rm -v "$PWD:/var/jekyll" -p 4000:4000 mrxder/jekyll-docker-arm64 jekyll serve --watch --host 0.0.0.0 --baseurl "/"
```

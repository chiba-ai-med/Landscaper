FROM koki/landscaper_component:latest

ADD src /src
ADD landscaper /
ADD Snakefile /

WORKDIR /

ENTRYPOINT ["/landscaper"]

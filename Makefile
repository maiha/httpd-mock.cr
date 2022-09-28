all: run

bin/httpd-mock:
	shards build --link-flags "-static" $(O)

#DOCKER=docker run -t -u `id -u`:`id -g` -v $(PWD):/v -w /v --rm crystallang/crystal:1.5.1
#$(DOCKER) shards build --link-flags "-static -L$(PWD) -lxml2" $(O)
#libxml2.a:
#	curl -s -L -o libxml2.a https://github.com/maiha/libxml2-min/releases/download/v0.1.0/libxml2.a

run: bin/httpd-mock
	$< 0.0.0.0:8080

clean:
	rm -f libxml2.a bin/httpd-mock

.PHONY: docker-build, deb

docker-build:
	docker build . -t nuxeo-drive-deb-builder

deb: docker-build
	docker run -it --rm -v $$(pwd)/deb:/src/ndrive-2.5.4/debian/dist nuxeo-drive-deb-builder

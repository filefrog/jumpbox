IMAGE ?= filefrog/jumpbox
TAG   ?= latest

latest:
	docker build \
	  --build-arg BUILD_DATE="$(shell date -u --iso-8601)" \
	  --build-arg VCS_REF="$(shell git rev-parse --short HEAD)" \
	  --build-arg cf_version="$(shell ./latest cf)" \
	  --build-arg bbr_version="$(shell ./latest bbr)" \
	  --build-arg bosh_version="$(shell ./latest bosh)" \
	  --build-arg credhub_version="$(shell ./latest credhub)" \
	  --build-arg fly_version="$(shell ./latest fly)" \
	  --build-arg kubectl_version="$(shell ./latest kubectl)" \
	  --build-arg jq_version="$(shell ./latest jq)" \
	  --build-arg safe_version="$(shell ./latest safe)" \
	  --build-arg spruce_version="$(shell ./latest spruce)" \
	  --build-arg terraform_version="$(shell ./latest terraform)" \
	  --build-arg vault_version="$(shell ./latest vault)" \
	  --build-arg genesis_version="$(shell ./latest genesis)" \
	  . -t $(IMAGE):$(TAG)

build:
	docker build \
	  --build-arg BUILD_DATE="$(shell date -u --iso-8601)" \
	  --build-arg VCS_REF="$(shell git rev-parse --short HEAD)" \
	  . -t $(IMAGE):$(TAG)

push: build
	docker push $(IMAGE):$(TAG)

.PHONY: latest build push

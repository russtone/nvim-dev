LANGS = $(patsubst %/,%,$(wildcard */))

.PHONY: gen
gen:
	@for lang in ${LANGS}; do \
		gomplate -c ".=$$lang/config.yaml" -f Dockerfile.tmpl -o $$lang/Dockerfile; \
	done

.PHONY: base
base:
	@docker build -t nvim .

.PHONY: all
build: gen base
	@for lang in ${LANGS}; do \
		docker build -t nvim-$$lang ./$$lang; \
	done

.PHONY: del
clean:
	@docker images --format '{{.Repository}}:{{.Tag}}' | grep nvim | xargs -n 1 docker rmi
	@docker system prune -f

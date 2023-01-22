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
all: gen base
	@for lang in ${LANGS}; do \
		docker build -t nvim-$$lang ./$$lang; \
	done

SHELL := /bin/sh

PERSONAL_IMAGE := ste-personal-site-local
WEDDING_IMAGE := ste-wedding-site-local

.PHONY: local-personal local-wedding

local-personal:
	docker build -t $(PERSONAL_IMAGE) ./personal-site
	docker run --rm -p 8080:80 $(PERSONAL_IMAGE)

local-wedding:
	docker build -t $(WEDDING_IMAGE) ./wedding-site
	docker run --rm -p 8081:80 $(WEDDING_IMAGE)

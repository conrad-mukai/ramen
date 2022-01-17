# Makefile to update format and documentation

# find all modules
modules = $(shell find . -name main.tf -exec dirname {} \;)

# always build all
.PHONY: all

# run terraform fmt and terraform-docs
all:
	for m in $(modules); do \
		terraform fmt $$m; \
		terraform-docs md $$m --output-file README.md; \
	done

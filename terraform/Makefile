SHELL := /bin/bash

# Defaults (override on the command line)
ENVIRONMENT ?= poc
ACTION ?= create

TFVARS_PATH := $(CURDIR)/environment/$(ENVIRONMENT).tfvars
ENV_FILE := $(CURDIR)/../.env

# --- Help Target ---
GREY := $(shell tput setaf 8)
GREEN_BOLD := $(shell tput setaf 2; tput bold)
RESET := $(shell tput sgr0)
##@ Help
help: ## Show this help message
	@ echo "=================================="
	@ echo "Terraform Makefile for Databricks POC"
	@ echo "=================================="
	@ echo "Usage: make [target]"
	@ echo 
	@ echo "Available targets:"
	@awk 'BEGIN {FS = ":.*##";} \
	/^[a-zA-Z_-]+:.*##/ { printf "  ${GREY}%-40s${RESET} %s\n", $$1, $$2 } \
	/^##@/ { printf "\n${GREEN_BOLD}%-40s${RESET}\n", substr($$0, 5) }' \
	$(MAKEFILE_LIST)

# -- Targets ---
##@ Terraform Operations
.ONESHELL:
init:  ## Initialize Terraform
	. $(ENV_FILE)
	echo "Initializing Terraform .."
	if [[ -f "./local.azurerm.tfbackend" ]]; then \
	  echo "Using local.azurerm.tfbackend for backend configuration."; \
	  terraform init -backend-config="./local.azurerm.tfbackend"; \
	else \
	  echo "No local.azurerm.tfbackend found. Using default backend."; \
	  terraform init; \
	fi

.ONESHELL:
validate: init ## Validate Terraform configuration
	. $(ENV_FILE)	
	echo "Validating Terraform configuration..." && \
	terraform validate

.ONESHELL:
plan: init ## Generate a Terraform plan (create or destroy)
	@test -f $(TFVARS_PATH) || (echo "Var-file $(TFVARS_PATH) not found"; exit 1)
	@. $(ENV_FILE)
	@if [[ "$(ACTION)" == "create" ]]; then \
	  echo "Generating Terraform plan (create) using $(TFVARS_PATH)..."; \
	  terraform plan -var-file=$(TFVARS_PATH) -out=local.tfplan; \
	elif [[ "$(ACTION)" == "destroy" ]]; then \
	  echo "Generating Terraform plan (destroy) using $(TFVARS_PATH)..."; \
	  terraform plan -destroy -var-file=$(TFVARS_PATH) -out=local.tfplan; \
	else \
	  echo "Invalid ACTION '$(ACTION)'. Use ACTION=create or ACTION=destroy."; exit 1; \
	fi

.ONESHELL:
apply: plan ## Apply the generated plan with interactive confirmation
	. $(ENV_FILE) && \
	echo "Ready to apply plan 'local.tfplan' (action: $(ACTION))." && \
	read -p "Do you want to proceed with the action '$(ACTION)'? (y/n): " confirm; \
	if [[ "$$confirm" != "y" ]]; then \
	  echo "Action '$(ACTION)' cancelled by user."; exit 0; \
	else \
	  echo "Applying Terraform configuration..."; \
	  terraform apply local.tfplan; \
	fi

.ONESHELL:
destroy:  ## Generate a destroy plan and prompt to apply
	$(MAKE) ACTION=destroy plan
	@printf "\nNow run:\n  make ACTION=destroy apply ENVIRONMENT=%s\n" "$(ENVIRONMENT)"

.ONESHELL:
clean:  ## Cleanup generated plan and lock files
	-@rm -f local.tfplan
	-@rm -f .terraform.lock.hcl
	@echo "Cleanup complete."


.PHONY: all help init validate plan apply destroy clean
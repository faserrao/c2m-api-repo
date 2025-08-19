# === CONFIG ===

# Load local environment variables from .env if present
ifneq (,$(wildcard .env))
    include .env
    export $(shell sed 's/=.*//' .env)
endif


POSTMAN_API_NAME     			:= C2mApi

# === DIRECTORIES ===
SCRIPTS_DIR          			:= scripts
DOCS_DIR             			:= docs
OPENAPI_DIR          			:= openapi
DATA_DICT_DIR        			:= DataDictionary
POSTMAN_DIR          			:= postman
POSTMAN_GEN_DIR      			:= $(POSTMAN_DIR)/generated
POSTMAN_CUSTOM_DIR   			:= $(POSTMAN_DIR)/custom
TEMPLATES_DIR        			:= $(DOCS_DIR)/templates
PYTHON_ENV_DIR       			:= $(SCRIPTS_DIR)/python_env

# --- Files ---
EBNF_FILE            			:= $(DATA_DICT_DIR)/c2m-api-v2-dd.ebnf
MOCK_UID_FILE   					:= $(POSTMAN_DIR)/postman_mock_uid.txt
ENV_UID_FILE    					:= $(POSTMAN_DIR)/postman_env_uid.txt
COLL_UID_FILE   					:= $(POSTMAN_DIR)/postman_collection_uid.txt
POSTMAN_API_UID_FILE 			:= $(POSTMAN_DIR)/postman_api_uid.txt
POSTMAN_API_VER_FILE 			:= $(POSTMAN_DIR)/postman_api_version.txt
POSTMAN_SPEC_ID_FILE 			:= $(POSTMAN_DIR)/postman_spec_uid.txt
MOCK_URL_FILE_PRISM 			:= $(POSTMAN_DIR)/postman/mock-url-prism.txt
ENV_FILE             			:= $(POSTMAN_DIR)/mock-env.json
OVERRIDES_FILE						:= $(POSTMAN_CUSTOM_DIR)/overrides.json
POSTMAN_COLLECTION_UID_FILE := $(POSTMAN_DIR)/postman_collection_uid.txt

REPORT_HTML          			:= $(POSTMAN_DIR)/newman-report.html
PRISM_MOCK_URL      			:= $(shell cat $(MOCK_URL_FILE_PRISM) 2>/dev/null || echo "http://127.0.0.1t:$(PRISM_PORT)")

MOCK_UID        					:= $(shell cat $(MOCK_UID_FILE) 2>/dev/null || echo "")
ENV_UID         					:= $(shell cat $(ENV_UID_FILE))
COLL_UID									:= $(shell cat $(COLL_UID_FILE))


# === OPENAPI SPECS ===
MAIN_SPEC_PATH       			:= origin/main:$(OPENAPI_SPEC)
OPENAPI_SPEC         			:= $(OPENAPI_DIR)/c2m_openapi_spec_final.yaml
OPENAPI_SPEC_WITH_EXAMPLES		:= $(OPENAPI_DIR)/c2m_openapi_spec_final-with-examples.yaml
PREVIOUS_SPEC        			:= $(OPENAPI_DIR)/tmp_previous_spec.yaml

COLLECTION_RAW       			:= $(POSTMAN_GEN_DIR)/c2mapiv2-c2m-collection.json
COLLECTION_FIXED     			:= $(POSTMAN_GEN_DIR)/c2mapiv2-collection-fixed.json
COLLECTION_MERGED    			:= $(POSTMAN_GEN_DIR)/c2mapiv2-collection-merged.json
COLLECTION_TMP       			:= $(POSTMAN_GEN_DIR)/c2mapiv2-collection-tmp.json
COLLECTION_WITH_EXAMPLES 	:= $(POSTMAN_GEN_DIR)/c2mapiv2-collection-with-examples.json
COLLECTION_WITH_TESTS    	:= $(POSTMAN_GEN_DIR)/c2mapiv2-collection-with-tests.json

POSTMAN_IMPORT_DEBUG 			:= $(POSTMAN_DIR)/import-debug.json
POSTMAN_LINK_PAYLOAD 			:= $(POSTMAN_DIR)/link-payload.json
POSTMAN_LINK_DEBUG   			:= $(POSTMAN_DIR)/link-debug.json
POSTMAN_VERSION_PAYLOAD 	:= $(POSTMAN_DIR)/version-payload.json
POSTMAN_VERSION_DEBUG   	:= $(POSTMAN_DIR)/version-debug.json
POSTMAN_SCHEMA_UID_FILE 	:= $(POSTMAN_DIR)/schema_uid.txt

# === SCRIPTS ===
ADD_EXAMPLES_TO_OPENAPI_SPEC := $(SCRIPTS_DIR)/test_data_genertor_for_openapi_specs/add_examples_to_spec.py $(OPEN_API_SPEC)
MERGER               			:= node $(SCRIPTS_DIR)/merge-postman.js
FIX_PATHS_SCRIPT     			:= $(SCRIPTS_DIR)/fix_paths.jq
MERGE_SCRIPT         			:= $(SCRIPTS_DIR)/merge.jq
ADD_TESTS_SCRIPT     			:= $(SCRIPTS_DIR)/add_tests.jq
URL_HARDFIX_SCRIPT   			:= $(SCRIPTS_DIR)/url_hardfix.jq
EBNF_TO_OPENAPI_SCRIPT    := $(SCRIPTS_DIR)/ebnf_to_openapi_class_based.py

# === PYTHON VIRTUAL ENVIRONMENT ===
VENV_DIR             								:= $(PYTHON_ENV_DIR)/e2o.venv
VENV_PIP             								:= $(VENV_DIR)/bin/pip
VENV_PYTHON          								:= $(VENV_DIR)/bin/python
PYTHON3              								:= python3
INSTAALL_PYTHON_MODULES							:= install -r $(SCRIPTS_DIR)/python_env/requirements.txt
ADD_EXAMPLES_TO_COLLECTION_SCRIPT 	:= node $(SCRIPTS_DIR)/test_data_generator_for_collections/addRandomDataToRaw.js
ADD_EXAMPLES_TO_COLLECTION_ARGS 		:= --input  $(COLLECTION_RAW) --output $(COLLECTION_WITH_EXAMPLES) 
ADD_EXAMPLES_TO_COLLECTION					:= $(ADD_EXAMPLES_TO_COLLECTION_SCRIPT) $(ADD_EXAMPLES_TO_COLLECTION_ARGS)

PRISM_PORT   := 4010
BASE_URL_RAW 				 			:= $(shell [ -f $(ENV_FILE) ] && jq -r '.environment.values[] | select(.key=="baseUrl") | .value' $(ENV_FILE))
BASE_URL             			:= $(if $(BASE_URL_RAW),$(BASE_URL_RAW),https://mock.api)
MOCK_URL_FILE_POSTMAN 		:= $(POSTMAN_DIR)/mock_url.txt
MOCK_URL_FILE_PRISM  			:= $(POSTMAN_DIR)/prism_mock_url.txt
POSTMAN_MOCK_URL     			:= $(shell cat $(MOCK_URL_FILE_POSTMAN) 2>/dev/null || echo "https://mock.api")
PRISM_MOCK_URL       			:= $(shell cat $(MOCK_URL_FILE_PRISM)   2>/dev/null || echo "http://127.0.0.1:$(PRISM_PORT)")

# === TOOLS ===
GENERATOR_OFFICIAL   			:= npx openapi-to-postmanv2
PRISM                			:= npx @stoplight/prism-cli
NEWMAN               			:= npx newman
REDOCLY              			:= npx @redocly/cli
SPECTRAL             			:= npx @stoplight/spectral-cli
SWAGGER              			:= npx swagger-cli
WIDDERSHINS          			:= npx widdershins

# === Postman Workspaces ===
SERRAO_WS           			:= d8a1f479-a2aa-4471-869e-b12feea0a98c
C2M_WS										:= c740f0f4-0de2-4db3-8ab6-f8a0fa6fbeb1
POSTMAN_WS           			:= $(SERRAO_WS)

# Postman API Keys
POSTMAN_API_KEY      			:= $(POSTMAN_SERRAO_API_KEY)
# POSTMAN_API_KEY      		:= $(POSTMAN_C2M_API_KEY)

# === TOKENS ===
TOKEN_RAW 					 			:= $(shell [ -f $(ENV_FILE) ] && jq -r '.environment.values[] | select(.key=="token") | .value' $(ENV_FILE))
TOKEN                			:= $(if $(TOKEN_RAW),$(TOKEN_RAW),dummy-token)
TOKEN               			:= dummy-token


# --- Install and Validate ---
.PHONEY: postman-dd-to-openapi
postman-dd-to-openapi:
	$(MAKE) install
	$(MAKE) generate-openapi-spec-from-dd
	$(MAKE) lint


# --- Full Build Pipeline for Postman Collection and Testing ---
.PHONY: postman-collection-build-and-test
postman-collection-build-and-test:
	@echo "🚀 Starting Postman build and test..."

# --- Generate and Upload Collection (A) ---
	$(MAKE) postman-login
	$(MAKE) postman-api-import
	$(MAKE) postman-api-linked-collection-generate
	$(MAKE) postman-collection-upload
	$(MAKE) postman-collection-link

# ---	First-time publish (clean slate)
	$(MAKE) postman-api-full-publish

# --- Prepare Testing Collection (B) ---
	$(MAKE) postman-testing-collection-generate
	$(MAKE) postman-collection-add-examples || echo "⚠️  Skipping examples (optional step)."
	$(MAKE) postman-collection-merge-overrides
	$(MAKE) postman-collection-add-tests || echo "⚠️  Skipping adding tests (optional step)."


#	$(MAKE) postman-collection-url-hardfix
#	$(MAKE) postman-collection-repair-urls
#	$(MAKE) postman-collection-patch


	$(MAKE) postman-collection-auto-fix
	$(MAKE) postman-collection-fix-v2
	$(MAKE) postman-collection-validate

	$(MAKE) verify-urls
	$(MAKE) fix-urls
	$(MAKE) postman-collection-validate

	$(MAKE) postman-collection-upload-test

# --- Mock Server Creation and Environment (C) ---
	$(MAKE) postman-mock-create
	$(MAKE) postman-env-create
	$(MAKE) postman-env-upload
	$(MAKE) update-mock-env 
#	$(MAKE) postman-link-env-to-collection

# --- Run Tests (D) ---
	$(MAKE) prism-start
	$(MAKE) postman-mock

# --- Documentation Build ---
	$(MAKE) docs-build
	$(MAKE) docs

env-and-mock:
	$(MAKE) postman-mock-create
	$(MAKE) postman-env-create
	$(MAKE) postman-env-upload
	$(MAKE) update-mock-env 

	@echo "✅ Postman collection build and test completed: $(COLLECTION_MERGED)"


# --- Run Postman and Prism Tests ---
.PHONY: run-postman-and-prism-tests
run-postman-and-prism-tests:
	$(MAKE) prism-start
	$(MAKE) prism-mock-test
	$(MAKE) postman-mock


# Update existing spec with latest c2m_openapi_spec_final.yaml:
#	$(MAKE) postman-api-update

# List specs (for debugging)
# $(make) postman-api-list-specs

# Delete all but the most recent spec:
# $(MAKE) postman-api-delete-old-specs

# Debug workspace & API key:
# $(MAKE) postman-api-debug-B


# ============================
#         INSTALLATION
# ============================

.PHONY: postman-apis
postman-apis: ## List all Postman APIs
	@echo "Fetching APIs using POSTMAN_API_KEY..."
	curl --silent --location \
	--header "X-Api-Key: $(POSTMAN_API_KEY)" \
	"https://api.getpostman.com/apis" | jq .

check-mock:
	echo $(PRISM_MOCK_URL)

.PHONY: install
install:
	brew install openapi-diff || echo "✅ openapi-diff already installed or handled"
	npm install \
	openapi-to-postmanv2 \
	@redocly/cli \
	@stoplight/spectral-cli \
	@stoplight/prism-cli \
	newman newman-reporter-html \
	swagger-ui-dist \
	swagger-cli widdershins lodash || echo "✅ npm packages installed or already available"


# --- Make sure to use constants for all hardcoded file and dir names. ---
# --- Generate Docs. ---
# --- Modify Collection to include Examples/Test Data ---
# --- Generate SDKs ---
# --- Naming Conventions ---
# --- Check the diff command for naming and constant names ---
# --- --data-binary @- | jq -r '.collection.uid'); \ ????


.PHONY: generate-openapi-spec-from-dd
generate-openapi-spec-from-dd:
	@echo "📤 Converting the EBNF Data Dictionary to an OpenAPI YAML Specification."

	# --- Validate required files and script ---
	@if [ ! -f $(EBNF_TO_OPENAPI_SCRIPT) ]; then \
		echo "❌ Script not found: $(EBNF_TO_OPENAPI_SCRIPT)"; exit 1; \
	fi
	@if [ ! -f $(EBNF_FILE) ]; then \
		echo "❌ EBNF Data Dictionary not found: $(EBNF_FILE)"; exit 1; \
	fi

	# --- Install Python dependencies ---
	@echo "📤 Installing required Python modules..."
	$(VENV_PIP) $(INSTAALL_PYTHON_MODULES)

	# --- Run the conversion script ---
	@echo "📤 Running Conversion Script: $(EBNF_TO_OPENAPI_SCRIPT) on $(EBNF_FILE) outputting: $(OPENAPI_SPEC)"
	$(VENV_PYTHON) $(EBNF_TO_OPENAPI_SCRIPT) -o $(OPENAPI_SPEC) $(EBNF_FILE) 


#============================
#         OPENAPI
# ============================

.PHONY: lint
lint:
	$(REDOCLY) lint $(OPENAPI_SPEC)
	$(SPECTRAL) lint $(OPENAPI_SPEC)


.PHONY: diff
diff:
	@echo "📤 Fetching latest from origin/main…"
	git fetch origin
	@echo "🧾 Checking out previous version of spec for diff comparison…"
	git show $(MAIN_SPEC_PATH) > $(PREVIOUS_SPEC)
	@echo "🔍 Running openapi-diff…"
	openapi-diff $(PREVIOUS_SPEC) $(OPENAPI_SPEC) --fail-on-incompatible


.PHONY: clean-diff
clean-diff:
	rm -f $(PREVIOUS_SPEC)

# ============================
#        POSTMAN TASKS
# ============================


# --- LOGIN ---
.PHONY: postman-login
postman-login:
	@echo "🔐 Logging in to Postman..."
	@postman login --with-api-key $(POSTMAN_API_KEY)


# --- Fix PyYAML installation ---
.PHONY: fix-yaml
fix-yaml:
	@echo "🔧 Fixing PyYAML installation..."
	@echo "🧹 Removing any rogue 'yaml' package..."
	@$(VENV_PIP) uninstall -y yaml || true
	@echo "📦 Force reinstalling PyYAML..."
	@$(VENV_PIP) install --force-reinstall PyYAML
	@echo "🔍 Verifying PyYAML installation..."
	@$(VENV_PYTHON) -c "import yaml; print('✅ PyYAML import successful:', yaml.__version__)"


# --- Import OpenAPI definition into Postman ---
.PHONY: postman-api-import
postman-api-import:
	@echo "📥 Importing OpenAPI definition $(OPENAPI_SPEC) into Postman workspace $(POSTMAN_WS)..."
	@API_RESPONSE=$$(curl --location --request POST "https://api.getpostman.com/apis?workspaceId=$(POSTMAN_WS)" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		--header "Authorization: Bearer $(POSTMAN_API_KEY)" \
		--header "Accept: application/vnd.api.v10+json" \
		--header "Content-Type: application/json" \
		--data "$$(jq -Rs --arg name '$(POSTMAN_API_NAME)' '{ name: $$name, schema: { type: "openapi3", language: "yaml", schema: . }}' $(OPENAPI_SPEC))"); \
		echo "$$API_RESPONSE" | jq . > postman/import-debug.json || echo "$$API_RESPONSE" > postman/import-debug.json; \
		API_ID=$$(echo "$$API_RESPONSE" | jq -r '.id // empty'); \
		if [ -z "$$API_ID" ]; then \
			echo "❌ Failed to import API. Check postman/import-debug.json for details."; \
			exit 1; \
		else \
			echo "✅ Imported API with ID: $$API_ID"; \
			echo "$$API_ID" > $(POSTMAN_API_UID_FILE); \
			echo "📄 API ID saved to $(POSTMAN_API_UID_FILE)"; \
		fi


.PHONY: postman-api-full-publish
postman-api-full-publish:
	@echo "🚀 Starting full Postman Spec publish..."
	@SPECS=$$(curl --silent \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		"https://api.getpostman.com/specs?workspaceId=$(POSTMAN_WS)" \
		| jq -r '.data[].id'); \
	if [ -n "$$SPECS" ]; then \
		echo "🧹 Deleting all existing specs in workspace $(POSTMAN_WS)..."; \
		for ID in $$SPECS; do \
			echo "   ➡️ Deleting spec $$ID..."; \
			curl --silent --location \
				--request DELETE \
				"https://api.getpostman.com/specs/$$ID" \
				--header "X-Api-Key: $(POSTMAN_API_KEY)" \
				--header "Content-Type: application/json" | jq .; \
		done; \
	else \
		echo "ℹ️ No existing specs found. Skipping deletion."; \
	fi; \
	echo "🆕 Creating a fresh Postman Spec with $(OPENAPI_SPEC)..."; \
	CONTENT=$$(jq -Rs . < $(OPENAPI_SPEC)); \
	jq -n \
		--arg name "C2M Document Submission API" \
		--arg type "OPENAPI:3.0" \
		--arg path "index.yaml" \
		--arg content "$$CONTENT" \
		'{ name: $$name, type: $$type, files: [ { path: $$path, content: $$content | fromjson } ] }' \
		> postman/full-publish-payload.json; \
	curl --silent \
		--location \
		--request POST \
		"https://api.getpostman.com/specs?workspaceId=$(POSTMAN_WS)" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		--header "Content-Type: application/json" \
		--data @postman/full-publish-payload.json \
		| tee postman/api-full-publish-response.json | jq .; \
	SPEC_ID=$$(jq -r '.id // empty' postman/api-full-publish-response.json); \
	if [ -z "$$SPEC_ID" ]; then \
		echo "❌ Failed to create a fresh spec. See postman/api-full-publish-response.json."; \
		exit 1; \
	else \
		echo "✅ Fresh spec created with ID: $$SPEC_ID"; \
		echo "$$SPEC_ID" > $(POSTMAN_SPEC_ID_FILE); \
	fi


.PHONY: postman-api-update
postman-api-update:
	@echo "🔄 Updating existing Postman Spec with latest $(OPENAPI_SPEC)..."
	@if [ ! -f $(POSTMAN_SPEC_ID_FILE) ]; then \
		echo "❌ Spec ID file ($(POSTMAN_SPEC_ID_FILE)) not found. Run make postman-api-full-publish first."; \
		exit 1; \
	fi; \
	SPEC_ID=$$(cat $(POSTMAN_SPEC_ID_FILE)); \
	echo "📄 Using Spec ID: $$SPEC_ID"; \
	CONTENT=$$(jq -Rs . < $(OPENAPI_SPEC)); \
	jq -n \
		--arg path "index.yaml" \
		--arg content "$$CONTENT" \
		'{ path: $$path, content: $$content | fromjson }' \
		> postman/update-payload.json; \
	curl --silent \
		--location \
		--request POST \
		"https://api.getpostman.com/specs/$$SPEC_ID/files" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		--header "Content-Type: application/json" \
		--data @postman/update-payload.json \
		| tee postman/api-update-response.json | jq .


.PHONY: postman-api-linked-collection-generate
postman-api-linked-collection-generate:
	@echo "📦 Generating Postman collection from $(OPENAPI_SPEC)..."
	$(GENERATOR_OFFICIAL) -s $(OPENAPI_SPEC) -o $(COLLECTION_RAW) -p
	@echo "🛠 Adding 'info' block to collection..."
	@jq '. as $$c | {info: {name: "C2M Collection Linked To API", schema: "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"}, item: $$c.item}' \
		$(COLLECTION_RAW) > postman/generated/c2m.collection.tmp.json
	@mv postman/generated/c2m.collection.tmp.json $(COLLECTION_RAW)
	@echo "✅ Collection generated with 'info' block at $(COLLECTION_RAW)"


# --- Upload Postman collection ---
.PHONY: postman-collection-upload
postman-collection-upload:
	@echo "📤 Uploading Postman collection $(COLLECTION_RAW) to workspace $(POSTMAN_WS)..."
	@COLL_UID=$$(jq -c '{collection: .}' $(COLLECTION_RAW) | \
		curl --silent --location --request POST "https://api.getpostman.com/collections?workspace=$(POSTMAN_WS)" \
			--header "X-Api-Key: $(POSTMAN_API_KEY)" \
			--header "Accept: application/vnd.api.v10+json" \
			--header "Content-Type: application/json" \
			--data-binary @- | jq -r '.collection.uid'); \
	if [ "$$COLL_UID" = "null" ] || [ -z "$$COLL_UID" ]; then \
		echo "❌ Failed to upload collection"; exit 1; \
	else \
		echo "✅ Collection uploaded with UID: $$COLL_UID"; \
		echo $$COLL_UID > postman/postman_collection_uid.txt; \
	fi

# --- Link collection to API version ---
.PHONY: postman-collection-link
postman-collection-link:
	@echo "🔗 Linking collection to API $(POSTMAN_API_NAME)..."
	@if [ ! -f $(POSTMAN_API_UID_FILE) ]; then \
		echo "❌ Missing API UID file: $(POSTMAN_API_UID_FILE). Run postman-api-import first."; exit 1; \
	fi
	@if [ ! -f postman/postman_collection_uid.txt ]; then \
		echo "❌ Missing collection UID file. Run postman-collection-upload first."; exit 1; \
	fi
	@API_ID=$$(cat $(POSTMAN_API_UID_FILE)); \
	COLL_UID=$$(cat postman/postman_collection_uid.txt); \
	echo "🔗 Copying and linking collection $$COLL_UID to API $$API_ID..."; \
	jq -n --arg coll "$$COLL_UID" '{operationType: "COPY_COLLECTION", data: {collectionId: $$coll}}' > postman/link-payload.json; \
	curl --location --request POST "https://api.getpostman.com/apis/$$API_ID/collections" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		--header "Authorization: Bearer $(POSTMAN_API_KEY)" \
		--header "Accept: application/vnd.api.v10+json" \
		--header "Content-Type: application/json" \
		--data-binary @postman/link-payload.json | tee postman/link-debug.json


# --- This collection will inlcude test data and Postman tests ---
.PHONY: postman-testing-collection-generate
postman-testing-collection-generate:
	@echo "📦 Generating Postman collection from $(OPENAPI_SPEC)..."
	echo "🛠 Adding 'info' block to collection..."
	@jq '. as $$c | {info: {name: "C2M Testing Collection", schema: "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"}, item: $$c.item}' \
		$(COLLECTION_RAW) > postman/generated/c2m.collection.tmp.json
	@mv postman/generated/c2m.collection.tmp.json $(COLLECTION_RAW)
	@echo "✅ Collection generated with 'info' block at $(COLLECTION_RAW)"


.PHONY: postman-collection-add-examples
postman-collection-add-examples:
	@echo "📤 Installing required Python modules..."
	@echo "🧩 Adding smart example data to Postman collection..."
	@if [ ! -f $(COLLECTION_RAW) ]; then \
		echo "⚠️  $(COLLECTION_RAW) not found. Run postman-collection-merge-overrides first."; exit 1; \
	fi
# @cp postman/generated/c2m.collection.merged.json postman/generated/c2m.collection.with.examples.json
# $(VENV_PYTHON) scripts/test_data_genertor/add_examples.py postman/generated/c2m.collection.merged.json
# cp postman/generated/c2m.collection.merged-with-examples.json postman/generated/c2m.collection.with.examples.json
	$(ADD_EXAMPLES_TO_COLLECTION)
	@echo "✅ Examples added and saved to $(COLLECTION_WITH_EXAMPLES)"


# --- Merge Overrides (Safe Deep Merge) ---
.PHONY: postman-collection-merge-overrides
postman-collection-merge-overrides:
	@echo "🔀 Safely merging overrides from $(OVERRIDES_FILE) into $(COLLECTION_WITH_EXAMPLES)..."
	@if [ ! -f $(COLLECTION_WITH_EXAMPLES) ]; then \
		echo "❌ Base collection $(COLLECTION_WITH_EXAMPLES) not found. Run postman-collection-generate first."; \
		exit 1; \
	fi
	@if [ ! -f $(OVERRIDES_FILE) ]; then \
		echo "⚠️  No override file found at $(OVERRIDES_FILE). Skipping overrides."; \
		cp $(COLLECTION_RAW) $(COLLECTION_MERGED); \
		echo "✅ No overrides applied. Copied $(COLLECTION_RAW) to $(COLLECTION_MERGED)"; \
		exit 0; \
	fi
	@jq -s -f scripts/merge.jq $(COLLECTION_WITH_EXAMPLES) $(OVERRIDES_FILE) > $(COLLECTION_MERGED)
	@echo "✅ Safe deep merge completed. Output written to $(COLLECTION_MERGED)"


PHONY: postman-collection-add-tests
postman-collection-add-tests:
	@echo "🧪 Adding default Postman tests to collection with examples..."
	@if [ ! -f $(COLLECTION_MERGED) ]; then \
		echo "⚠️  $(COLLECTION_MERGED) not found. Run postman-collection-add-examples first."; exit 1; \
	fi
	@jq \
	    --arg test1 'pm.test("Status code is 200", function () { pm.response.to.have.status(200); });' \
	    --arg test2 'pm.test("Response time < 1s", function () { pm.expect(pm.response.responseTime).to.be.below(1000); });' \
	    -f scripts/add_tests.jq \
	    $(COLLECTION_MERGED) > $(COLLECTION_WITH_TESTS)
	@echo "✅ Tests added to $(COLLECTION_WITH_TESTS)"


# --- Auto-fix invalid collection items ---
.PHONY: postman-collection-auto-fix
postman-collection-auto-fix:
	@echo "🛠 Auto-fixing invalid items in $(COLLECTION_WITH_TESTS)..."
	@if [ ! -f $(COLLECTION_WITH_TESTS) ]; then \
		echo "❌ Collection file not found: $(COLLECTION_WITH_TESTS)"; \
		exit 1; \
	fi
	@jq 'walk( \
		if type == "object" and (has("name") and (has("request") | not) and (has("item") | not)) \
		then . + { "item": [] } \
		else . \
		end \
	)' $(COLLECTION_WITH_TESTS) > $(COLLECTION_FIXED)
	@echo "✅ Auto-fix complete. Fixed collection saved to $(COLLECTION_FIXED)"
	@echo "🔍 Validating fixed collection..."
	@node -e "const {Collection}=require('postman-collection'); \
		const fs=require('fs'); \
		const data=JSON.parse(fs.readFileSync('$(COLLECTION_FIXED)','utf8')); \
		try { new Collection(data); console.log('✅ Collection is valid.'); } \
		catch(e) { console.error('❌ Validation failed:', e.message); process.exit(1); }"


.PHONY: postman-collection-fix
postman-collection-fix:
	@echo "🔧 Fixing Postman collection URLs..."
	@python3 scripts/fix_collection_urls.py $(COLLECTION_FIXED) $(COLLECTION_FIXED)
	@echo "🎉 Collection fixed: $(COLLECTION_FIXED)"


.PHONY: postman-collection-fix-v2
postman-collection-fix-v2:
	@echo "🔧 Fixing collection URLs (v2) in $(COLLECTION_FIXED)..."
	@python3 scripts/fix_collection_urls_v2.py $(COLLECTION_FIXED) $(COLLECTION_FIXED)
	@echo "✅ Collection URLs fixed: $(COLLECTION_FIXED)"


.PHONY: postman-collection-url-hardfix
postman-collection-url-hardfix:
	@echo "🔧 Applying combined path + URL hard fix..."
		jq -f scripts/url_hardfix_with_paths.jq $(COLLECTION_FIXED) > $(COLLECTION_FIXED).tmp \
			&& mv $(COLLECTION_FIXED).tmp $(COLLECTION_FIXED)
		@echo "✅ Combined path and URL hard fix applied: $(COLLECTION_FIXED)"


.PHONY: postman-collection-repair-urls
postman-collection-repair-urls:
	@echo "🔧 Repairing URLs based on folder hierarchy..."
		python3 scripts/repair_urls.py $(COLLECTION_FIXED)
 		@echo "✅ Folder-based URL repair complete: $(COLLECTION_FIXED)"


verify-urls:
	@echo "🔍 Verifying URLs in $(COLLECTION_FIXED)..."
	@jq -r '.. | objects | select(has("url")) | .url.raw? // empty' $(COLLECTION_FIXED)


fix-urls:
	@echo "🔧 Fixing URLs in $(COLLECTION_FIXED)..."
	@jq 'walk(if type == "object" and has("url") and (.url | type) == "object" and .url.raw then .url.raw |= sub("http://localhost"; "{{baseUrl}}") else . end)' \
		$(COLLECTION_FIXED) > $(COLLECTION_FIXED).tmp
	@mv $(COLLECTION_FIXED).tmp $(COLLECTION_FIXED)


.PHONY: postman-collection-validate
postman-collection-validate:
	@echo "🔍 Validating Postman collection $(COLLECTION_FIXED)..."
	@node -e "const { Collection } = require('postman-collection'); \
	const fs = require('fs'); \
	const file = '$(COLLECTION_FIXED)'; \
	const data = JSON.parse(fs.readFileSync(file, 'utf8')); \
	new Collection(data); \
	console.log('✅ Collection', file, 'is valid.');"


.PHONY: postman-collection-upload-test
postman-collection-upload-test:
	@echo "===== DEBUG: Postman Collection Upload Test Variables ====="
	@echo "POSTMAN_API_KEY: $(POSTMAN_API_KEY)"
	@echo "POSTMAN_WS: $(POSTMAN_WS)"
	@echo "COLLECTION_FIXED: $(COLLECTION_FIXED)"
	@echo "==========================================================="
	@if [ ! -f $(COLLECTION_FIXED) ]; then \
		echo "⚠️  $(COLLECTION_FIXED) not found. Run postman-collection-auto-fix first."; exit 1; \
	fi
	@echo "📦 Using collection: $(COLLECTION_FIXED)"
	@RESPONSE=$$(jq -c '{collection: .}' $(COLLECTION_FIXED) | \
		curl --silent --location --request POST "https://api.getpostman.com/collections?workspace=$(POSTMAN_WS)" \
			--header "X-Api-Key: $(POSTMAN_API_KEY)" \
			--header "Accept: application/vnd.api.v10+json" \
			--header "Content-Type: application/json" \
			--data-binary @-); \
		echo "$$RESPONSE" | jq . > postman/upload-test-debug.json || echo "$$RESPONSE" > postman/upload-test-debug.json; \
		COLL_UID=$$(echo "$$RESPONSE" | jq -r '.collection.uid // empty'); \
		if [ -z "$$COLL_UID" ] || [ "$$COLL_UID" = "null" ]; then \
			echo "❌ Failed to upload test collection. Check postman/upload-test-debug.json for details."; \
			exit 1; \
		else \
			echo "✅ TEST Collection uploaded with UID: $$COLL_UID"; \
			echo $$COLL_UID > postman/postman_test_collection_uid.txt; \
			echo "📄 UID saved to postman/postman_test_collection_uid.txt"; \
		fi


sync-mock:
	@echo "🔍 Checking for existing mock UID..."
	@if [ -z "$(MOCK_UID)" ]; then \
		echo "⚠️  No mock UID found. Creating a new mock..."; \
		curl --silent --location --request POST "https://api.getpostman.com/mocks" \
			--header "x-api-key: $(API_KEY)" \
			--header "Content-Type: application/json" \
			--data-raw '{"mock": { "name": "Auto Mock", "collection": "$(COLL_UID)", "environment": "$(ENV_UID)", "private": false }}' \
			| jq -r '.mock.uid' > $(MOCK_UID_FILE); \
		echo "✅ Mock created. UID saved to $(MOCK_UID_FILE)."; \
	else \
		echo "✅ Found existing mock UID: $(MOCK_UID)."; \
	fi
	@echo "🔄 Updating Postman mock server environment..."
	curl --location --request PUT "https://api.getpostman.com/mocks/$(shell cat $(MOCK_UID_FILE))" \
		--header "x-api-key: $(API_KEY)" \
		--header "Content-Type: application/json" \
		--data-raw "{\"mock\": { \
			\"name\": \"Auto Mock\", \
			\"collection\": \"$(COLL_UID)\", \
			\"environment\": \"$(ENV_UID)\", \
			\"description\": \"Mock server updated via Makefile sync-mock.\", \


.PHONY: postman-env-create
postman-env-create:
	@echo "🧪 Generating Postman environment file …"
	@if [ ! -f $(MOCK_URL_FILE_POSTMAN) ]; then \
	    echo '⚠️ mock_url.txt missing. Cannot proceed.'; \
	    exit 1; \
	fi
	@POSTMAN_MOCK_URL=$$(cat $(MOCK_URL_FILE_POSTMAN)); \
	echo "Using mock URL: $$POSTMAN_MOCK_URL"; \
	jq -n --arg baseUrl "$$POSTMAN_MOCK_URL" --arg token "$(TOKEN)" \
		'{"environment": {"id":"c2m-env-id","name":"C2mApiV2Env","values":[{"key":"baseUrl","value":$$baseUrl,"enabled":true},{"key":"token","value":$$token,"enabled":true}],"_type":"environment"}}' \
		> $(ENV_FILE); \
	echo "✅ Wrote $(ENV_FILE) with baseUrl=$$POSTMAN_MOCK_URL"


# --- Upload environment file to Postman ---
.PHONY: postman-env-upload
postman-env-upload:
	@echo "📤 Uploading Postman environment file to workspace $(POSTMAN_WS)..."
	@RESPONSE=$$(curl --silent --location --request POST "https://api.getpostman.com/environments?workspace=$(POSTMAN_WS)" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		--header 'Content-Type: application/json' \
		--data-binary '@$(ENV_FILE)'); \
	echo "$$RESPONSE" | jq . > postman/env-upload-debug.json || echo "$$RESPONSE" > postman/env-upload-debug.json; \
	ENV_UID=$$(echo "$$RESPONSE" | jq -r '.environment.uid // empty'); \
	if [ -z "$$ENV_UID" ]; then \
		echo "❌ Failed to upload environment. Check postman/env-upload-debug.json for details."; \
		exit 1; \
	else \
		echo "✅ Environment uploaded with UID: $$ENV_UID"; \
		echo $$ENV_UID > postman/postman_env_uid.txt; \
	fi


update-mock-env:
	@echo "🔄 Updating Postman mock server environment..."
	curl --location --request PUT "https://api.getpostman.com/mocks/$(MOCK_ID)" \
		--header "x-api-key: $(API_KEY)" \
		--header "Content-Type: application/json" \
		--data-raw "{\"mock\": { \
			\"name\": \"C2M API Mock - Test Collection\", \
			\"collection\": \"$(COLL_UID)\", \
			\"environment\": \"$(ENV_UID)\", \
			\"description\": \"Mock server environment updated via Makefile.\", \
			\"private\": false \
		}}"
	@echo "✅ Mock server environment updated."


verify-mock:
	@echo "🔍 Fetching mock server details..."
	@curl --silent --location --request GET "https://api.getpostman.com/mocks/$(MOCK_UID)" \
		--header "x-api-key: $(API_KEY)" \
		| jq '{ \
			mockUrl: .mock.mockUrl, \
			name: .mock.name, \
			collection: .mock.collection, \
			environment: .mock.environment, \
			private: .mock.private, \
			updatedAt: .mock.updatedAt \
		}'


# === START PRISM ===
.PHONY: prism-start
prism-start:
	@echo "🚀 Starting Prism mock server on port $(PRISM_PORT)..."
	@echo "http://127.0.0.1:$(PRISM_PORT)" > $(MOCK_URL_FILE_PRISM)
	@nohup npx @stoplight/prism-cli mock $(OPENAPI_SPEC_WITH_EXAMPLES) -p $(PRISM_PORT) > prism.log 2>&1 &
	@echo $$! > prism.pid
	@sleep 2
	@if lsof -i :$(PRISM_PORT) -t >/dev/null; then \
		echo "✅ Prism started at $(PRISM_MOCK_URL)"; \
	else \
		echo "❌ Failed to start Prism."; \
		exit 1; \
	fi


# === STOP PRISM ===
.PHONY: prism-stop
prism-stop:
	@if [ -f prism.pid ]; then \
		kill -9 `cat prism.pid` || true; \
		rm -f prism.pid $(MOCK_URL_FILE_PRISM); \
		echo "🛑 Prism stopped."; \
	else \
		echo "ℹ️  No Prism instance running."; \
	fi


# === RUN TESTS (Requires Prism Already Running) ===
.PHONY: prism-mock-test
prism-mock-test:
	@echo "🔬 Running Newman tests against Prism mock..."
	@if [ ! -f $(COLLECTION_FIXED) ]; then \
		echo "❌ Missing Postman collection: $(COLLECTION_FIXED)"; \
		exit 1; \
	fi
	@if ! lsof -i :$(PRISM_PORT) -t >/dev/null; then \
		echo "❌ Prism is not running on port $(PRISM_PORT). Start it with 'make prism-start'."; \
		exit 1; \
	fi
	$(NEWMAN) run $(COLLECTION_FIXED) \
		--env-var baseUrl=$(PRISM_MOCK_URL) \
		--env-var token=$(TOKEN) \
		--reporters cli,html \
		--reporter-html-export $(REPORT_HTML)
	@echo "📄 Newman test report generated at $(REPORT_HTML)"


# --- Sanitize Postman Collection: Replace <string>, <integer>, etc. with valid example values ---
.PHONY: postman-collection-fix-examples
postman-collection-fix-examples:
	@echo "🧹 Sanitizing Postman collection by replacing placeholder values..."
	@mkdir -p scripts
	@if [ ! -f scripts/sanitize_collection.jq ]; then \
		echo "📄 Creating scripts/sanitize_collection.jq..."; \
		cat <<'EOF' > scripts/sanitize_collection.jq; \
walk( \
  if type == "string" then \
    gsub("<string>"; "example") \
    | gsub("<integer>"; "123") \
    | gsub("<number>"; "1.23") \
    | gsub("<boolean>"; "true") \
  else . \
  end \
) \
EOF \
	; fi
	jq -f scripts/sanitize_collection.jq postman/generated/c2m.collection.with.examples.json > postman/generated/c2m.collection.fixed.json
	@echo "✅ Sanitized collection saved to postman/generated/c2m.collection.fixed.json"


.PHONY: postman-mock-create
postman-mock-create:
	@echo "🛠 Creating Postman mock server for collection..."
	@if [ ! -f postman/postman_test_collection_uid.txt ]; then \
		echo "❌ Missing test collection UID file: postman/postman_test_collection_uid.txt. Run postman-collection-upload-test first."; \
		exit 1; \
	fi; \
	COLL_UID=$$(cat postman/postman_test_collection_uid.txt); \
	MOCK_NAME="C2M API Mock - Test Collection"; \
	jq -n --arg coll "$$COLL_UID" --arg name "$$MOCK_NAME" \
		'{ mock: { collection: $$coll, name: $$name, private: false } }' \
		> postman/mock-payload.json; \
	echo "📤 Creating mock server via Postman API..."; \
	curl --silent --location --request POST "https://api.getpostman.com/mocks" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		--header "Accept: application/vnd.api.v10+json" \
		--header "Content-Type: application/json" \
		--data-binary @postman/mock-payload.json \
		-o postman/mock-debug.json; \
	if ! jq -e '.mock.mockUrl' postman/mock-debug.json >/dev/null; then \
		echo "❌ Failed to create mock server. See postman/mock-debug.json"; \
		exit 1; \
	fi; \
	POSTMAN_MOCK_URL=$$(jq -r '.mock.mockUrl' postman/mock-debug.json); \
	MOCK_UID=$$(jq -r '.mock.uid' postman/mock-debug.json | sed 's/^[^-]*-//'); \
	echo "✅ Mock server created at: $$POSTMAN_MOCK_URL"; \
	echo "📄 Saving mock URL and UID..."; \
	echo "$$POSTMAN_MOCK_URL" > $(MOCK_URL_FILE_POSTMAN); \
	echo "$$MOCK_UID" > postman/postman_mock_uid.txt; \
	echo "📄 Mock server URL saved to $(MOCK_URL_FILE_POSTMAN)"; \
	echo "📄 Mock UID saved to postman/postman_mock_uid.txt"; \
	echo "🔍 Validating mock configuration..."; \
	curl --silent --location --request GET "https://api.getpostman.com/mocks/$$MOCK_UID" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		-o postman/mock-validate.json; \
	if jq -e '.error' postman/mock-validate.json >/dev/null; then \
		echo "❌ Postman mock validation failed. See postman/mock-validate.json"; \
		exit 1; \
	else \
		echo "✅ Postman mock validated successfully."; \
	fi


.PHONY: postman-mock
postman-mock:
	@echo "🔬 Running Newman tests against Postman mock..."
	@if [ ! -f $(MOCK_URL_FILE_POSTMAN) ]; then \
		echo "ℹ️  Postman mock URL not found. Creating Postman mock..."; \
		$(MAKE) postman-mock-create; \
	fi
	@if [ ! -f $(COLLECTION_FIXED) ]; then \
		echo "❌ Missing Postman collection: $(COLLECTION_FIXED)"; \
		exit 1; \
	fi
	$(NEWMAN) run $(COLLECTION_FIXED) \
		--env-var baseUrl=$(POSTMAN_MOCK_URL) \
		--env-var token=$(TOKEN) \
		--reporters cli,html \
		--reporter-html-export $(REPORT_HTML)
	@echo "📄 Newman test report generated at $(REPORT_HTML)"




.PHONY: postman-link-env-to-collection
postman-link-env-to-collection:
	@echo "🔗 Linking environment to collection and mock server..."
	@if [ ! -f postman/postman_env_uid.txt ]; then \
		echo "❌ Missing environment UID file: postman/postman_env_uid.txt. Run postman-env-upload first."; \
		exit 1; \
	fi
	@if [ ! -f postman/postman_test_collection_uid.txt ]; then \
		echo "❌ Missing test collection UID file: postman/postman_test_collection_uid.txt. Run postman-collection-upload-test first."; \
		exit 1; \
	fi
	@if [ ! -f postman/postman_mock_uid.txt ]; then \
		echo "❌ Missing mock UID file: postman/postman_mock_uid.txt. Run postman-mock-create first."; \
		exit 1; \
	fi
	ENV_UID=$$(cat postman/postman_env_uid.txt); \
	COLL_UID=$$(cat postman/postman_test_collection_uid.txt); \
	MOCK_UID=$$(cat postman/postman_mock_uid.txt); \
	echo "📦 Linking Environment $$ENV_UID with Collection $$COLL_UID (Mock $$MOCK_UID)..."; \
	curl --silent --location --request PUT "https://api.getpostman.com/mocks/$$MOCK_UID" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		--header "Content-Type: application/json" \
		--data-raw "$$(jq -n --arg coll $$COLL_UID --arg env $$ENV_UID '{ mock: { name: "Linked Mock Server", collection: $$coll, environment: $$env, private: false } }')" \
		-o postman/mock-link-debug.json; \
	if jq -e '.mock' postman/mock-link-debug.json >/dev/null; then \
		echo "✅ Environment linked to mock server successfully."; \
	else \
		echo "❌ Failed to link environment. See postman/mock-link-debug.json"; \
		exit 1; \
	fi


# === DOCUMENTATION TARGETS ===
.PHONY: docs-build
docs-build:
	@echo "📚 Building API documentation with Redoc..."
	npx @redocly/cli build-docs $(OPENAPI_SPEC) -o $(DOCS_DIR)/index.html
	npx swagger-cli bundle $(OPENAPI_SPEC) --outfile openapi/bundled.yaml --type yaml


.PHONY: docs-serve
docs-serve:
	@echo "🌐 Serving API documentation locally on http://localhost:8080..."
	python3 -m http.server 8080 --directory $(DOCS_DIR)


.PHONY: postman-api-list-specs
postman-api-list-specs:
	@echo "📜 Listing all specs in workspace $(POSTMAN_WS)..."
	@curl --silent \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		"https://api.getpostman.com/specs?workspaceId=$(POSTMAN_WS)" \
		| jq -r '.data[] | "\(.name)\t\(.id)\t\(.type)\t\(.updatedAt)"' \
		| column -t -s$$'\t'


.PHONY: postman-api-delete-old-specs
postman-api-delete-old-specs:
	@echo "🧹 Deleting old specs in workspace $(POSTMAN_WS), keeping the most recent one..."
	@SPECS=$$(curl --silent \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		"https://api.getpostman.com/specs?workspaceId=$(POSTMAN_WS)" \
		| jq -r '.data | sort_by(.updatedAt) | reverse | .[1:] | .[].id'); \
	for ID in $$SPECS; do \
		echo "   ➡️ Deleting spec $$ID..."; \
		curl --silent --location \
			--request DELETE \
			"https://api.getpostman.com/specs/$$ID" \
			--header "X-Api-Key: $(POSTMAN_API_KEY)" \
			--header "Content-Type: application/json" | jq .; \
	done; \
	if [ -z "$$SPECS" ]; then \
		echo "   No old specs to delete."; \
	else \
		echo "   ✅ Old specs deleted."; \
	fi


.PHONY: postman-cleanup
postman-cleanup:
	@echo "🧹 Starting full cleanup of Postman resources..."

	# --- Delete Mock Server ---
	@if [ -f postman/postman_mock_uid.txt ]; then \
		MOCK_UID=$$(cat postman/postman_mock_uid.txt); \
		echo "🗑 Deleting Mock Server: $$MOCK_UID..."; \
		curl --silent --location --request DELETE "https://api.getpostman.com/mocks/$$MOCK_UID" \
			--header "X-Api-Key: $(POSTMAN_API_KEY)" \
			--header "Accept: application/vnd.api.v10+json" \
			| tee postman/mock-delete-debug.json; \
		echo "✅ Mock server deleted."; \
		rm -f postman/postman_mock_uid.txt postman/mock_url.txt; \
	else \
		echo "⚠️  No mock UID found at postman/postman_mock_uid.txt"; \
	fi

	# --- Delete Environment ---
	@if [ -f postman/postman_env_uid.txt ]; then \
		ENV_UID=$$(cat postman/postman_env_uid.txt); \
		echo "🗑 Deleting Environment: $$ENV_UID..."; \
		curl --silent --location --request DELETE "https://api.getpostman.com/environments/$$ENV_UID" \
			--header "X-Api-Key: $(POSTMAN_API_KEY)" \
			--header "Accept: application/vnd.api.v10+json" \
			| tee postman/env-delete-debug.json; \
		echo "✅ Environment deleted."; \
		rm -f postman/postman_env_uid.txt postman/mock-env.json; \
	else \
		echo "⚠️  No environment UID found at postman/postman_env_uid.txt"; \
	fi

	# --- Delete Test Collection ---
	@if [ -f postman/postman_test_collection_uid.txt ]; then \
		COLL_UID=$$(cat postman/postman_test_collection_uid.txt); \
		echo "🗑 Deleting Collection: $$COLL_UID..."; \
		curl --silent --location --request DELETE "https://api.getpostman.com/collections/$$COLL_UID" \
			--header "X-Api-Key: $(POSTMAN_API_KEY)" \
			--header "Accept: application/vnd.api.v10+json" \
			| tee postman/collection-delete-debug.json; \
		echo "✅ Test collection deleted."; \
		rm -f postman/postman_test_collection_uid.txt; \
	else \
		echo "⚠️  No test collection UID found at postman/postman_test_collection_uid.txt"; \
	fi

	# --- Delete Main Collection (if exists) ---
	@if [ -f postman/postman_collection_uid.txt ]; then \
		COLL_UID=$$(cat postman/postman_collection_uid.txt); \
		echo "🗑 Deleting Main Collection: $$COLL_UID..."; \
		curl --silent --location --request DELETE "https://api.getpostman.com/collections/$$COLL_UID" \
			--header "X-Api-Key: $(POSTMAN_API_KEY)" \
			--header "Accept: application/vnd.api.v10+json" \
			| tee postman/collection-main-delete-debug.json; \
		echo "✅ Main collection deleted."; \
		rm -f postman/postman_collection_uid.txt; \
	else \
		echo "⚠️  No main collection UID found at postman/postman_collection_uid.txt"; \
	fi

	@echo "🎉 Full cleanup complete."


.PHONY: postman-cleanup-all
postman-cleanup-all:
	@echo "🧹 Starting FULL cleanup of Postman resources for workspace $(POSTMAN_WS)..."

	# --- Delete Mock Servers ---
	@echo "🔍 Fetching mock servers..."
	@MOCKS=$$(curl --silent --location --request GET "https://api.getpostman.com/mocks?workspace=$(POSTMAN_WS)" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" | jq -r '.mocks[].id'); \
	for MOCK in $$MOCKS; do \
		echo "🗑 Deleting mock server $$MOCK..."; \
		curl --silent --location --request DELETE "https://api.getpostman.com/mocks/$$MOCK" \
			--header "X-Api-Key: $(POSTMAN_API_KEY)" || echo "⚠️ Failed to delete mock server $$MOCK"; \
	done

	# --- Delete Collections ---
	@echo "🔍 Fetching collections..."
	@COLLECTIONS=$$(curl --silent --location --request GET "https://api.getpostman.com/collections?workspace=$(POSTMAN_WS)" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" | jq -r '.collections[].uid'); \
	for COL in $$COLLECTIONS; do \
		echo "🗑 Deleting collection $$COL..."; \
		curl --silent --location --request DELETE "https://api.getpostman.com/collections/$$COL" \
			--header "X-Api-Key: $(POSTMAN_API_KEY)" || echo "⚠️ Failed to delete collection $$COL"; \
	done

	# --- Delete APIs ---
	@echo "🔍 Fetching APIs..."
	@APIS=$$(curl --silent --location --request GET "https://api.getpostman.com/apis?workspace=$(POSTMAN_WS)" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" | jq -r '.apis[].id'); \
	for API in $$APIS; do \
		echo "🗑 Deleting API $$API..."; \
		curl --silent --location --request DELETE "https://api.getpostman.com/apis/$$API" \
			--header "X-Api-Key: $(POSTMAN_API_KEY)" || echo "⚠️ Failed to delete API $$API"; \
	done

	# --- Delete Environments ---
	@echo "🔍 Fetching environments..."
	@ENVS=$$(curl --silent --location --request GET "https://api.getpostman.com/environments?workspace=$(POSTMAN_WS)" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" | jq -r '.environments[].uid'); \
	for ENV in $$ENVS; do \
		echo "🗑 Deleting environment $$ENV..."; \
		curl --silent --location --request DELETE "https://api.getpostman.com/environments/$$ENV" \
			--header "X-Api-Key: $(POSTMAN_API_KEY)" || echo "⚠️ Failed to delete environment $$ENV"; \
	done

	# --- Delete Specs ---
	@echo "🔍 Fetching specs..."
	@SPECS=$$(curl --silent --location --request GET "https://api.getpostman.com/specs?workspaceId=$(POSTMAN_WS)" \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" | jq -r '.data[].id'); \
	for SPEC in $$SPECS; do \
		echo "🗑 Deleting spec $$SPEC..."; \
		curl --silent --location --request DELETE "https://api.getpostman.com/specs/$$SPEC" \
			--header "X-Api-Key: $(POSTMAN_API_KEY)" || echo "⚠️ Failed to delete spec $$SPEC"; \
	done

	@echo "✅ Postman cleanup complete for workspace $(POSTMAN_WS)."


.PHONY: postman-api-clean-trash
postman-api-clean-trash:
	@echo "🗑️ Checking for trashed specs in workspace $(POSTMAN_WS)..."
	@TRASH=$$(curl --silent \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		"https://api.getpostman.com/specs?workspaceId=$(POSTMAN_WS)&status=trashed" \
		| jq -r '.data // [] | .[].id'); \
	if [ -z "$$TRASH" ]; then \
		echo "   No trashed specs found in workspace $(POSTMAN_WS)."; \
	else \
		for ID in $$TRASH; do \
			echo "   🚮 Permanently deleting trashed spec $$ID..."; \
			curl --silent --location \
				--request DELETE \
				"https://api.getpostman.com/specs/$$ID?permanent=true" \
				--header "X-Api-Key: $(POSTMAN_API_KEY)" \
				--header "Content-Type: application/json" | jq .; \
		done; \
		echo "   ✅ All trashed specs have been permanently deleted."; \
	fi

# --- Be careful!  This will delete ALL Collections in a Worksapce.
.PHONY: postman-collections-clean
postman-collections-clean:
	@echo "🗑️ Listing all collections in workspace $(POSTMAN_WS)..."
	@COLLECTIONS=$$(curl --silent \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		"https://api.getpostman.com/collections?workspaceId=$(POSTMAN_WS)" \
		| jq -r '.collections[].uid'); \
	if [ -z "$$COLLECTIONS" ]; then \
		echo "   No collections found."; \
	else \
		for ID in $$COLLECTIONS; do \
			echo "   🚮 Deleting collection $$ID..."; \
			curl --silent --location \
				--request DELETE \
				"https://api.getpostman.com/collections/$$ID" \
				--header "X-Api-Key: $(POSTMAN_API_KEY)" | jq .; \
		done; \
		echo "   ✅ All collections deleted."; \
	fi


.PHONY: postman-api-debug-A
postman-api-debug-A:
	@echo "🐞 Debugging Postman API import..."
	curl --verbose --location --request POST "https://api.getpostman.com/apis?workspace=$(POSTMAN_WS)" \
	--header "X-Api-Key: $(POSTMAN_API_KEY)" \
	--header "Authorization: Bearer $(POSTMAN_API_KEY)" \
	--header "Accept: application/vnd.api.v10+json" \
	--header "Content-Type: application/json" \
	--data "$$(jq -Rs --arg name '$(POSTMAN_API_NAME)' '{ api: { name: $$name, schema: { type: "openapi3", language: "yaml", schema: . }}}' $(OPENAPI_SPEC))" \
	| tee postman/import-debug.json


.PHONY: postman-api-debug-B
postman-api-debug-B:
	@echo "🐞 Debugging Postman API key and workspace..."
	@echo "POSTMAN_API_KEY=$(POSTMAN_API_KEY)"
	@echo "POSTMAN_WS=$(POSTMAN_WS)"
	@echo "🔑 Verifying key..."
	@curl --silent \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		https://api.getpostman.com/me | jq .
	@echo "📂 Listing APIs in workspace $(POSTMAN_WS)..."
	@curl --silent \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		"https://api.getpostman.com/apis?workspaceId=$(POSTMAN_WS)" | jq .
	@echo "📜 Listing Specs in workspace $(POSTMAN_WS)..."
	@curl --silent \
		--header "X-Api-Key: $(POSTMAN_API_KEY)" \
		"https://api.getpostman.com/specs?workspaceId=$(POSTMAN_WS)" | jq .


.PHONY: postman-workspace-debug
postman-workspace-debug:
    @echo "🔍 Current Postman workspace ID: $(POSTMAN_WS)"


# ---------- HELP --------------------------------------
.PHONY: help
help:## Show help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

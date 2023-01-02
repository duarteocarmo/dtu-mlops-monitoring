.PHONY: install clean lint format 

## Install for production
install:
	@echo ">> Installing dependencies"
	python -m pip install --upgrade pip
	python -m pip install -e .
	python3 -m pip install -r requirements.txt

## Install for development 
install-dev: install
	python3 -m pip install -r requirements-dev.txt

## Build dependencies
build: 
	pip-compile --resolver=backtracking --output-file=requirements.txt pyproject.toml
	pip-compile --resolver=backtracking --extra=dev --output-file=requirements-dev.txt pyproject.toml

## Delete all temporary files
clean:
	rm -rf .ipynb_checkpoints
	rm -rf **/.ipynb_checkpoints
	rm -rf .pytest_cache
	rm -rf **/.pytest_cache
	rm -rf __pycache__
	rm -rf **/__pycache__
	rm -rf build
	rm -rf dist

## Lint using flake8
flake:
	flake8 src --count --statistics --max-complexity=10 --max-line-length=127 --exclude __init__.py --ignore=E501
	flake8 tests --count --statistics --max-complexity=10 --max-line-length=127 --exclude __init__.py --ignore=E501

## Format files using black
format:
	isort --profile black src/ tests/
	black -l 79 src/ tests/

## Run tests
test:
	pytest tests --log-level=WARNING --disable-pytest-warnings

## Run checks (flake + test)
check:
	flake8 --ignore=E501,W503,E203 src 
	black --check -l 79 src/ tests/

## Run api
api:
	OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4318/" OTEL_SERVICE_NAME="mlops-demo" python -m uvicorn src.api.main:app --reload

#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available commands:$$(tput sgr0)"
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')


.PHONY: README.md venv data

PYTHON_DIRS=scripts

requirements.txt: requirements.in
	pip-compile requirements.in

venv:
	python -m venv venv
	venv/bin/pip install -r requirements.txt

format:
	black $(PYTHON_DIRS)
	isort $(PYTHON_DIRS)

lint:
	black --check $(PYTHON_DIRS)
	isort --check $(PYTHON_DIRS)
	flake8 --max-line-length 88 --extend-ignore E203 $(PYTHON_DIRS)

scrape:
	python scripts/00-scrape.py

transform:
	@echo "Debugging PDF files..."
	ls -lh pdfs/ || true
	file pdfs/*.pdf || true
	head -n 20 pdfs/*.pdf || true
	wc -c pdfs/*.pdf || true
	@echo "Running parser..."
	python scripts/01-parse.py
	python scripts/02-combine.py
	python scripts/03-standardize.py
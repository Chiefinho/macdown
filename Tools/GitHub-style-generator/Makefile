# Xcode build phases don't inherit the login shell PATH; add Homebrew locations.
export PATH := /opt/homebrew/bin:/usr/local/bin:$(PATH)

SASS = node_modules/.bin/sass

target = ../../MacDown/Resources/Styles/GitHub-2020.css

all: $(target)

$(SASS): package-lock.json
	npm ci --no-audit --no-fund
	touch $@

$(target): index.sass package-lock.json $(SASS)
	$(SASS) --no-source-map --quiet-deps --load-path=node_modules $< | sed s/.markdown-body/body/ > $@

clean:
	$(RM) $(target)

.PHONY: all clean

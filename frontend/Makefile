all: dist dist/app.js dist/favicon.ico dist/loading_wheel.gif dist/interop.js dist/index.html dist/vendor dist/style.css bootstrap less

bootstrap: dist/bootstrap-3.3.4/css/bootstrap-theme.css dist/bootstrap-3.3.4/css/bootstrap-theme.min.css dist/bootstrap-3.3.4/css/bootstrap.css dist/bootstrap-3.3.4/css/bootstrap.min.css dist/bootstrap-3.3.4/fonts/glyphicons-halflings-regular.eot dist/bootstrap-3.3.4/fonts/glyphicons-halflings-regular.svg dist/bootstrap-3.3.4/fonts/glyphicons-halflings-regular.ttf dist/bootstrap-3.3.4/fonts/glyphicons-halflings-regular.woff dist/bootstrap-3.3.4/fonts/glyphicons-halflings-regular.woff2 dist/bootstrap-3.3.4/js/bootstrap.js dist/bootstrap-3.3.4/js/bootstrap.min.js

less: dist/less-2.3.1/less.min.js

dist/bootstrap-3.3.4/fonts/%: vendor/bootstrap-3.3.4/fonts/%
	@mkdir -p dist/bootstrap-3.3.4/fonts
	cp $< $@

dist/bootstrap-3.3.4/css/%: vendor/bootstrap-3.3.4/css/%
	@mkdir -p dist/bootstrap-3.3.4/css
	cp $< $@

dist/bootstrap-3.3.4/js/%: vendor/bootstrap-3.3.4/js/%
	@mkdir -p dist/bootstrap-3.3.4/js
	cp $< $@

dist/less-2.3.1/%: vendor/less-2.3.1/%
	@mkdir -p dist/less-2.3.1
	cp $< $@

dist:
	@mkdir $@

dist/%.css: static/%.css dist
	cp $< $@

dist/%.css: static/%.less dist
	lessc $< > $@

dist/%.less: static/%.less dist
	cp $< $@

dist/%.html: static/%.html dist
	cp $< $@

dist/%.png: static/%.png dist
	cp $< $@

dist/%.gif: static/%.gif dist
	cp $< $@

dist/%.ico: static/%.ico dist
	cp $< $@

dist/%.js: static/%.js dist
	cp $< $@

dist/app.js: $(shell find src -type f -name '*.elm') dist
	elm-make --yes src/Main.elm --warn --output=$@

dist/vendor:
	rsync -qrvcz --delete vendor/ dist/vendor/

dist/style:
	rsync -qrvcz --delete style/ dist/style/

.PHONY: dist/style dist/vendor

upload: all
	rsync -rvcz \
		--rsync-path="/run/current-system/sw/bin/rsync" \
		--delete \
		dist/ newcradle:newcradle-haskell/webserver/static/

prod: all
	rsync -rvcz --delete dist/ newcradle:newcradle-haskell/webserver/static/

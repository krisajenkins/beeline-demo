all: dist dist/app.js dist/favicon.ico dist/loading_wheel.gif dist/interop.js dist/index.html dist/vendor dist/style.css dist/bootstrap.min.css

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

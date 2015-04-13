all: browser.js

browser.js:
	npm install
	./node_modules/browserify/bin/cmd.js index.js -o browser.js

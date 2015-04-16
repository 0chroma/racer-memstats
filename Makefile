all: browser.js

node_modules:
	npm install

index.js: node_modules
	./node_modules/coffee-script/bin/coffee -c index.coffee

browser.js: node_modules index.js
	./node_modules/browserify/bin/cmd.js index.js -o browser.js

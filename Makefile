release:
	rm -rf ./_build/prod/rel || true
	npm install --prefix ./assets
	npm run deploy --prefix ./assets
	MIX_ENV=prod mix release pi_dash
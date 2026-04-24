clean:
	flutter clean
	cd app && flutter clean
	flutter pub get

pod-install:
	echo "Installing pods..."
	flutter clean
	cd app && flutter clean
	cd app/ios && rm -f Podfile.lock
	cd app/ios && rm -rf .symlinks
	cd app/ios && rm -rf Pods
	flutter pub get
	cd app/ios && pod install --repo-update

git-update:
	echo "Updating git..."
	git pull
	git branch | grep -v "main" | xargs git branch -D
	git remote prune origin

fvm-check:
	echo "Checking flutter..."
	fvm list
	fvm use 3.41.7
	fvm global 3.41.7
	fvm list

build-runner:
	echo "Running build runner..."
	melos run run-build-runner

gen-assets:
	cd app && dart run build_runner build --delete-conflicting-outputs
	cd packages/core && dart run build_runner build --delete-conflicting-outputs

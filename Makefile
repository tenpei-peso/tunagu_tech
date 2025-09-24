.PHONY: setup
setup:
	flutter clean
	make builder

.PHONY: pub_get
pub_get:
	flutter pub get

.PHONY: pub_upgrade
pub_upgrade:
	flutter pub upgrade

.PHONY: builder
builder:
	make pub_get
	dart run build_runner clean
	dart run build_runner build --delete-conflicting-outputs

.PHONY: watch
watch:
	make pub_get
	dart run build_runner watch

.PHONY: clean&run
clean&run: clean run
clean:
	cd ios
	rm -rf Pods Podfile.lock
	pod install --repo-update
	cd ..
	make run

.PHONY: clean_pod
clean_pod:
	rm -Rf ios/Podfile.lock
	rm -Rf ios/Pods
	rm -Rf ios/.symlinkscd 
	rm -Rf ios/Flutter/Flutter.podspec
	pod install --repo-update

.PHONY: format
format:
	flutter pub run import_sorter:main
	dart format lib/* test/*
	flutter analyze

.PHONY: build
build:
	flutter pub run build_runner build --delete-conflicting-outputs
	
.PHONY: run
run:
	flutter clean
	flutter pub get
	flutter run
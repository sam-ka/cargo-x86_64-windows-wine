build:
	bash build-image.sh
install:
	cp built/cargo-x86_64-windows-wine-local /usr/local/bin/cargo-x86_64-windows-wine-local
clean:
	rm built/cargo-x86_64-windows-wine-local
	rmdir built
	[ -d test-crate/target ] && rm -r test-crate/target


.PHONY: all
all: sidecar.so

sidecar.so: sidecar/src/*.rs
	cargo build --release
	cp target/release/libsidecar.so ./sidecar.so

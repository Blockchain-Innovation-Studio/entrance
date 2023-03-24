lib:
	CGO_CFLAGS="-g -O2 -D __LIB_NSS_NAME=entrance" go build --buildmode=c-shared -o libnss_entrance.so.2 nss-entrance.go

install:
	cp libnss_entrance.so.2 /lib/

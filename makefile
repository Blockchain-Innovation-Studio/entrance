build:
	docker build -t ssh .

run:
	docker rm -f ssh
	docker run --rm -p 2323:22 -v `pwd`:/app \
		--name ssh ssh
		#-v ~/.ssh:/root/.ssh --name ssh ssh

.PHONY: entrance
entrance:
	go build -o entrance .

install:
	mv entrance /usr/bin/
	chmod +x /usr/bin/entrance

genabi:
	docker run --rm -v `pwd`:/root ethereum/solc:stable --abi /root/contracts/contracts/Entrance.sol --overwrite -o /root/registry
	abigen --abi=registry/Entrance.abi --pkg=Registry --type=EntranceManager --out=registry/entrance.go

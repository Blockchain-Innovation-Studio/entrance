package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"

	"openstory.io/entrance/config"
)

func main() {
	if e := config.Load(); e != nil {

		log.Fatal("invalid config. Please set a file at /etc/nss_entrance.json. follow doc at ")
	}

	client, err := ethclient.Dial(config.RpcNodeURL())
	if err != nil {
		log.Fatal(err)
	}

	ent, e := NewEntrance(config.ClusterName(), client, cfg.EntranceAddress())
	if e != nil {
		log.Fatal("error %s", e)
	}

	k := ent.ListKey(config.RunAsUser())
	fmt.Println(k)
}

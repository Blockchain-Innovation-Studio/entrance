package main

import (
	"errors"
	"strings"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"

	"entrance/registry"
)

type Entrance struct {
	Deployment [32]byte
	client     *ethclient.Client
	contract   *registry.EntranceManager
}

func NewEntrance(c string, client *ethclient.Client, address common.Address) (*Entrance, error) {
	if c == "" {
		return nil, errors.New("invalid deployment")
	}

	instance, err := registry.NewEntranceManager(address, client)

	if err != nil {
		return nil, err
	}

	d := [32]byte{}
	copy(d[:], []byte(c))
	return &Entrance{
		Deployment: d,
		client:     client,
		contract:   instance,
	}, nil
}

func (ent *Entrance) ListKey(user string) string {
	u := [32]byte{}
	copy(u[:], []byte(user))

	keys, err := ent.contract.GetKey(&bind.CallOpts{}, ent.Deployment, u)

	if err != nil {
		return ""
	}

	output := strings.Join(keys, "\n")

	return output
}

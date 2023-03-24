package config

import (
	"encoding/json"
	"os"

	"github.com/ethereum/go-ethereum/common"
)

type Config struct {
	EntranceAddress common.Address `json:"entrace_address"`
	RpcNodeURL      string         `json:"rpc_node_url"`
	MinUID          int64          `json:"min_uid"`
	MinGID          int64          `json:"min_gid"`

	ClusterName string `json:"cluster_name"`
	RunAsUser   string `json:"run_as_user"`
}

var (
	cfg             Config
	contractAddress = common.HexToAddress("0x035eb72ebb52c3b31190434fe954a8e102d082c8")
	nodeURL         = "https://rpc2.sepolia.org"
)

// Load read config from either env or our json /etc/nss_entrance.json
func Load() error {
	cfg = Config{
		RpcNodeURL:      nodeURL,
		EntranceAddress: contractAddress,
	}

	if v := os.Getenv("ETH_NODE_URL"); v != "" {
		cfg.RpcNodeURL = v
	}
	if v := os.Getenv("ENTRANCE_ADDRESS"); v != "" {
		cfg.contractAddress = common.HexToAddress(v)
	}

	cfgPath := "/etc/nss_entrance.json"

	file, e := os.Open(cfgPath)

	if e != nil {
		return e
	}

	defer file.Close()
	jsonParser := json.NewDecoder(file)
	jsonParser.Decode(&cfg)

	return cfg
}

func EntranceAddress() common.Address {
	return cfg.EntranceAddress
}

func RpcNodeURL() string {
	return cfg.RpcNodeURL
}

func MinUID() int64 {
	if cfg.MinUID == 0 {
		return 1001
	}

	return cfg.MinUID
}

func MinGID() int64 {
	if cfg.MinGID == 0 {
		return 1002
	}

	return cfg.MinGID
}

func ClusterName() string {
	return cfg.ClusterName
}

func RunAsUser() string {
	return cfg.RunAsUser
}

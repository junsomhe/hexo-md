---
title: EOS Docker 只启动keosd
date: 2018-08-24
categories:
- 技术
- eos
tags:
- eos
- keosd
---

## 只需要Keosd

很多时候我们运行eosio并不是想成为一个eos节点。我只需要访问超级节点的rpc api查询链的信息。只有需要账户私钥的钱包操作时才
使用eosio容器。所以很多时候我们只想运行keosd而已。下面介绍如何只运行keosd


## config.ini
使用的 `config.ini` 文件如下，这还是以前运行nodeos的配置文件，其他plugin禁用，只留下`plugin = eosio::wallet_plugin`

```bash
# fullnode sample config

blocks-dir = "blocks"

chain-state-db-size-mb = 1024

reversible-blocks-db-size-mb = 340

contracts-console = false

https-client-validate-peers = 1

http-server-address = 0.0.0.0:8888

access-control-allow-credentials = false

p2p-listen-endpoint = 0.0.0.0:9876

p2p-server-address = 0.0.0.0:9876


# List of peers

p2p-peer-address = node1.starteos.io:9876
p2p-peer-address = node2.starteos.io:9876
p2p-peer-address = node1.eosnewyork.io:6987
p2p-peer-address = peering.mainnet.eoscanada.com:9876
p2p-peer-address = fullnode.eoslaomao.com:443
p2p-peer-address = peer1.eoshuobipool.com:8181
p2p-peer-address = peer1.eoshuobipool.com:18181
p2p-peer-address = peer2.eoshuobipool.com:8181
p2p-peer-address = peer2.eoshuobipool.com:18181
p2p-peer-address = p2p.bp.fish:9786
p2p-peer-address = eos-bp.bitfinex.com:9876
p2p-peer-address = node1.zbeos.com:9876
p2p-peer-address = node2.zbeos.com:9876
p2p-peer-address = p2p.libertyblock.io:9800
p2p-peer-address = seed1.eos42.io:9876
p2p-peer-address = bp.eosbeijing.one:8080

p2p-max-nodes-per-host = 10


agent-name = "eosmainnet"

# allowed-connection can be set to "specified" to use whitelisting with the "peer-key" option

allowed-connection = any


# peer-private-key is needed if you are whitelisting specific peers with the "peer-key" option

peer-private-key = ["EOS6qTvpRYx35aLonqUkWAMwAf3mFVugYfQCbjV67zw2aoe7Vx7qd", "5JroNC1B4pz9gJzNZeU7tkU6YMtoeWRCr4CJJwKsVXnJhRbKXSC"]


max-clients = 250

connection-cleanup-period = 30

network-version-match = 1

sync-fetch-span = 100

max-implicit-request = 1500

enable-stale-production = false

pause-on-startup = false

max-transaction-time = 10000

max-irreversible-block-age = -1

txn-reference-block-lag = 0


# Plugins used for full nodes

#plugin = eosio::chain_api_plugin

#plugin = eosio::history_api_plugin

#plugin = eosio::chain_plugin

#plugin = eosio::history_plugin

#plugin = eosio::net_plugin

#plugin = eosio::net_api_plugin

plugin = eosio::wallet_plugin

#plugin = eosio::http_plugin

#plugin = eosio::bnet_plugin

#plugin = eosio::producer_plugin
```

## Docker run 指令

```bash
docker run --name eosio -d -p 8888:8888 -p 9876:9876 \
-v eos-work:/work -v eos-data:/mnt/dev/data -v eos-config:/mnt/dev/config \
eosio/eos:v1.1.0 \
/bin/bash -c "keosd eosio -d /mnt/dev/data --config-dir /mnt/dev/config --config /mnt/dev/config/config.ini --unlock-timeout 86400"
```

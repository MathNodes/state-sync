#!/bin/bash

SNAP_RPC="https://rpc.explorebitsong.com:443"
SNAP_RPC2="https://rpc-bitsong.itastakers.com:443"
HUBDIR="/mnt/BitSongDERO/.bitsongd"


LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC2\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HUBDIR/config/config.toml

cp $HUBDIR/data/priv_validator_state.json $HUBDIR/priv_validator_state.json.backup

rm -rf $HUBDIR/data
mkdir $HUBDIR/data
cp $HUBDIR/priv_validator_state.json.backup $HUBDIR/data/priv_validator_state.json


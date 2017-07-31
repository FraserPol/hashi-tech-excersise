#!/usr/bin/env bash
set -e
set -x

if [ `curl -sf "http://127.0.0.1:8200/v1/sys/init" | egrep -i "false"` ]; then

    echo "Vault is not initialized, initializing"

    vault init > /tmp/keys

    COUNTER=1
    egrep -ir "unseal key" /tmp/keys  | awk '{print $4}' | while read key; do
      consul kv put vault/unseal-keys/key-$COUNTER $key
      vault unseal $(consul kv get vault/unseal-keys/key-$COUNTER)
      COUNTER=$((COUNTER + 1))
    done

    export ROOT_TOKEN="$(egrep -ir "initial root token" /tmp/keys | awk '{print $4}')"

    consul kv put vault/root-token/key $ROOT_TOKEN

    vault auth $ROOT_TOKEN

    vault mount ssh

    vault audit-enable file file_path=/var/log/vault_audit

else

  if [ `curl -sf "http://127.0.0.1:8200/v1/sys/init" | egrep -i "true"` ]; then

    POINTER=1
    while [ $POINTER != "4" ]; do
      vault unseal $(consul kv get vault/unseal-keys/key-$POINTER)
      POINTER=$((POINTER + 1))
    done

  else

    echo "Vault already initialized or error"

  fi

fi

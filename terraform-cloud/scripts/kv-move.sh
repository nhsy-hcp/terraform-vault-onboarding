#!/bin/bash
# This script demonstrates how to move a secrets engine from one namespace to another in HashiCorp Vault.
set -xe
echo "Creating namespaces and secrets for moving"
vault secrets list -namespace=bu01
read -n 1 -s -r -p "Press any key to continue..."
echo
vault secrets enable -namespace=bu01 -path=team-move kv-v2
vault kv put -namespace=bu01 team-move/app1 username=wibble password=secure
read -n 1 -s -r -p "Press any key to continue..."
echo
vault secrets list -namespace=bu01
read -n 1 -s -r -p "Press any key to continue..."
echo
vault secrets move bu01/team-move bu02/team-move
read -n 1 -s -r -p "Press any key to continue..."
echo
vault secrets list -namespace=bu02
read -n 1 -s -r -p "Press any key to continue..."
echo
vault kv get -namespace=bu02 team-move/app1
read -n 1 -s -r -p "Press any key to continue..."
echo
vault secrets disable -namespace=bu02 team-move

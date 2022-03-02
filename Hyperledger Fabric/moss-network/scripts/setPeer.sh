#!/bin/bash

DOMAIN=$1
ORG=$2
PEER=$3
ADDRESS=$4
ADMIN=$5
MSP=${ORG}MSP
ORG_DOMAIN=${ORG}.${DOMAIN}
PEER_DOMAIN=${PEER}.${ORG_DOMAIN}

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/tlsca/tlsca.${ORG_DOMAIN}-cert.pem
export CORE_PEER_LOCALMSPID=${MSP}
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/users/${ADMIN}@${ORG_DOMAIN}/msp
export CORE_PEER_ADDRESS=${ADDRESS}
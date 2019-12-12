#! /bin/sh
set -e

# Generate a MITM certificate and key
echo '{"CN":"CA","key":{"algo":"rsa","size":2048}}' | cfssl gencert -initca - | cfssljson -bare mitm
mkdir -p /certificates
cp mitm-key.pem /clair/certs/mitm.key
cp mitm.pem /clair/certs/mitm.crt
cp mitm.pem /etc/pki/ca-trust/source/anchors/mitm.crt

# This directory is for any custom certificates users want to mount
echo "Copying custom certs to trust"
ls $CLAIRDIR/certs/ || true
cp $CLAIRDIR/certs/* /etc/pki/ca-trust/source/anchors/ || true

update-ca-trust extract

#!/bin/bash

set -eu

if [ ! -d /kube ]; then
  echo /kube does not exist. run this docker container like '`docker run -v path-to-kube-assets:/kube image-name`' 1>&2
  exit 1
fi

DIR=/kube-temp

mkdir ${DIR}

cp -R /kube/* ${DIR}/

export KUBECONFIG=${DIR}/kubeconfig

sed -i -e "s#credentials/#${DIR}/credentials/#g" ${KUBECONFIG}

go run hack/e2e.go -v --test -check_version_skew=false -check_node_count=true --test_args="ginkgo.focus='\[Conformance\]'"

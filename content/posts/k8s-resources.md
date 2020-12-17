---
title: "[k8s] Kubernetes Resources"
date: 2020-09-08T12:06:23+08:00
tags: ["k8s"]
---

Resource list for kubernetes.

<!--more-->

## Monitor

### Weave
* [Weave scope](https://github.com/weaveworks/scope)

### sysdig

* [sysdig](https://github.com/draios/sysdig)
* [sysdig-inspect](https://github.com/draios/sysdig-inspect)
* [falco](https://github.com/falcosecurity/falco)

### Prometheus

* [prometheus-operator/prometheus-operator](https://github.com/prometheus-operator/prometheus-operator)

    * Helm: [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)

## CLI

* [kubectx](https://github.com/ahmetb/kubectx)
* [kube-shell](https://github.com/cloudnativelabs/kube-shell)
* [kube-prompt](https://github.com/c-bata/kube-prompt)
* [kube-ps1](https://github.com/jonmosco/kube-ps1)
* [kail](https://github.com/boz/kail)
* [stern](https://github.com/wercker/stern)
* [telepresence](https://www.telepresence.io/)

## Plugins

* [kubectl-view-allocations](https://github.com/davidB/kubectl-view-allocations)

    * kubectl plugin lists allocations for resources (cpu, memory, gpu,...) as defined into the manifest of nodes and running pods. It doesn't list usage like kubectl top. It can provide result grouped by namespaces, nodes, pods and filtered by resources'name.

## Testing

* [powerfulseal](https://github.com/powerfulseal/powerfulseal)
* [kube-monkey](https://github.com/asobti/kube-monkey)

## Backup

* [Velero](https://github.com/vmware-tanzu/velero)

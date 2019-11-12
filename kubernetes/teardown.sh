#!/bin/bash

# Remove ingress
kubectl delete ingress jenkins-ingress

# Remove proxy

# Remove url maps
UM=$(gcloud compute url-maps list | awk '{print $1}' | tail -n 1)
echo "url map"
echo $UM
gcloud -q compute url-maps delete $UM

# Remove forwarding rules
FR=$(gcloud compute forwarding-rules list | awk '{print $1}' | tail -n 1)
echo "forwarding rules"
echo $FR
gcloud -q compute backend-services delete $FR --global

# Remove all backend services
BS=$(gcloud compute backend-services list | awk '{print $1}' | tail -n 1)
echo "backend services"
for i in $BS; do
	echo $i
	gcloud -q compute backend-services delete $i --global
done

# Remove health checks
HC=$(gcloud compute health-checks list | awk '{print $1}' | tail -n 1)
echo "health checks"
for i in $HC; do
	echo $i
	gcloud -q compute health-checks delete $HC
done

# Remove static IP
#gcloud -q compute addresses delete jenkins-master --global
gcloud -q compute addresses delete web-static-ip --global

# Remove cluster
gcloud -q container clusters delete k8s
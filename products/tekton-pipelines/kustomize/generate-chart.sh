#!/bin/bash -e
kubectl kustomize . > ./../templates/generated/tekton.yaml
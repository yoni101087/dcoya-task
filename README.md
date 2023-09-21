# dcoya-task

## Overview

The "dcoya-task" project is focused on building, pushing, deploying, and testing an application using GitHub Actions. This README provides an outline of the key steps involved in this process.

## GitHub Actions Workflow

The entire workflow for building, pushing, and deploying the "dcoya-task" application is detailed in the `.github/workflows/deploy.yml` file, which is executed automatically on push events.

## Build and Push Docker Image

To build and push the Docker image, the following steps are performed using GitHub Secrets for secure credential storage:

```bash
docker build -t ${{ env.application }} .
docker login -u ${{ secrets.DOCKERHUB_USERNAME }} -p ${{ secrets.DOCKERHUB_PASSWORD }}
docker tag ${{ env.application }} ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.dockerhub-repo }}:latest
docker push ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.dockerhub-repo }}:latest

## Deploy to Kubernetes with Helm

helm upgrade ${{ env.application }} ./charts \
  --install \
  --namespace ${{ env.namespace }}

# Run Tests
Tests for the application are conducted to ensure its functionality. The test script retrieves the website output, filters the date, and compares it with the current date using Python:

python3 ./test.py


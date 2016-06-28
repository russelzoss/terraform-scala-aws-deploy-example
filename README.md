# terraform-scala-aws-deploy-example

## Install pre-requisites (Mac)
```
brew install typesafe-activator sbt dpkg fakeroot packer terraform
```

## Build Debian package
```
sbt debian:packageBin
```

## Create AMI with Packer
```
packer build packer.json
```

## Spin-up and provision VMs with Terraform
```
terraform apply
```

## Check that App is working
```
http://<instance.public_ip>:9000
```

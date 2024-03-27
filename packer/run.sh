#!/bin/bash
packer build -var-file credentials.pkrvar.hcl -var-file ubuntu_vars.pkrvar.hcl .
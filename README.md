# Kubernetes cluster on Proxmox hypervisor

### Directories
- packer - creating vm template
- terraform - creating vms (currently: 1 maser-node, 3 worker nodes, NFS server, Sonatype Nexus server)
- ansible - deploying k8s cluster, NFS server, Sonatype Nexus server
- configuration - deploying k8s components (users, deployments, etc.)
- projects (i.e. postgres, keycloak, ...)

### Used tools
- packer
- cloud-init
- terraform
- ansible
- docker
- docker-compose
- sh scripts

# Resource Definiation for the VM Template
source "proxmox" "ubuntu-server" {
 
    # Proxmox Connection Settings
    proxmox_url = "http://${var.proxmox_host}:${var.proxmox_port}/api2/json"
    username = var.proxmox_username
    token = var.proxmox_token
    insecure_skip_tls_verify = var.proxmox_skip_verify_tls
    
    # VM Template General Settings
    node = var.proxmox_node
    vm_id = var.template_vm_id
    vm_name = var.template_name
    template_name = var.template_name
    template_description = var.template_description

    # VM OS Settings
    iso_file = var.iso_file
    iso_storage_pool = var.iso_storage_pool
    unmount_iso = true

    # VM System Settings
    qemu_agent = true
    cores = var.cores
    memory = var.memory

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = var.disk_size
        format = var.disk_format
        storage_pool = var.disk_storage_pool
        # storage_pool_type = "lvm"
        type = var.disk_type
    }

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = var.network_external_bridge
        firewall = var.network_external_firewall
    }
    network_adapters {
        model = "virtio"
        bridge = var.network_internal_bridge
        firewall = var.network_internal_firewall
    }

    # VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = var.cloud_init_storage_pool

    # PACKER Boot Commands
    boot_command = [
        "<esc><wait>",
        "e<wait>",
        "<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
        "<f10><wait>"
    ]
    boot = "c"
    boot_wait = "5s"

    # PACKER Autoinstall Settings
    http_directory = "http" 

    ssh_username = "admin"
    ssh_private_key_file = "~/.ssh/id_rsa_packer"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "20m"
}

# Build Definition to create the VM Template
build {

    name = "ubuntu-server"
    sources = ["source.proxmox.ubuntu-server"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo rm -f /etc/netplan/00-installer-config.yaml",
            "sudo sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }
}
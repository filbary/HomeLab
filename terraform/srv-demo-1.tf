resource "proxmox_vm_qemu" "vm" {

    for_each = var.vms

    name = each.value.name
    desc = each.value.description
    target_node = "host"

    agent = 1

    clone = "ubuntu-22.04-base"
    full_clone = false
    cores = each.value.cores
    sockets = 1
    cpu = "host"
    memory = each.value.memory

    network {
        bridge = "vmbr0"
        model = "virtio"
    }

    network {
        bridge = "vmbr1"
        model = "virtio"
    }

    os_type = "cloud-init"
    ipconfig0 = "ip=${each.value.external_ip}/24,gw=192.168.0.1"
    ipconfig1 = "ip=${each.value.internal_ip}/24"
    ciuser = "betoniarz"
    sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0rjrSkUQLFnSUq8d4ZmkMhM7CtNr2UKOKYEbtKats9xiWRd//OjBkQ4GNq6vQS020VKyj/Uy2+a45G6WLJfEcCXcdPnPJdGZGIBdU5qYKgqmhIPDyoqC84qjqIC978U9o5kj/sIA1d43wMWn9LNr4PruaDYAboUQulYxJlb+2z67NdpVvDleXSlY4Mce/WqFApl4b68ifROhCJKk5oBEE73Ng/nOD0vwDrq8y1Mim36XsaHbyQwV93Di98stcIZaQH1SmsUB9twbq6oFa5T8Qba0aZgXEEI6YkcTb4Ev1Q/V5ijLbAaZXx5oJ0j1ZFEqavBdchugaeBx1KKxEIdlTbdV5HmVLpaVgtMojYME7kxfq2K9n8/hN3It3M1Mv/3lLONBini1hpssDsyiHmUVyswnMZ38aTDp82XMQwRcRTcgbn7kE3Jp/BHkCvmsYiF18rATc/l8PUYMHS0qZDr1brOQXzgj5DPn1mutqeF2XTv0Z/1hRQGSYPRjq59C42Ok= betoniarz@tyler1
    EOF
}

# resource "proxmox_vm_qemu" "storage_vm" {

#     for_each = var.storage_vms

#     name = each.value.name
#     desc = "Woker node for k8s cluster."
#     target_node = "host"

#     agent = 1

#     clone = "ubuntu-22.04-base"
#     full_clone = false
#     cores = each.value.cores
#     sockets = 1
#     cpu = "host"
#     memory = each.value.memory

#     network {
#         bridge = "vmbr0"
#         model = "virtio"
#     }

#     network {
#         bridge = "vmbr1"
#         model = "virtio"
#     }

#     disk {
#         type = "virtio"
#         slot = 2
#         format = "raw"
#         size = each.value.disk_size
#         storage = "local-lvm"
#     }

#     os_type = "cloud-init"
#     ipconfig0 = "ip=${each.value.external_ip}/24,gw=192.168.0.1"
#     ipconfig1 = "ip=${each.value.internal_ip}/24"
#     ciuser = "betoniarz"
#     sshkeys = <<EOF
#     ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0rjrSkUQLFnSUq8d4ZmkMhM7CtNr2UKOKYEbtKats9xiWRd//OjBkQ4GNq6vQS020VKyj/Uy2+a45G6WLJfEcCXcdPnPJdGZGIBdU5qYKgqmhIPDyoqC84qjqIC978U9o5kj/sIA1d43wMWn9LNr4PruaDYAboUQulYxJlb+2z67NdpVvDleXSlY4Mce/WqFApl4b68ifROhCJKk5oBEE73Ng/nOD0vwDrq8y1Mim36XsaHbyQwV93Di98stcIZaQH1SmsUB9twbq6oFa5T8Qba0aZgXEEI6YkcTb4Ev1Q/V5ijLbAaZXx5oJ0j1ZFEqavBdchugaeBx1KKxEIdlTbdV5HmVLpaVgtMojYME7kxfq2K9n8/hN3It3M1Mv/3lLONBini1hpssDsyiHmUVyswnMZ38aTDp82XMQwRcRTcgbn7kE3Jp/BHkCvmsYiF18rATc/l8PUYMHS0qZDr1brOQXzgj5DPn1mutqeF2XTv0Z/1hRQGSYPRjq59C42Ok= betoniarz@tyler1
#     EOF
# }


# resource "proxmox_vm_qemu" "master" {

#     name = var.master_name
#     desc = "Master node for k8s cluster."
#     target_node = "host"

#     agent = 1

#     clone = "ubuntu-22.04-base"
#     full_clone = false
#     cores = var.master_cores
#     sockets = 1
#     cpu = "host"
#     memory = var.master_memory

#     network {
#         bridge = "vmbr0"
#         model = "virtio"
#     }

#     network {
#         bridge = "vmbr1"
#         model = "virtio"
#     }

#     os_type = "cloud-init"
#     ipconfig0 = "ip=${var.master_external_ip}/24,gw=192.168.0.1"
#     ipconfig1 = "ip=${var.master_internal_ip}/24"
#     ciuser = "betoniarz"
#     sshkeys = <<EOF
#     ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0rjrSkUQLFnSUq8d4ZmkMhM7CtNr2UKOKYEbtKats9xiWRd//OjBkQ4GNq6vQS020VKyj/Uy2+a45G6WLJfEcCXcdPnPJdGZGIBdU5qYKgqmhIPDyoqC84qjqIC978U9o5kj/sIA1d43wMWn9LNr4PruaDYAboUQulYxJlb+2z67NdpVvDleXSlY4Mce/WqFApl4b68ifROhCJKk5oBEE73Ng/nOD0vwDrq8y1Mim36XsaHbyQwV93Di98stcIZaQH1SmsUB9twbq6oFa5T8Qba0aZgXEEI6YkcTb4Ev1Q/V5ijLbAaZXx5oJ0j1ZFEqavBdchugaeBx1KKxEIdlTbdV5HmVLpaVgtMojYME7kxfq2K9n8/hN3It3M1Mv/3lLONBini1hpssDsyiHmUVyswnMZ38aTDp82XMQwRcRTcgbn7kE3Jp/BHkCvmsYiF18rATc/l8PUYMHS0qZDr1brOQXzgj5DPn1mutqeF2XTv0Z/1hRQGSYPRjq59C42Ok= betoniarz@tyler1
#     EOF
# }
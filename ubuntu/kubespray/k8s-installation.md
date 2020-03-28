Packer template'de değşiklik yapıldı. 
VBoxManage komutu kullanarak VirtualBox'da host only network oluşturuldu.
Buna ek olarak bir de NAT interface eklendi. NAT internete bağlanabilmek için gerekli. Host only network ise kubernates için gerekli.
Ubuntu otomatik kurulumu yaparken ubuntu'ya yükleme sırasında kullanacağı network interface'i aşağıdaki boot command ile verilir.

    *boot command*
    " netcfg/choose_interface=enp0s8", 

    *builder optionals*
    "ssh_host": "127.0.0.1",
    "ssh_port": 2222,
    "ssh_skip_nat_mapping": "true",

    *vboxmanage commands*
    ["modifyvm", "{{.Name}}", "--natpf2","guestssh,tcp,,2222,,22"],
    ["modifyvm", "{{.Name}}", "--natpf2","guest80,tcp,,80,,80"],
    ["modifyvm", "{{.Name}}", "--natpf2","guest8080,tcp,,8080,,8080"]


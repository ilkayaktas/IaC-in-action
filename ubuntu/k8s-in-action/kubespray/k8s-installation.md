Packer template'de değişiklik yapıldı. 
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


sudo pip3 install -r requirements.txt

sshpass kendi makinemiz de dahil tüm makinelerde kurulu olması gerekmektedir.
ssh-copy-id -i ~/.ssh/id_rsa.pub iaktas@192.168.56.101

ansible-playbook -i inventory/multinode/hosts.ini  --become --become-user=root cluster.yml

Master ve node'lar için memory kontrolü yapıyor. Bu kaldırıldı.
Tüm kurulum yapıldıktan sonra master'da aşağıdaki komutlar çalıştırılmadan önce şöyle bir hata alınıyordu:
The connection to the server localhost:8080 was refused - did you specify the right host or port?  

sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get pods -n kube-system


TASK [kubernetes/preinstall : Stop if even number of etcd hosts] ***************
fatal: [kubernetes-master]: FAILED! => {
    "assertion": "groups.etcd|length is not divisibleby 2",
    "changed": false,
    "evaluated_to": false,
    "msg": "Assertion failed"
}
fatal: [kubernetes-master-replica]: FAILED! => {
    "assertion": "groups.etcd|length is not divisibleby 2",
    "changed": false,
    "evaluated_to": false,
    "msg": "Assertion failed"
}
fatal: [kubernetes-node1]: FAILED! => {
    "assertion": "groups.etcd|length is not divisibleby 2",
    "changed": false,
    "evaluated_to": false,
    "msg": "Assertion failed"
}
fatal: [kubernetes-node2]: FAILED! => {
    "assertion": "groups.etcd|length is not divisibleby 2",
    "changed": false,
    "evaluated_to": false,
    "msg": "Assertion failed"
}

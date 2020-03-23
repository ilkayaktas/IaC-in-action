Ansible inventory dosyası içinde IP ya da domain name olabilir. Bunlara ek olarak alias, tek bir host için tanımlanmış host variable ya da birçok host için tanımlanmış group varaiables olabilir. Birden fazla ansible dosyası oluşturulabilir. Bu dosyalar -i parametresi ile komuta verilir. Ayrıca çeşitli scriptlerle dinamik olarak da inventory hostları kullanılabilir.

Ansible remote makinelere ssh protokolü ile bağlanır. Ansible native OpenSSH kullnaır.
Ssh bağlantısı yaparken tüm makinelere aynı kullanıcı adı ile bağlanır. public SSH key'i hedef sistemlerdeki authorized_keys dosyasına kopyalamak en güzelidir. İhtiyaç ahlinde farklı kullanıcı isimleriyle de bağlantı sağlanabilir: -u parametresi ile, inventory doyasına bu bilgi eklenerek, konfigürasyon dosyasına eklenerek ya da environemnt variable olarak eklenebilir.

Ansible proje yapısı oluşturulduktan sonra (ansible.cfg, inventory.ini) şu komutla ilk denemeler yapılabilir.

    $ ansible all -m ping
    $ ansible all -a "/bin/echo hello"

Aşağıdaki gibi bir çıktı görürüsünüz:

    aserver.example.org | SUCCESS => {
        "ansible_facts": {
            "discovered_interpreter_python": "/usr/bin/python"
        },
        "changed": false,
        "ping": "pong"
    }

Örnek bir komut

    # as bruce
    $ ansible all -m ping -u bruce
    # as bruce, sudoing to root (sudo is default method)
    $ ansible all -m ping -u bruce --become
    # as bruce, sudoing to batman
    $ ansible all -m ping -u bruce --become --become-user batman


Örnek bir inventory dosyası
    mail.example.com

    [webservers]
    foo.example.com
    bar.example.com

    [dbservers]
    one.example.com
    two.example.com
    three.example.com

Köşeli parantezli ifadeler grup isimleridir.
Yukarıdaki ifadenin aynısı yaml dosyası.

    all:
    hosts:
        mail.example.com:
    children:
        webservers:
        hosts:
            foo.example.com:
            bar.example.com:
        dbservers:
        hosts:
            one.example.com:
            two.example.com:
            three.example.com:

Default olarak iki grup vardır. all ve ungrouped. all tüm hostaları ifade eder. ungroup ise herhangi bir grupa dahil olmayan hostları ifade eder. Her host en az iki gruba dahildir. all ve ungroup, all ve diğer gruplar. Bir host birden fazla grupta yer alabilir.
Grup oluştururken şöyle bir yöntem izleyebilirsiniz. Bu ansible'in tavsiye ettiği bir yöntemdir.

What - An application, stack or microservice. (For example, database servers, web servers, etc).
Where - A datacenter or region, to talk to local DNS, storage, etc. (For example, east, west).
When - The development stage, to avoid testing on production resources. (For example, prod, test).
        
**Variables**
Bir host'a kolaylıkla variable eklenebilir. Aşağıdaki gibi inventory dosyasında eklediğimiz variable'ları daha sonra playbooklarda kullanabiliriz.

    [atlanta]
    host1 http_port=80 maxRequestsPerChild=808
    host2 http_port=303 maxRequestsPerChild=909

Connection variable'lar da kullanılabilir.

    [targets]

    localhost              ansible_connection=local
    other1.example.com     ansible_connection=ssh        ansible_user=myuser
    other2.example.com     ansible_connection=ssh        ansible_user=myotheruser


**Alias**

    my-alias ansible_port=5555 ansible_host=192.0.2.50

Yukarıdaki gibi alias tanımlanabilir. Ansible my-alias host'u ile çalıştıldığında 192.0.2.50 ip ve 5555 portuna bağlantı yapar.

Group ve inherited variables da mümkün bunun için [dokümantasyona](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#assigning-a-variable-to-many-machines-group-variables) bakınız.

Bazı önemli Ansible variable'ları şunlardır: ansible_connection, ansible_host, ansible_port, ansible_user, ansible_password

**Pattern**
Ansible'ı ad-hoc bir komutla veya bir playbook çalıştırarak yürütürken, hangi yönetilen node veya groupları çalıştırmak istediğinizi seçmelisiniz.

    ansible <pattern> -m <module_name> -a "<module options>""

Örnek olarak:

    ansible webservers -m service -a "name=httpd state=restarted"

Playbooklarda da şu şekilde olur.

    - name: <play_name>
    hosts: <pattern>    

Örnek olarak:

    - name: restart webservers
    hosts: webservers

Ad-Hoc Command
Bu komutlar bir ya da daha fazla node'da bir task çalıştırmaya yarar. Bu çalıştırılan komutların tamamaı command module ile çalıştırılır. Farklı modüllerle de çalıştırıma imkanı vardır. Şu şekilde kullanımı vardır:

    $ ansible [pattern] -m [module] -a "[module options]"

Bazı örnek ad-hoc komutlar aşağıdaki gibidir. Bu komut 5 adet simultaneous görev çalıştırır. Fazlasına ihtiyaç varsa (fazla node varsa) -f (fork) argumanı ile sayı belirtilebilir.

    $ ansible kubernetes-cluster -a "/sbin/reboot"

Belli bir kullanıcı ile çalıştırmak istenirse şu şekildedir:

    $ ansible kubernetes-cluster -a "/sbin/reboot" -f 10 -u username

Aşağıdaki komutla da root kullanıcı hakları ile bağlanılır ve bağlantı için parola sorar.

    $ ansible kubernetes-cluster -a "/sbin/reboot" -f 10 -u username --become [--ask-become-pass]
    $ ansible kubernetes-cluster -a "/sbin/reboot" -f 10 -u username --become -K

**Shell Modülü**

    $ ansible kubernetes-cluster -m shell -a 'echo $TERM'    

**Copy Modülü**
Dosya transferi için kullanılır.

    $ ansible kubernetes-cluster -m copy -a "src=/etc/hosts dest=/tmp/hosts"

**File Modülü**
Bir dosyanın sahibi ya da izin haklarını değiştirir. Ayrıca mkdir gibi klasör de oluşturulabilir ve silinebilir.

    $ ansible kubernetes-cluster -m file -a "dest=/srv/foo/a.txt mode=600"
    $ ansible kubernetes-cluster -m file -a "dest=/srv/foo/b.txt mode=600 owner=mdehaan group=mdehaan"

    $ ansible kubernetes-cluster -m file -a "dest=/path/to/c mode=755 owner=mdehaan group=mdehaan state=directory"

    $ ansible webservers -m file -a "dest=/path/to/c state=absent"

Yum Modülü
Redhat tabanlı işletim sistemlerine paket yüklemek, silmek ve güncellemek için kullanılır.

    $ ansible kubernetes-cluster -m yum -a "name=acme state=present"
    $ ansible kubernetes-cluster -m yum -a "name=acme state=latest"
    $ ansible kubernetes-cluster -m yum -a "name=acme state=absent"

**Service Modülü**
İşletim sistemi servislerini durdurup başlatmak için kullanılır.

    $ ansible kubernetes-cluster -m service -a "name=httpd state=started"
    $ ansible kubernetes-cluster -m service -a "name=httpd state=restarted"
    $ ansible kubernetes-cluster -m service -a "name=httpd state=stopped"

**User Modülü**
Kullanıcı oluşturmak, güncellemek ve silmek için kullanılır.

    $ ansible all -m user -a "name=foo password=<crypted password here>"
    $ ansible all -m user -a "name=foo state=absent"

**Setup Modülü**
Tüm sistem hakkında bilgi almak için kullanılır.
$ ansible all -m setup

**Playbooks**
Playbook'lar Ansible'ın konfigürasyon, deployment ve orchestration dilidir.

Teşbihte hata olmaz Ansible bir atölye olsa, module'ler araç takımınız, playbook'lar bu araçların kullanım klavuzları ve inventory dosyasında belirttiğiniz host'lar ise hammaddenizdir.

Temel düzeyde, playbook'lar uzak makinelerin yapılandırmalarını ve deployment'ları yönetmek için kullanılır.

Playbook'lar manual sıralanmış task'ları orchestre eder. Task'ları sync ya da asyn çalıştırabilir.

Her playbook bir ya da birden fazla play'den oluşabilir. Play bir grup task'tan oluş. Task'ların yaptığı ise temel olarak Ansible module'lerini çalıştırmak. Play'lerin amacı bir grup host'ta belli taskları çalıştırmaktır. Bu sayede webservers grubundaki tüm makinlerde bir grup task, database server grubundaki makinelerde başka tasklar çalıştırılabilir.

**Tek play'li playbook örneği**

    ---
    - hosts: webservers
    vars:
        http_port: 80
        max_clients: 200
    remote_user: root
    tasks:
    - name: ensure apache is at the latest version
        yum:
        name: httpd
        state: latest
    - name: write the apache config file
        template:
        src: /srv/httpd.j2
        dest: /etc/httpd.conf
        notify:
        - restart apache
    - name: ensure apache is running
        service:
        name: httpd
        state: started
    handlers:
        - name: restart apache
        service:
            name: httpd
            state: restarted


**Çoklu play örneği**

    ---
    - hosts: webservers
    remote_user: root

    tasks:
    - name: ensure apache is at the latest version
        yum:
        name: httpd
        state: latest
    - name: write the apache config file
        template:
        src: /srv/httpd.j2
        dest: /etc/httpd.conf

    - hosts: databases
    remote_user: root

    tasks:
    - name: ensure postgresql is at the latest version
        yum:
        name: postgresql
        state: latest
    - name: ensure that postgresql is started
        service:
        name: postgresql
        state: started
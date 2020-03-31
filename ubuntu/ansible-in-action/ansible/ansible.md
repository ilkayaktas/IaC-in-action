**ANSIBLE**
Ansible inventory dosyası içinde IP ya da domain name olabilir. Bunlara ek olarak alias, tek bir host için tanımlanmış host variable ya da birçok host için tanımlanmış group varaiables olabilir. Birden fazla ansible dosyası oluşturulabilir. Bu dosyalar -i parametresi ile komuta verilir. Ayrıca çeşitli scriptlerle dinamik olarak da inventory hostları kullanılabilir.

Ansible remote makinelere ssh protokolü ile bağlanır. Ansible native OpenSSH kullnaır.
Ssh bağlantısı yaparken tüm makinelere aynı kullanıcı adı ile bağlanır. public SSH key'i hedef sistemlerdeki authorized_keys dosyasına kopyalamak en güzelidir. 
Bu aslında şu demektir: ssh key kullanarak uzak makinelere parola sormadan bağlantı kurmak. Bunu yapmak için önce kendi makinemizde aşağıdaki ilk komut ile rsa anahtarı oluşturulur. Bunu ~/.ssh dizininde yapmanız gerekmektedir. Ya da oluşan dosyaları bu dizine kopyalamalısınız. İkinci komutla bu anahtar parametre olarak verilen ip'deki kullanıcının authorized_keys dosyasına eklenmiş olur.

    ssh-keygen -t rsa
    ssh-copy-id -i ~/.ssh/<public_key_file> <user>@<remote machine> 
    ssh-add
İhtiyaç halinde farklı kullanıcı isimleriyle de bağlantı sağlanabilir: -u parametresi ile, inventory doyasına bu bilgi eklenerek, konfigürasyon dosyasına eklenerek ya da environemnt variable olarak eklenebilir.

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


İlk denemeyi ping atarak yapabiliriz. İnventory dosyası içerisinde bağlantı kuracağımız sanal makinenin ip addresi yazılır. Ben şu şekilde oluşturdum:

    [kubernetes-cluster]
    192.168.56.103 

Ansible ile deneme yapmadan önce bu makineye terminalden ping atarak bağlantının olduğundan emin olunur. Daha sonrasında yapmamız gereken ise ssh bağlantısını parola ile değil ssh key aracılığı ile yapmak gerekir. Bunu test etmek için aşağıdaki komutu yazdığımızda eğer şifresiz bağlantı kurabilirseniz sonraki adıma geçebilirsiniz. Ya da ssh key'i hedef bilgisayara şöyle kopyalayabilirsiniz.

    ssh-keygen -t rsa // generate ssh key
    ssh-copy-id -i ~/.ssh/<public_key_file> <user>@<remote machine> // copy public ssh key to target machine
    ssh-add

**Ping via Ansible**

    ansible all -m ping -u iaktas -vvv // -vvv verbose loglar için eklenmiştir. iaktas hedef bilgisayardaki kullanıcı adıdır.

Şu şekilde bir çıktı görmeniz gerekir. Eğer hata oluşmuşsa loglara bakmanız gerekir. Muhtemel hata durumları şunlar olabilir: ssh key'ler aktarılmamış olabilir, ip adresi hatalı ya da ulaşılmaz olabilir ya da kullanıcı ismi yanlış yazılmış olabilir.

    192.168.56.103 | SUCCESS => {
        "changed": false,
        "invocation": {
            "module_args": {
                "data": "pong"
            }
        },
        "ping": "pong"
    }    

**Copy via Ansible**

    ansible 192.168.56.103 -u iaktas -m copy -a "src=files/something.txt dest=/home/iaktas"    

files/something.txt dosyasını iaktas kullanıcılı 192.168.56.103 makinesinde /home/iaktas dizinine kopyalar.

İlk Playbook
Github repository'deki 01_copy_playbook.yml dosyasına bakarsanız şöyle bir içerik göreceksiniz.

    1 ---
    2 - hosts: kubernetes-cluster
    3 vars_files:
    4     - vars/config.yml
    5 tasks:
    6     - name: Copy files from yml 
    7     include_tasks: tasks/copy-file.yml
    8     - name: Copy files from task
    9     copy:
    10         src: ../files/something.txt
    11         dest: /home/iaktas/something1.conf
    12         owner: iaktas
    13         group: iaktas
    14         mode: '0644'  
    15 ...

1. inventory dosyasında oluşturulan kubernetes-cluster grupu. Task'ların hepsi bu gruptaki bilgisayarların hepsinde çalıştırılır.
3. Konfigürasyon dosyalarını içerir. Bu playbook'ta kullanmadık fakat ilerleyen örneklerde gerek olacak.
5. Çalıştırılacak tüm tasklar buraya eklenir.
6. İlk Task'ın ismi. Ansible çalıştırıldığında bu task'ın çalışıp çalışmadını loglardan takip edebilirsiniz.
7. İlk task bir dosya'dan include ediliyor.
8. İkinci task'ın ismi.
9. İkinci task'ta çalıştırılacak module (copy)
10. Copy module'un parametreleridir. 

    ansible-playbook playboooks/01_copy_playbook.yml -u iaktas

-u parametresi ile kullanıcı ismi vermek yerine bunu playbook içerisinde hosts altında *become_user: iaktas* şeklinde de verebiliriz.

**Playbook Çalıştırma**
Aşağıdaki komut ile dizinde oluşturduğumuz playbook'u iaktas kullanıcısı ile çalıştırabiliriz. Kullanıcı adı konfigürasyonu yapacağımız bilgisayarlardaki kullanıcı ismidir. Tüm bilgisayarlarda bu kullanıcı bulunmalıdır.

    ansible-playbook -u iaktas 01_copy_playbook.yml

hosts: Bir ya da birden fazla group ya da host pattern. Virgül ile ayrılabilir.
remote_user: Remote user name

**Task**
Task'lar sırayla çalıştırılır. Tüm bilgisayarlar aynı anda aynı task direktiflerini alır. Bir task bitmeden diğerine geçilmez.
Temel olarak bir task'ın görevi, bir module'ü gerekli argumanlarla çalıştırmaktır.
Tüm task'ların bir ismi olmak zorundadır. Task'ın ne yaptığına dair açıklayıcı bir tanım olabilir. Playbook çalıştırılırken bunları output olarak görürüz.

**Condition**
BAzen bazı host'lar için bazı adımların atlanmasını isteyebilirsiniz. Bu bazen belli versiyon bir işletim sisteminde bir paketin yüklenmemesi olabilir, bir konfigürasyon ayarının yapılmaması oalbilir. Ya da bir play'ın sonucu başka bir değişkene ya da önceki bir task'a bağlı olabilir. Bu içinde jinja2 expression bulunan *when* ifadesi ile yapılır.

    tasks:
    - name: "shut down Debian flavored systems"
        command: /sbin/shutdown -t now
        when: ansible_facts['os_family'] == "Debian"
        # note that all variables can be used directly in conditionals without double curly braces

**Loop - Conditional Birlikte Kullanımı**
When ile Loop birlikte kullanılırken unutulmaması gereken birşey; when her item için ayrı ayrı işletilir.

    tasks:
        - command: echo {{ item }}
        loop: [ 0, 2, 4, 6, 8, 10 ]
        when: item > 5

**Loops**

Task'ların tekrarlı çalıştırılması için kullanılır.

    - name: add several users
      user:
        name: "{{ item }}"
        state: present
        groups: "wheel"
      loop:
         - testuser1
         - testuser2

Yukarıdaki gibi bir kullanımı vardır. Loop'a parametre olarak variables'ta oluşturulan bir liste de verilebilir.

    loop: "{{ somelist }}"

Looping over inventory

    # show all the hosts in the inventory
    - debug:
        msg: "{{ item }}"
    loop: "{{ groups['all'] }}"

    # show all the hosts in the current play
    - debug:
        msg: "{{ item }}"
    loop: "{{ ansible_play_batch }}"

    # show all the hosts matching the pattern, ie all but the group www
    - debug:
        msg: "{{ item }}"
      loop: "{{ query('inventory_hostnames', 'all:!www') }}"
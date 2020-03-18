Packer, Infrastructure as a Code kavramının bir parçası olarak kod ile bir makine imajı üretmeye yarayan açık kaynak kodlu bir araçtır.
Birden fazla makine imajını paralel oluşturmanıza yarar.
Chef, Puppet, Ansible gibi konfigurasyon yönetim araçlarının yerine geçmez.

Makine imajından kasıt, istenilen ayarları yapılmış, istenilen yazılımların yüklendiği işletim sistemlerinin bulunduğu sttaik birimlerdir. Bu çıktılar kullanılarak çalışabilir makineler elde edilebilir. Hedef platformlar ve çıktılar çeşitlilik göstermekterdir. EC2 için AMI'ler, VMWare için VMDK/VMX, VirtualBox için OVF/OVA, Vagrant Box ve daha birçok çeşit formatta çıktı üretilebiliyor.
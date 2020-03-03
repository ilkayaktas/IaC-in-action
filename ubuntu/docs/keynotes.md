- **post-processors** ile en son üretilecek dosyanın vagrant box ya da aws ami olarak çıkması sağlanır.

- **"execute_command": "echo 'iaktas' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"** bu provision ile sudo hakkı veriliyor.

- Kurulum yaparken provision scriptlerinde değişiklik yapabiliriz.

- VirtualBox imajı olarak dışarı alınca o makineyi çalıştırmak için önce virtualbox'a import edip daha sonra çalıştırabiliriz. Bu da biraz uğraştırıcı olabiliyor. Bunun yerine vagrant box daha mantıklı olabilir.

- Bir virtualbox imajı oluşturduğumuzu düşünelim (ova, vmdk). Bunları virtual box'a import ettik. Daha sonra bunu değiştirmek istedik. Sonra hem import ettiğimiz diski hem de builds içindeki dosyaları elle sildik. Daha sonra da virtual box'tan sildik. Bu şekilde yaptığımızda virtualbox kendi indexlediği diskler arasından bizim import ettiğimiz diski silemez. Aynı packer dosyası ile yeni bir build yapmak sitediğimizde vdi diski zaten var hatası alırız. Bunu gidermek için aşağıdaki ilk komut ile virtualbox'ın diskleri listelenir. Hata veren diskin uuid'si bulunur ve ikinci komut ile bu sanal disk elle silinir.
  
        VBoxManage list hdds
        VBoxManage closemedium disk 

    *1a8a63a3-6697-4571-b150-e402c5518d81 --delete
VBoxManage: error: Cannot register the hard disk '/Users/ilkayaktas/Workspace/CloudProjects/packer-in-action/ubuntu/builds/packer-ubuntu-18.04-amd64-v0-virtualbox/ubuntu-18.04-amd64-v0.vdi' {b0b0a3a5-388f-49c1-9a43-8e1058f86bbf} because a hard disk '/Users/ilkayaktas/Workspace/CloudProjects/packer-in-action/ubuntu/builds/packer-ubuntu-18.04-amd64-v0-virtualbox/ubuntu-18.04-amd64-v0.vdi' with UUID {1a8a63a3-6697-4571-b150-e402c5518d81} already exists*
 

 - preceed dosyası ubuntunun otomatik kurulumu için gereklidir. Kurulum sırasında gerekli olan tüm bilgiler ve ayarlar bu dosya içerinde yer alıyor.

- Ubuntu kurulumu yaparken "debconf/frontend=noninteractive" ayarı ile frontend (arayüz) seçimi yapılır. gnome ve kde bunlardan en bilinenleridir.

- Post processor ile vagrant box oluşturulacaksa kullanıcı ismi ve parolanın vagrant olmasında fayda var. Aksi durumda Vagrantfile ile çalıştırırken kullanıcı adı ve parola vermek gerekecek.

- execute_command, scriptlerin nasıl çalıştırılacaağını gösteren komuttur. Ubuntu gibi root kullanıcısı olmayan işletim sistemleri için bu komut ile sudo parolası verilebilir. ***"echo 'password' | sudo -S env {{ .Vars }} {{ .Path }}",***. -S, sudo parolasını terminalden almak yerine standart inputtan alır.
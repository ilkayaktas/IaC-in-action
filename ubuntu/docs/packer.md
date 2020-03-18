Bu yazıda sanal makine kurulumunun açık kaynak kodlu Packer aracı ile nasıl otomatize edileceğini anlatmaya çalışacağım. Bu iş neden böyle bir araca ihtiyacımız olduğunu, Packer'in özellikleri ve nasıl kullanıldığını anlatacağım. Aşağıdaki gibi bir senaryo ile anlatmak çok daha açıklayıcı olacaktır. 

**Görev**:

Yazılımımız çalışacağı *infrastructure* için bir/birkaç sanal makine oluşturulacak?

**Koşul**:

Şimdilik *VirtualBox* imajı oluştur ama bunun kesin karar olacağını garantilenmiyor. ilerleyen bir zamanda *Vagrant Box* ya da *AWS EC2 AMI* dönüştürülmesi gerekebilir. İşletim sistemi Debain olacak ama Redhat'e de geçilebilir. İhtiyaçlar dahilinde farklı yeteneklere sahip birden fazla sanal makineye ihtiyacımız olacaktır.

**Nasıl:**

Bu gereksinimlerle yola çıktığımızda VirtualBox'ta bir makine oluşturup daha sonra Ubuntu *iso*'sunu boot edip işletim sistemi kurulabilir. Sonrasında işletim sisteminde yapmak istediğimiz ayarları ssh ile bağlanıp terminal üzerinden yapabiliriz. Tabi bunu yaparken bilgisayarın başında oturup gerekli tüm kurulum girdilerini yapmamız gerekiyordu. İlerleyen zamanda Redhat'e geçiş gerektiğinde benzer işleri tekrar yapmak gerekecektir. 

Bu senaryoyu şu şekilde genişlettiğimizi düşünelim. Birbirine benzeyen ama aynısı olamayan onlarca imaj oluşturmamız gerekti. Ne yapmamız gerekecek bu durumda? Saatlerce bilgisayar başında oturup kurulum yapmak gibi bir çözüm mümkün gözükmüyor.

Bu problemi Packer aracı kullanarak çözebileceğiz. Bu yazıda Packer ile kurulumun nasıl yapılacağını anlatacağım fakat daha detaylı bilgi için resmi dokümantasyonu mutlaka okumalısınız.

Packer, Infrastructure as Code kavramının bir parçası olarak kod -diğer bir deyişle json dosyası- ile bir makine imajı üretmeye yarayan açık kaynak kodlu bir araçtır. Makine imajından kasıt, istenilen ayarları yapılmış, istenilen yazılımların yüklendiği işletim sistemlerinin bulunduğu statik birimlerdir. Bu çıktılar kullanılarak çalışabilir makineler elde edilebilir. Packer bir çok hedef platfom için imaj üretebilmektedir. Bunlara örnek EC2 için AMI'ler, VMWare için VMDK/VMX, VirtualBox için OVF/OVA, Vagrant Box ve daha birçok çeşit formatta çıktı üretilebiliyor.

Öncelikle [şu adresten](https://packer.io/intro/getting-started/install.html) kurulum yapılmalı. Terminalden ***packer version*** komutu girildiğinde kuruduğunuz sürüm numarasını görmeniz gerekmektedir.

Template

Artifacts

Variables

Builders

Provisioners

Post-Processors







Bu yazının devamı niteliğinde olacak olan *on-premise* Kubernetes kurulumu için başlangıç adımı sayılacaktır.




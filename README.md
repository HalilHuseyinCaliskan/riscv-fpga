<h2 align="center">Artix-7 FPGA Tabanlı 32-Bit RISC-V CPU Tasarımı, Simülasyonu ve RTL Doğrulaması</h2>

<h3 align="left">1. Giriş</h3>

<p align="justify">RTL (Register-Transfer Level) seviyesinde tasarım yapabilmek için Basys3 Geliştirme Kartında bulunan Artix-7 FPGA kullanılmıştır. RISC-V CPU'nun tasarımı VHDL ile Vivado üzerinden yapılmıştır. Tüm tasarım RTL seviyesinde çalışmaktadır. Simülasyonlar için de aynı şekilde Vivado kullanılmıştır. Tasarlanan CPU'nun veri yolu 32 bit olup ikili koda dönüştürülmüş RISC-V assembly kodlarını çalıştırabilmektedir.</p>

<h3 align="left">2. Bilgisayar Mimarisi</h3>

<p align="justify">Tasarlanan CPU toplamda 8 farklı parçadan (component) oluşmaktadır: Program Counter (PC), Instruction Memory, Instruction Register, Instruction Decoder, Register File, Data Memory, Arithmetic Logic Unit (ALU) ve Control Unit.</p>

<p align="justify">Von Neuman Mimarisinin komut ve verileri aynı bellek alanına saklaması yüzünden sebep olabileceği olası darboğaz sebebiyle Harvard Mimarisi tercih edilmiştir. Bu yüzden binary koda dönüştürülmüş RISC-V komutları, Instruction Memory'de bulunurken ALU tarafınfan üretilen çıktılar Data Memory'de bulunmaktadır.</p>

<p align="justify">CPU tasarımı için Single-Cycle, Multi-Cycle ve Pipeline tasarım yöntemlerinden Multi-Cycle tasarım tercih edilmiştir. Single-Cycle tasarımın tercih edilmemesinin temel sebebi her bir komutun tek bir clock'da çalışmak zorunda olması bu sebeple de toplama gibi kısa süren işlemlerin ile Data Memory'e veri yükleme gibi uzun bir işlem süresine eşitlenmek zorunda olmasıdır. Pipeline tasarımının tercih edilmemesindeki temel sebep ise Control Unit'in şuanlık fazla karmaşık olacağı ve aynı anda birdenf azla komutun icrasında olası race condition probelmerlinin yaşanabileceğidir. Multi-Cycle tasarım ile Control Unit, FSM (Finite-State Machine) kullanılarak istenilen karmaşıklıkta tasarlanmıştır. Bu sayede Single-Cycle'a göre Control Unit daha karmaşık hale gelmiş olurken Pipeline tasraıma göre daha az karmaşık hale gelmiştir.</p>

<p align="justify">Hem Instruction Memeory hem de Data Memory, sözcük adresleme (word addressable) olarak tasarlanmıştır. Bayt adresleme ile tasarlanmadığı için bellekteki baytların diziliminin Little-Endian veya Big-Endian mı olacağı ile ilgili bir problem ile karşılaşılmamıştır. Ek olarak, CPU için 3 farklı bus tasarlanmıştır: Data Bus, Address Bus ve Control Bus.</p>

<p align="justify">Instruction Decoder toplamda 17 farklı RISC-V komutunu decode edebilmekte olup ALU da decode edilen veriler üzerine 17 farklı işlem yapabilmektedir. Toplamda 5 farklı Buyruk (R, I, S, B, J) türüne sahip komutlar decode edilebilemkte olup RISC-V'ın I ve M uzantılarını desteklemektedir. Hangi komutların decode edildiği ve hangi buyruk türüne sahip olduğu Tablo 1'de gösterilmiştir.</p>

<div align="center">
    <img src="images/riscv_komut.png" width=300 height=300>
    <p><em>Figure 1. Çalıştırılabilir RISC-V Komutları ve Buyruk Türleri</em></p>
</div>

<p align="justify">Control Unit üzerinde tasarlanan FSM; Fetch, Decode, Execute ve Write Back işlemleri için gereken kontrol sinyallerini üretlebilmektedir. Ürettiği bu kontrol sinyallerini de Control Bus üzerinden diğer parçalara (component) gönderebilmektedir.</p>

<p align="justify">Sentezleme, Place ve Route işlemlerinden sonra oluşan Bitsream dosyası FPGA içerisine yüklendiği ve RTL tasarımın doğrudan FPGA'ye entegre ediliği herhangi bir silikona entegre edilmediği için hard-core değil soft-core CPU tasarımı yapılmıştır.</p>

<h3 align="left">3. Komut Döngüsü (Instruction Cycle)</h3>

<p align="justify">Basys3 Geliştirme Kartında bulunan dahili 100MHz'lik osilatör ile kare dalga şeklindeki clock sinyali üretilir. Üretilen bu clock sinyali, Clock Wizard IP Core (MMCM) sayeinde 50MHz'e düşürülür. Clock sinyali CPU'nun içeriindeki tüm parçalara ulaşır ancak o parçada herhngi bir işelmin yapılabilmesi gerekli kontrol sinyallerinin aktif (lojik = 1) seviyesinde olması gerekmetedir. Control Unit'den hangi CPU parçasının çalışacağını gösteren kontrol sinyalleri (request) üretilir ve o anda çalışan CPU parçasının işi bitince component tarafından üretilen onay sinyali (acknowledge) ile FSM içerindeki diğer duruma geçiş yapılır.</p>

<p align="justify">Program Counter tamamem senkron çalışmaktadır bir diğer deyişle Program Counter içeriindeki D Flip-Flop'ların tetiklenmesi için sadece Clock sinyalinin yükselen kenarı kullanılmakta olup herhangi bir asenkron sinyal kullanılmamaktadır. Control Unit'den çıkan request sinyali Program Counter (PC)'a ulaşır. Eğer herhangi bir dallanma emri yok ise PC'deki mevcut değere +4 eklenir ve bir sonraki komuta geçilir. Program Counter kendi üzerine düşen işi yaptıktan sonra Control Unit'e acknowledge sinyali gönderir ve FSM içerisindeki bir sonraki duruma geçiş yapılır.</p>

<p align="justify">Program Counter'dan çıkan ve hangi komutun Instruction Memory'den çekileceğini gösteren sinyal, Instruction Memory'e gelir. Instruction Memory için IP Catalog'da bulunan Block Memory Generator Ip Core'u kullanılmıştır. Senkron ve Single-Port çalışması tercih edilmiştir. Instruction Memory'e herhangi bir yazma işlemi yapılamamakta olup sadece okuma işlemi yapılabilemektedir. Instruction Memory kendi üzerine düşen işi yaptıktan sonra Control Unit'e acknowledge sinyali gönderir ve FSM içerisindeki bir sonraki duruma geçiş yapılır.</p>

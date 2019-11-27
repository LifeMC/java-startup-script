@echo off
call chcp 65001 > nul

:: Bu kismi ellemeniz onerilmez

@call @setlocal enableextensions enabledelayedexpansion
@call @cd /d "%~dp0"

:: Sürüm - degistermeniz onerilmez

set version=2.0.3-BETA

:: Ayarlar - kendinize gore duzenleyebilirsiniz

:: Sunucunuzun ana JAR dosyasının adı - spigot, craftbukkit, paper vb. olabilir
set jar_name=craftbukkit

:: Sunucunuzun surumu - 1.8.8, 1.9.4, 1.10.2, 1.11.2, 1.12.2, 1.13.2 veya 1.14.4 olabilir
:: Not: Sadece yukarida belirtilen sunucu JAR dosyasi yok ise calisir
set game_version=1.8.8

:: Eger konsolun renkli olmasini istemiyor iseniz false yapabilirsiniz
set konsol_renkleri=true

:: Sunucunun kullanacagi minimum ram miktari (MB icin M, GB icin G kullanin)
set min_ram=1536M

:: Sunucunun kullanacagi maximum ram miktari (MB icin M, GB icin G kullanin)
set max_ram=1536M

:: Kod onbellegi boyutu, 256M onerilir (MB icin M, GB icin G kullanin)
set code_cache=256M

:: Sunucunuzun daha az RAM yemesini fakat daha az performansli calismasini saglar
set less_ram=false

:: Sunucu kapandiktan sonra loglar temizlensin mi?
set log_temizle=true

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

:: Gelismis Ayarlar - duzenlemeniz pek onerilmez

:: Eger sunucu JAR dosyasi yok ise, otomatik olarak bu linkten indirilir
set download_url=https://papermc.io/api/v1/paper/%game_version%/latest/download

:: Spigot konfigurasyon dosyasinin adi (uzanti dahil)
set spigot_config=spigot.yml

:: Paper konfigurasyon dosyasinin adi (uzanti dahil)
set paper_config=paper.yml

:: Eger Java 9 veya ustu bir surum kullaniyor iseniz ve hatalar aliyor iseniz true yapin
set allow_module_access=false

:: Eger baslatma scriptinin ayarlari ve bazi bilgileri yazdirmasini istiyor iseniz true yapin
set verbose_info=false

:: Eger sunucu dosyalariniz cok buyuk ise disk aktivitesini azaltmak icin kapatabilirsiniz
set unblock_files=true

:: Eger "This JVM instance does not support server VM." tarzi bir hata alirsaniz false yapin
set use_server_vm=true

:: Assertion ozelligini acar. Sadece gelistirici iseniz acin, sunucudaki hatalari arttirabilir
set enable_assertions=false

:: Performans Ayarlari - duzenlemeniz ancak performans sorunu yasiyorsaniz onerilir

:: Eger bilgisayariniz ve Java surumunuz 64-bit ise bunu true yapin
set sixty_four_bit_java=false

:: Sunucunuzun performansini arttiran bir ayar, fakat bazi Java surumlerinde calismaz
set tiered_compilation=true

:: Class dosyalarini onbellege alarak performans arttirir, fakat bazi sistemlerde calismaz
set class_caching=false

:: Baslatma kodu uzun suruyorsa veya powershell ile alakali hata veriyorsa true yapin
set disable_powershell=false

:: Mesajlar - kendinize gore duzenleyebilirsiniz

:: Eger birden fazla sunucu penceresi aciyorsaniz karistirmamak icin bir onek girebilirsiniz
:: orn. Skyblock, Bungee, Lobi vb.
set title_prefix=

:: Onek ile asil baslik arasina bosluk koyar
if not "%title_prefix%" equ "" call set title_prefix=%title_prefix% 

:: Pencere basligi
set title=%title_prefix%Sunucu Konsolu

:: Diger mesajlar
set baslatiliyor=Sunucu baslatiliyor...
set dosya_indiriliyor=Sunucu dosyasi indiriliyor...

set temizlik_yapiliyor=Temizlik yapiliyor...
set yeniden_baslatiliyor=Sunucu yeniden baslatiliyor...

:: Kod kismi - duzenlemeniz onerilmez

call title %title%
call set unblocked=false

:start
call echo %baslatiliyor%
call echo.

call set additional_parameters=
if %konsol_renkleri% equ false call set additional_parameters= -nojline

if not exist %jar_name%.jar (
 call echo %dosya_indiriliyor%
 if %disable_powershell% equ false call powershell -nologo -noninteractive -executionpolicy bypass -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12; (New-Object Net.WebClient).DownloadFile('%download_url%', '%jar_name%.jar')" 1> nul
)

call echo eula=true> eula.txt

if exist %spigot_config% call find "verbose: true" %spigot_config% 1> nul 2> nul
if exist %spigot_config% if %errorlevel% equ 1 if %verbose% equ false if %disable_powershell% equ false call powershell -nologo -noninteractive -executionpolicy bypass -command "(gc spigot.yml) -replace 'verbose: true', 'verbose: false' | Out-File -encoding UTF8 spigot.yml" 1> nul

if exist %paper_config% call find "verbose: true" %paper_config% 1> nul 2> nul
if exist %paper_config% if %errorlevel% equ 1 if %verbose% equ false if %disable_powershell% equ false call powershell -nologo -noninteractive -executionpolicy bypass -command "(gc paper.yml) -replace 'verbose: true', 'verbose: false' | Out-File -encoding UTF8 paper.yml" 1> nul

call set server_config=server.properties

if exist %server_config% if %online_mode% equ false call find "online-mode=true" %server_config% 1> nul 2> nul
if exist %server_config% if %errorlevel% equ 1 if %online_mode% equ false if %disable_powershell% equ false call powershell -nologo -noninteractive -executionpolicy bypass -command "(gc server.properties) -replace 'online-mode=true', 'online-mode=false' | Out-File -encoding UTF8 server.properties" 1> nul

if %unblock_files% equ true if %unblocked% equ false (
 if %verbose_info% equ true call echo Unblocking files in the background...
 if %disable_powershell% equ false call powershell -nologo -noninteractive -executionpolicy bypass -command "Start-Job -Name 'Unblock Files' -ScriptBlock { [System.Threading.Thread]::CurrentThread.Priority = 'BelowNormal'; ([System.Diagnostics.Process]::GetCurrentProcess()).PriorityClass = 'BelowNormal'; Get-ChildItem -Recurse | Unblock-File }" 1> nul

 call set unblocked=true
)

call set module_access=
if %allow_module_access% equ true call set module_access= --add-opens java.base/java.lang=ALL-UNNAMED

if %verbose_info% equ true call echo Starting server with minimum RAM of %min_ram% and maximum of %max_ram%, code cache is %code_cache%

if %sixty_four_bit_java% equ true call set sixty_four_bit_java0= -d64
if %tiered_compilation% equ true call set tiered_compilation0= -XX:+TieredCompilation

if %class_caching% equ true (
 call set class_caching0= -Xshare:on -Xshareclasses
 call set class_caching1= -XX:+ShareAnonymousClasses -Dcom.ibm.enableClassCaching=true
)

if %less_ram% equ false (
 call set less_ram0= -XX:+UseStringDeduplication
 call set less_ram1= -XX:+DisableExplicitGC
) else (
 call set min_ram=1M
)

if %use_server_vm% equ true call set use_server_vm0= -server
if %enable_assertions% equ true call set enable_assertions0= -esa -ea -Xfuture -Xverify:all

call set full_arguments=-showversion -XX:+UnlockExperimentalVMOptions -XX:+IgnoreUnrecognizedVMOptions%enable_assertions0% -XX:+IdleTuningGcOnIdle -XX:+ShowMessageBoxOnError -Xlint:none%module_access%%class_caching0%%sixty_four_bit_java0%%use_server_vm0% -Xms%min_ram% -Xmx%max_ram% -XX:ReservedCodeCacheSize=%code_cache% -XX:UseSSE=4 -XX:+UseGCOverheadLimit -XX:+MaxFDLimit -XX:+RelaxAccessControlCheck -XX:+UseThreadPriorities -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe%tiered_compilation0% -XX:+UseLWPSynchronization -XX:+UseBiasedLocking -XX:+UseFastAccessorMethods -XX:+CMSIncrementalPacing -XX:+CMSParallelRemarkEnabled -XX:+UseCMSInitiatingOccupancyOnly -XX:+ScavengeBeforeFullGC -XX:+CMSScavengeBeforeRemark -XX:+CMSClassUnloadingEnabled%less_ram0% -XX:+ParallelRefProcEnabled -XX:+OmitStackTraceInFastThrow -XX:-AggressiveOpts%less_ram1% -XX:+UseGCStartupHints%class_caching1% -XX+JITInlineWatches -XX+TransparentHugePage -Dsun.io.useCanonPrefixCache=false -Djava.net.preferIPv4Stack=true -Dsun.net.http.errorstream.enableBuffering=true -Dsun.net.client.defaultConnectTimeout=5000 -Dsun.net.client.defaultReadTimeout=5000 -Dskript.dontUseNamesForSerialization=true -Djava.net.preferIPv4Stack=true -Djdk.http.auth.tunneling.disabledSchemes="" -Djdk.attach.allowAttachSelf -Dkotlinx.coroutines.debug=off -Djava.awt.headless=%head_less% -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 -Dsun.stderr.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Duser.language=en -Duser.country=US -Duser.timezone=Asia/Istanbul -Dpaper.playerconnection.keepalive=%io_timeout% -Dnashorn.option.no.deprecation.warning=true -Dlog4j.skipJansi=true -Dusing.flags.lifemcserver.com=true -Djansi.force=true -Dansi.force=true -Dlibrary.jansi.version=%jar_name% -jar %jar_name%.jar "-o %online_mode% --log-append=false --log-strip-color nogui%additional_parameters%"
if %verbose_info% equ true call echo Starting Java with the final arguments of %full_arguments%

call java %full_arguments%

call echo %temizlik_yapiliyor%

if %log_temizle% equ true call del logs\*.* /q 1> nul 2> nul
call del plugins\NoCheatPlus\*.log /q 1> nul 2> nul
call del plugins\NoCheatPlus\*.lck /q 1> nul 2> nul
call del plugins\NoCheatPlus\*.log.* /q 1> nul 2> nul
call del plugins\AuthMe\authme.log /q 1> nul 2> nul
call del plugins\bStats\temp.txt /q 1> nul 2> nul
call del plugins\AntiAura\logs\*.* /q 1> nul 2> nul

call echo %yeniden_baslatiliyor%
call timeout %delay% 2> nul

goto start



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
chcp 65001 > nul

:: Bu kismi ellemeniz onerilmez

cd /d "%~dp0"

:: SURUM - degistermeniz onerilmez

set version=2.1.0

:: AYARLAR - kendinize gore duzenleyebilirsiniz

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
set min_ram=1536M

:: Sunucunun kullanacagi maximum ram miktari (MB icin M, GB icin G kullanin)
set max_ram=1536M

:: Kod onbellegi boyutu, 256M onerilir (MB icin M, GB icin G kullanin)
set code_cache=256M

:: Sunucunuzun daha az RAM yemesini fakat daha az performansli calismasini saglar
set less_ram=false

:: Eger konsolun renkli olmasini istemiyor iseniz false yapabilirsiniz
set colored_console=true

:: Sunucu kapandiktan sonra loglar temizlensin mi?
set clear_logs=true

:: Sunucu kapandiktan sonra gereksiz dosyalar silinsin mi?
set auto_del_files=true

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

:: GELISMIS AYARLAR - duzenlemeniz pek onerilmez

:: Eger sunucu JAR dosyasi yok ise, otomatik olarak bu linkten indirilir
:: 1.16.4+ kullaniyorsaniz Paper'a gore daha performansli olan Yatopia'yi kullanin: https://api.yatopia.net/v2/build/latestBuild/download
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
set baslatiliyor=Sunucu baslatiliyor...
set dosya_indiriliyor=Sunucu dosyasi indiriliyor...

set temizlik_yapiliyor=Temizlik yapiliyor...
set yeniden_baslatiliyor=Sunucu yeniden baslatiliyor...

:: KOS KISMI - duzenlemeniz onerilmez

title %title%
set unblocked=false

:start
echo %baslatiliyor%
echo.

set additional_parameters=
if %colored_console% equ false set additional_parameters= -nojline

if not exist %jar_name%.jar if exist "bukkit.jar" set jar_name=bukkit
if not exist %jar_name%.jar if exist "spigot.jar" set jar_name=spigot

if not exist %jar_name%.jar if exist "paper.jar" set jar_name=paper
if not exist %jar_name%.jar if exist "paperclip.jar" set jar_name=paperclip

if not exist %jar_name%.jar if exist "yatopia.jar" set jar_name=yatopia

if not exist %jar_name%.jar (
 echo %dosya_indiriliyor%
 echo.
 if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12; (New-Object Net.WebClient).DownloadFile('%download_url%', '%jar_name%.jar')" > nul
)

echo eula=true> eula.txt

if exist %spigot_config% if %verbose% equ false if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %spigot_config%) | ForEach-Object { $_ -replace 'verbose: true', 'verbose: false' } | Set-Content -encoding UTF8 %spigot_config%" > nul
if exist %paper_config% if %verbose% equ false if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %paper_config%) | ForEach-Object { $_ -replace 'verbose: true', 'verbose: false' } | Set-Content -encoding UTF8 %paper_config%" > nul

set server_config=server.properties

if exist %server_config% if %online_mode% equ false if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "(Get-Content %server_config%) | ForEach-Object { $_ -replace 'online-mode=true', 'online-mode=false' } | Set-Content -encoding UTF8 %server_config%" > nul

if %unblock_files% equ true if %unblocked% equ false (
 if %verbose_info% equ true echo Unblocking files in the background...
 if %disable_powershell% equ false powershell -nologo -noprofile -noninteractive -executionpolicy bypass -command "Start-Job -Name 'Unblock Files' -ScriptBlock { [System.Threading.Thread]::CurrentThread.Priority = 'BelowNormal'; ([System.Diagnostics.Process]::GetCurrentProcess()).PriorityClass = 'BelowNormal'; Get-ChildItem -Recurse | Unblock-File }" > nul

 set unblocked=true
)

set module_access=
if %allow_module_access% equ true set module_access= --add-opens java.base/java.lang=ALL-UNNAMED

if %verbose_info% equ true echo Starting server with minimum RAM of %min_ram% and maximum of %max_ram%, code cache is %code_cache%

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

set full_arguments=-XX:+UnlockExperimentalVMOptions -XX:+IgnoreUnrecognizedVMOptions%enable_assertions0% -XX:+IdleTuningGcOnIdle%show_messagebox_onerror0% -Xlint:none%module_access%%class_caching0%%sixty_four_bit_java0%%use_server_vm0% -Xms%min_ram% -Xmx%max_ram% -XX:+ShowCodeDetailsInExceptionMessages -XX:ReservedCodeCacheSize=%code_cache% -XX:UseSSE=4 -XX:+UseGCOverheadLimit -XX:+UseG1GC -XX:+MaxFDLimit -XX:+RelaxAccessControlCheck -XX:+UseThreadPriorities -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe%tiered_compilation0% -XX:+UseFastAccessorMethods -XX:+CMSIncrementalPacing -XX:+ScavengeBeforeFullGC%less_ram0% -XX:+ParallelRefProcEnabled%omit_stacktrace0% -XX:-AggressiveOpts%less_ram1% -XX:+UseGCStartupHints%class_caching1% -XX+JITInlineWatches -Dsun.io.useCanonPrefixCache=false -Djava.net.preferIPv4Stack=true -Dsun.net.http.errorstream.enableBuffering=true -Dsun.net.client.defaultConnectTimeout=5000 -Dsun.net.client.defaultReadTimeout=5000 -Dskript.dontUseNamesForSerialization=true -Djava.net.preferIPv4Stack=true -Djdk.http.auth.tunneling.disabledSchemes="" -Djdk.attach.allowAttachSelf -Dkotlinx.coroutines.debug=off -Djava.awt.headless=%head_less% -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 -Dsun.stderr.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Duser.language=en -Duser.country=US -Duser.timezone=Asia/Istanbul -Dpaper.playerconnection.keepalive=%io_timeout% -Dnashorn.option.no.deprecation.warning=true -Dlog4j.skipJansi=true -Djansi.passthrough=true -Dlibrary.jansi.path=cache -DPaper.IgnoreJavaVersion=true -Dusing.aikars.flags=true -Daikars.new.flags=true -Dusing.flags.lifemcserver.com=true -Dflags.lifemcserver.com.version="%version%" -Djansi.force=true -Dansi.force=true -Dlibrary.jansi.version=%jar_name% -jar %jar_name%.jar "-o %online_mode%%upgrade_argument% --log-append=false --log-strip-color nogui%additional_parameters%"
if %print_java_version% equ true set full_arguments=-showversion %full_arguments%

if %verbose_info% equ true echo Starting Java with the final arguments of %full_arguments%

%java_command% %full_arguments%

echo %temizlik_yapiliyor%

if %auto_del_files% equ true (
 if %clear_logs% equ true del .console_history /q > nul 2> nul
 if %clear_logs% equ true del logs\*.* /q > nul 2> nul
 del plugins\NoCheatPlus\*.log /q > nul 2> nul
 del plugins\NoCheatPlus\*.lck /q > nul 2> nul
 del plugins\NoCheatPlus\*.log.* /q > nul 2> nul
 del plugins\AuthMe\authme.log /q > nul 2> nul
 del plugins\bStats\temp.txt /q > nul 2> nul
 del plugins\AntiAura\logs\*.* /q > nul 2> nul
)

if %auto_restart% equ true (
 echo %yeniden_baslatiliyor%
 timeout %delay% > nul

 goto start
) else (
 pause
)

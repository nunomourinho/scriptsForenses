$dataHoje=Get-Timestamp
$ficheiro="./regripper_" + $dataHoje + ".TXT"

function Get-Timestamp{
    $Timestamp=$(Get-Date -Format o | ForEach-Object { $_ -replace ":", "." })
    #Write-Host $Timestamp
    return $Timestamp
}


function Escreve-Seccao() {

  [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$seccao
    )

  Write-Host "Relat�rio: Escrita a seccao " $seccao " no ficheiro " $ficheiro
  Add-Content -Path $ficheiro -Value "\newpage"
  Add-Content -Path $ficheiro -Value "\section{$seccao}"
  }


function Executa-Comandos() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$fimficheiro, 
        [Parameter(Mandatory)]
        [string]$msg, 
        [Parameter(Mandatory)]
        [string]$comandos
    )
    
  $dataHoje=Get-Timestamp
  $ficheiro="./regripper_" + $dataHoje + $fimficheiro + ".TXT"
  Write-Host  "Relat�rio:  $comandos "
  Add-Content -Path $ficheiro -Value "\textbf{Descri��o do prop�sito:} $msg  \newline \newline"
  Add-Content -Path $ficheiro -Value "Comando executado: "
  Add-Content -Path $ficheiro -Value "\begin{powershell}"
  Add-Content -Path $ficheiro -Value $comandos
  Add-Content -Path $ficheiro -Value "\end{powershell}"
  Add-Content -Path $ficheiro -Value "Resultado(s): \newline"
  Add-Content -Path $ficheiro -Value "\footnotesize"
  Add-Content -Path $ficheiro -Value "\begin{powershell}"
 
  $start=Get-Timestamp
  #/usr/bin/time -v -o /tmp/tempo_decorrido.txt $comandos 2>&1 | tee -a $ficheiro
  
  $erro=0
  try {
     Measure-Command { Invoke-Expression $comandos -OutVariable resultado | Out-Default } -OutVariable tempo
  } catch {
    # $_ Vari�vel do erro
    $erro = $_
  }
 
  
  #Invoke-Expression $comandos -OutVariable resultado
  #$resultado 
  Add-Content -Path $ficheiro -Value $resultado

  $end=Get-Timestamp
  
  Add-Content -Path $ficheiro -Value "\end{powershell}"
  Add-Content -Path $ficheiro -Value "\normalsize"
  Add-Content -Path $ficheiro -Value "Tempo decorrido: "
  Add-Content -Path $ficheiro -Value "\begin{tempo}"
  Add-Content -Path $ficheiro -Value "In�cio: $start "
  Add-Content -Path $ficheiro -Value "Fim: $end "
  Add-Content -Path $ficheiro -Value "Tempo Decorrido: $tempo"  
  Add-Content -Path $ficheiro -Value "Exit Status: $erro"
  Add-Content -Path $ficheiro -Value "\end{tempo}"

  if ($erro -ne 0) {
  $ficheiroerro="./ERRO_regripper_" + $dataHoje + ".TXT"
  Rename-Item -Path $ficheiro -Newname $ficheiroerro
  write-host "ERRO!!!!:" $erro
  }
}

Get-Timestamp
Escreve-Seccao "Extra��o de informa��o a partir do registo do windows"
Executa-Comandos "adoberdr" "Gets user's Adobe Reader cRecentFiles values,," "./rip.exe -r NTUSER.DAT -p adoberdr"
Executa-Comandos "allowedenum" " Software,Extracts AllowedEnumeration values to determine hidden special folders," "./rip.exe -r NTUSER.DAT -p allowedenum"
Executa-Comandos "amcache" "Parse AmCache.hve file,," "./rip.exe -r amcache -p amcache"
Executa-Comandos "amcache_tln" "Parse AmCache.hve file,," "./rip.exe -r amcache -p amcache_tln"
Executa-Comandos "appassoc" "Gets contents of user's ApplicationAssociationToasts key,," "./rip.exe -r NTUSER.DAT -p appassoc"
Executa-Comandos "appcertdlls" "Get entries from AppCertDlls key,," "./rip.exe -r System -p appcertdlls"
Executa-Comandos "appcompatcache" "Parse files from System hive AppCompatCache,," "./rip.exe -r System -p appcompatcache"
Executa-Comandos "appcompatcache_tln" "Parse files from System hive AppCompatCache,," "./rip.exe -r System -p appcompatcache_tln"
Executa-Comandos "appcompatflags" " Software,Extracts AppCompatFlags for Windows.," "./rip.exe -r NTUSER.DAT -p appcompatflags"
Executa-Comandos "appinitdlls" "Gets contents of AppInit_DLLs value,," "./rip.exe -r Software -p appinitdlls"
Executa-Comandos "appkeys" " Software,Extracts AppKeys entries.," "./rip.exe -r NTUSER.DAT -p appkeys"
Executa-Comandos "appkeys_tln" " Software,Extracts AppKeys entries.," "./rip.exe -r NTUSER.DAT -p appkeys_tln"
Executa-Comandos "applets" "Gets contents of user's Applets key,," "./rip.exe -r NTUSER.DAT -p applets"
Executa-Comandos "applets_tln" "Gets contents of user's Applets key (TLN),," "./rip.exe -r NTUSER.DAT -p applets_tln"
Executa-Comandos "apppaths" "Software,Gets content of App Paths subkeys," "./rip.exe -r NTUSER.DAT -p apppaths"
Executa-Comandos "apppaths_tln" " Software,Gets content of App Paths subkeys (TLN)," "./rip.exe -r NTUSER.DAT -p apppaths_tln"
Executa-Comandos "appspecific" "Gets contents of user's Intellipoint\AppSpecific subkeys,," "./rip.exe -r NTUSER.DAT -p appspecific"
Executa-Comandos "appx" " USRCLASS.DAT,Checks for persistence via Universal Windows Platform Apps," "./rip.exe -r NTUSER.DAT -p appx"
Executa-Comandos "appx_tln" " USRCLASS.DAT,Checks for persistence via Universal Windows Platform Apps," "./rip.exe -r NTUSER.DAT -p appx_tln"
Executa-Comandos "arpcache" "Retrieves CurrentVersion\App Management\ARPCache entries,," "./rip.exe -r NTUSER.DAT -p arpcache"
Executa-Comandos "at" "Checks Software hive for AT jobs,," "./rip.exe -r Software -p at"
Executa-Comandos "attachmgr" "Checks user's keys that manage the Attachment Manager functionality,," "./rip.exe -r NTUSER.DAT -p attachmgr"
Executa-Comandos "attachmgr_tln" "Checks user's keys that manage the Attachment Manager functionality (TLN),," "./rip.exe -r NTUSER.DAT -p attachmgr_tln"
Executa-Comandos "at_tln" "Checks Software hive for AT jobs,," "./rip.exe -r Software -p at_tln"
Executa-Comandos "audiodev" "Gets audio capture/render devices,," "./rip.exe -r Software -p audiodev"
Executa-Comandos "auditpol" "Get audit policy from the Security hive file,," "./rip.exe -r Security -p auditpol"
Executa-Comandos "backuprestore" "Gets the contents of the FilesNotToSnapshot, KeysNotToRestore, and FilesNotToBackup keys" "./rip.exe -r System -p backuprestore"
Executa-Comandos "bam" "Parse files from System hive BAM Services,," "./rip.exe -r System -p bam"
Executa-Comandos "bam_tln" "Parse files from System hive BAM Services,," "./rip.exe -r System -p bam_tln"
Executa-Comandos "base" "Parse base info from hive,," "./rip.exe -r All -p base"
Executa-Comandos "baseline" "Scans a hive file, checking sizes of binary value data," "./rip.exe -r All -p baseline"
Executa-Comandos "btconfig" "Determines BlueTooth devices 'seen' by BroadComm drivers,," "./rip.exe -r Software -p btconfig"
Executa-Comandos "bthenum" "Get BTHENUM subkey info,," "./rip.exe -r System -p bthenum"
Executa-Comandos "bthport" "Gets Bluetooth-connected devices from System hive,," "./rip.exe -r System -p bthport"
Executa-Comandos "bthport_tln" "Gets Bluetooth-connected devices from System hive; TLN output,," "./rip.exe -r System -p bthport_tln"
Executa-Comandos "cached" "Gets cached Shell Extensions from NTUSER.DAT hive,," "./rip.exe -r NTUSER.DAT -p cached"
Executa-Comandos "cached_tln" "Gets cached Shell Extensions from NTUSER.DAT hive (TLN),," "./rip.exe -r NTUSER.DAT -p cached_tln"
Executa-Comandos "calibrator" "Checks DisplayCalibrator value (possible bypass assoc with LockBit ransomware),," "./rip.exe -r Software -p calibrator"
Executa-Comandos "clsid" " USRCLASS.DAT,Get list of CLSID/registered classes," "./rip.exe -r Software -p clsid"
Executa-Comandos "clsid_tln" " USRCLASS.DAT,Get list of CLSID/registered classes," "./rip.exe -r Software -p clsid_tln"
Executa-Comandos "cmdproc" "Autostart - get Command Processor\AutoRun value from NTUSER.DAT hive,," "./rip.exe -r NTUSER.DAT -p cmdproc"
Executa-Comandos "cmdproc_tln" "Autostart - get Command Processor\AutoRun value from NTUSER.DAT hive (TLN),," "./rip.exe -r NTUSER.DAT -p cmdproc_tln"
Executa-Comandos "cmd_shell" "Gets shell open cmds for various file types,," "./rip.exe -r Software -p cmd_shell"
Executa-Comandos "codepage" "Checks codepage value,," "./rip.exe -r system -p codepage"
Executa-Comandos "comdlg32" "Gets contents of user's ComDlg32 key,," "./rip.exe -r NTUSER.DAT -p comdlg32"
Executa-Comandos "compdesc" "Gets contents of user's ComputerDescriptions key,," "./rip.exe -r NTUSER.DAT -p compdesc"
Executa-Comandos "compname" "Gets ComputerName and Hostname values from System hive,," "./rip.exe -r System -p compname"
Executa-Comandos "consentstore" " NTUSER.DAT,Gets contents of ConsentStore subkeys," "./rip.exe -r Software -p consentstore"
Executa-Comandos "consentstore_tln" " NTUSER.DAT,Gets contents of ConsentStore subkeys," "./rip.exe -r Software -p consentstore_tln"
Executa-Comandos "crashcontrol" "Get crash control information,," "./rip.exe -r System -p crashcontrol"
Executa-Comandos "cred" "Checks for UseLogonCredential value,," "./rip.exe -r system -p cred"
Executa-Comandos "cred_tln" "Checks UseLogonCredential value,," "./rip.exe -r system -p cred_tln"
Executa-Comandos "dafupnp" "Parses data from networked media streaming devices,," "./rip.exe -r System -p dafupnp"
Executa-Comandos "dcom" "Check DCOM Ports,," "./rip.exe -r Software -p dcom"
Executa-Comandos "ddo" "Gets user's DeviceDisplayObjects key contents,," "./rip.exe -r NTUSER.DAT -p ddo"
Executa-Comandos "defender" "Get Windows Defender settings,," "./rip.exe -r Software -p defender"
Executa-Comandos "del" "Parse hive, print deleted keys/values," "./rip.exe -r All -p del"
Executa-Comandos "del_tln" "Parse hive, print deleted keys/values," "./rip.exe -r All -p del_tln"
Executa-Comandos "devclass" "Get USB device info from the DeviceClasses keys in the System hive,," "./rip.exe -r System -p devclass"
Executa-Comandos "direct" "Searches Direct* keys for MostRecentApplication subkeys,," "./rip.exe -r Software -p direct"
Executa-Comandos "direct_tln" "Searches Direct* keys for MostRecentApplication subkeys (TLN),," "./rip.exe -r Software -p direct_tln"
Executa-Comandos "disablelastaccess" "Get NTFSDisableLastAccessUpdate value,," "./rip.exe -r System -p disablelastaccess"
Executa-Comandos "disablemru" " Software,Checks settings disabling user's MRUs," "./rip.exe -r NTUSER.DAT -p disablemru"
Executa-Comandos "disableremotescm" "Gets DisableRemoteScmEndpoints value from System hive,," "./rip.exe -r System -p disableremotescm"
Executa-Comandos "disablesr" "Gets the value that turns System Restore either on or off,," "./rip.exe -r Software -p disablesr"
Executa-Comandos "drivers32" "Get values from the Drivers32 key,," "./rip.exe -r Software -p drivers32"
Executa-Comandos "emdmgmt" "Gets contents of EMDMgmt subkeys and values,," "./rip.exe -r Software -p emdmgmt"
Executa-Comandos "environment" " NTUSER.DAT,Get environment vars from NTUSER.DAT & System hives," "./rip.exe -r System -p environment"
Executa-Comandos "execpolicy" "Gets PowerShell Execution Policy,," "./rip.exe -r Software -p execpolicy"
Executa-Comandos "featureusage" "Extracts user's FeatureUsage data.,," "./rip.exe -r NTUSER.DAT -p featureusage"
Executa-Comandos "fileless" "Scans a hive file looking for fileless malware entries,," "./rip.exe -r All -p fileless"
Executa-Comandos "findexes" "Scans a hive file looking for binary value data that contains MZ,," "./rip.exe -r All -p findexes"
Executa-Comandos "gpohist" "Collects system/user GPO history,," "./rip.exe -r Software -p gpohist"
Executa-Comandos "gpohist_tln" "Collects system/user GPO history (TLN),," "./rip.exe -r Software -p gpohist_tln"
Executa-Comandos "heap" "Checks HeapLeakDetection\DiagnosedApplications Subkeys,," "./rip.exe -r Software -p heap"
Executa-Comandos "ica_sessions" "ARETE ONLY - Extracts Citrix ICA Session info,," "./rip.exe -r Software -p ica_sessions"
Executa-Comandos "identities" "Extracts values from Identities key; NTUSER.DAT,," "./rip.exe -r NTUSER.DAT -p identities"
Executa-Comandos "imagedev" " -- ,," "./rip.exe -r System -p imagedev"
Executa-Comandos "imagefile" "Checks ImageFileExecutionOptions subkeys values,," "./rip.exe -r Software -p imagefile"
Executa-Comandos "injectdll64" " Software,Retrieve values set to weaken Chrome security," "./rip.exe -r NTUSER.DAT -p injectdll64"
Executa-Comandos "inprocserver" "Checks CLSID InProcServer32 values for indications of malware,," "./rip.exe -r Software -p inprocserver"
Executa-Comandos "installer" "Determines product install information,," "./rip.exe -r Software -p installer"
Executa-Comandos "ips" "Get IP Addresses and domains (DHCP,static)," "./rip.exe -r System -p ips"
Executa-Comandos "jumplistdata" "Gets contents of user's JumpListData key,," "./rip.exe -r NTUSER.DAT -p jumplistdata"
Executa-Comandos "killsuit" "Check for indications of Danderspritz Killsuit installation,," "./rip.exe -r Software -p killsuit"
Executa-Comandos "killsuit_tln" "Check for indications of Danderspritz Killsuit installation,," "./rip.exe -r Software -p killsuit_tln"
Executa-Comandos "knowndev" "Gets user's KnownDevices key contents,," "./rip.exe -r NTUSER.DAT -p knowndev"
Executa-Comandos "landesk" "Get list of programs monitored by LANDESK - Software hive,," "./rip.exe -r Software -p landesk"
Executa-Comandos "landesk_tln" "Get list of programs monitored by LANDESK from Software hive,," "./rip.exe -r Software -p landesk_tln"
Executa-Comandos "lastloggedon" "Gets LastLoggedOn* values from LogonUI key,," "./rip.exe -r Software -p lastloggedon"
Executa-Comandos "licenses" "Get contents of HKLM/Software/Licenses key,," "./rip.exe -r Software -p licenses"
Executa-Comandos "link_click" "Get UseRWHlinkNavigation value data,," "./rip.exe -r NTUSER.DAT -p link_click"
Executa-Comandos "listsoft" "Lists contents of user's Software key,," "./rip.exe -r NTUSER.DAT -p listsoft"
Executa-Comandos "load" "Gets load and run values from user hive,," "./rip.exe -r NTUSER.DAT -p load"
Executa-Comandos "logonstats" "Gets contents of user's LogonStats key,," "./rip.exe -r NTUSER.DAT -p logonstats"
Executa-Comandos "lsa" "Lists specific contents of LSA key,," "./rip.exe -r System -p lsa"
Executa-Comandos "lxss" "Gets WSL config.,," "./rip.exe -r NTUSER.DAT -p lxss"
Executa-Comandos "lxss_tln" "Gets WSL config.,," "./rip.exe -r NTUSER.DAT -p lxss_tln"
Executa-Comandos "macaddr" "Software, -- ," "./rip.exe -r System -p macaddr"
Executa-Comandos "mixer" "Checks user's audio mixer settings,," "./rip.exe -r NTUSER.DAT -p mixer"
Executa-Comandos "mixer_tln" "Checks user's audio mixer info,," "./rip.exe -r NTUSER.DAT -p mixer_tln"
Executa-Comandos "mmc" "Get contents of user's MMC\Recent File List key,," "./rip.exe -r NTUSER.DAT -p mmc"
Executa-Comandos "mmc_tln" "Get contents of user's MMC\Recent File List key (TLN),," "./rip.exe -r NTUSER.DAT -p mmc_tln"
Executa-Comandos "mmo" "Checks NTUSER for Multimedia\Other values [malware],," "./rip.exe -r NTUSER.DAT -p mmo"
Executa-Comandos "mndmru" "Get contents of user's Map Network Drive MRU,," "./rip.exe -r NTUSER.DAT -p mndmru"
Executa-Comandos "mndmru_tln" "Get user's Map Network Drive MRU (TLN),," "./rip.exe -r NTUSER.DAT -p mndmru_tln"
Executa-Comandos "mountdev" "Return contents of System hive MountedDevices key,," "./rip.exe -r System -p mountdev"
Executa-Comandos "mountdev2" "Return contents of System hive MountedDevices key,," "./rip.exe -r System -p mountdev2"
Executa-Comandos "mp2" "Gets user's MountPoints2 key contents,," "./rip.exe -r NTUSER.DAT -p mp2"
Executa-Comandos "mp2_tln" "Gets user's MountPoints2 key contents,," "./rip.exe -r NTUSER.DAT -p mp2_tln"
Executa-Comandos "mpmru" "Gets user's Media Player RecentFileList values,," "./rip.exe -r NTUSER.DAT -p mpmru"
Executa-Comandos "msis" "Determine MSI packages installed on the system,," "./rip.exe -r Software -p msis"
Executa-Comandos "msoffice" "Get user's MSOffice content,," "./rip.exe -r NTUSER.DAT -p msoffice"
Executa-Comandos "msoffice_tln" "Get user's MSOffice content,," "./rip.exe -r NTUSER.DAT -p msoffice_tln"
Executa-Comandos "muicache" "USRCLASS.DAT,Gets EXEs from user's MUICache key," "./rip.exe -r NTUSER.DAT -p muicache"
Executa-Comandos "muicache_tln" "USRCLASS.DAT,Gets EXEs from user's MUICache key (TLN)," "./rip.exe -r NTUSER.DAT -p muicache_tln"
Executa-Comandos "nation" "Gets region information from HKCU,," "./rip.exe -r ntuser.dat -p nation"
Executa-Comandos "netlogon" "Parse values for machine account password changes,," "./rip.exe -r System -p netlogon"
Executa-Comandos "netsh" "Gets list of NetSH helper DLLs,," "./rip.exe -r Software -p netsh"
Executa-Comandos "networkcards" "Get NetworkCards Info,," "./rip.exe -r Software -p networkcards"
Executa-Comandos "networklist" "Collects network info from NetworkList key,," "./rip.exe -r Software -p networklist"
Executa-Comandos "networklist_tln" "Collects network info from NetworkList key (TLN),," "./rip.exe -r Software -p networklist_tln"
Executa-Comandos "networksetup2" "Get NetworkSetup2 subkey info,," "./rip.exe -r System -p networksetup2"
Executa-Comandos "nic2" "Gets NIC info from System hive,," "./rip.exe -r System -p nic2"
Executa-Comandos "ntds" "Parse Services NTDS key for specific persistence values,," "./rip.exe -r System -p ntds"
Executa-Comandos "null" "Check key/value names in a hive for leading null char,," "./rip.exe -r All -p null"
Executa-Comandos "oisc" "Gets contents of user's Office Internet Server Cache,," "./rip.exe -r NTUSER.DAT -p oisc"
Executa-Comandos "onedrive" "Gets contents of user's OneDrive key,," "./rip.exe -r NTUSER.DAT -p onedrive"
Executa-Comandos "onedrive_tln" "Gets contents of user's OneDrive key,," "./rip.exe -r NTUSER.DAT -p onedrive_tln"
Executa-Comandos "osversion" "Checks for OSVersion value,," "./rip.exe -r NTUSER.DAT -p osversion"
Executa-Comandos "osversion_tln" "Checks for OSVersion value (TLN),," "./rip.exe -r NTUSER.DAT -p osversion_tln"
Executa-Comandos "pagefile" "Get info on pagefile(s),," "./rip.exe -r System -p pagefile"
Executa-Comandos "pending" "Gets contents of PendingFileRenameOperations value,," "./rip.exe -r System -p pending"
Executa-Comandos "pendinggpos" "Gets contents of user's PendingGPOs key,," "./rip.exe -r NTUSER.DAT -p pendinggpos"
Executa-Comandos "photos" "Shell/BagMRU traversal in Win7 USRCLASS.DAT hives,," "./rip.exe -r USRCLASS.DAT -p photos"
Executa-Comandos "portdev" "Parses Windows Portable Devices key contents,," "./rip.exe -r Software -p portdev"
Executa-Comandos "powershellcore" "Extracts PowerShellCore settings,," "./rip.exe -r Software -p powershellcore"
Executa-Comandos "prefetch" "Gets the the Prefetch Parameters,," "./rip.exe -r System -p prefetch"
Executa-Comandos "printdemon" "Gets value assoc with printer ports and descriptions,," "./rip.exe -r Software -p printdemon"
Executa-Comandos "printer_settings" " Software,Check printer attributes for KeepPrintedJobs setting," "./rip.exe -r System -p printer_settings"
Executa-Comandos "printmon" "Lists installed Print Monitors,," "./rip.exe -r System -p printmon"
Executa-Comandos "printmon_tln" "Lists installed Print Monitors,," "./rip.exe -r System -p printmon_tln"
Executa-Comandos "processor_architecture" "Get from the processor architecture from the System's environment key,," "./rip.exe -r System -p processor_architecture"
Executa-Comandos "profilelist" "Get content of ProfileList key,," "./rip.exe -r Software -p profilelist"
Executa-Comandos "profiler" " System,Environment profiler information," "./rip.exe -r NTUSER.DAT -p profiler"
Executa-Comandos "pslogging" " Software,Extracts PowerShell logging settings," "./rip.exe -r NTUSER.DAT -p pslogging"
Executa-Comandos "psscript" " NTUSER.DAT,Get PSScript.ini values," "./rip.exe -r Software -p psscript"
Executa-Comandos "putty" "Extracts the saved SshHostKeys for PuTTY.,," "./rip.exe -r NTUSER.DAT -p putty"
Executa-Comandos "rdpport" "Queries System hive for RDP Port,," "./rip.exe -r System -p rdpport"
Executa-Comandos "recentapps" "Gets contents of user's RecentApps key,," "./rip.exe -r NTUSER.DAT -p recentapps"
Executa-Comandos "recentapps_tln" "Gets contents of user's RecentApps key,," "./rip.exe -r NTUSER.DAT -p recentapps_tln"
Executa-Comandos "recentdocs" "Gets contents of user's RecentDocs key,," "./rip.exe -r NTUSER.DAT -p recentdocs"
Executa-Comandos "recentdocs_tln" "Gets contents of user's RecentDocs key (TLN),," "./rip.exe -r NTUSER.DAT -p recentdocs_tln"
Executa-Comandos "remoteaccess" "Get RemoteAccess AccountLockout settings,," "./rip.exe -r System -p remoteaccess"
Executa-Comandos "rlo" "Parse hive, check key/value names for RLO character," "./rip.exe -r All -p rlo"
Executa-Comandos "routes" "Get persistent routes from the Registry,," "./rip.exe -r System -p routes"
Executa-Comandos "run" " NTUSER.DAT,[Autostart] Get autostart key contents from Software hive," "./rip.exe -r Software -p run"
Executa-Comandos "runmru" "Gets contents of user's RunMRU key,," "./rip.exe -r NTUSER.DAT -p runmru"
Executa-Comandos "runmru_tln" "Gets contents of user's RunMRU key (TLN),," "./rip.exe -r NTUSER.DAT -p runmru_tln"
Executa-Comandos "runonceex" "Gets contents of RunOnceEx values,," "./rip.exe -r Software -p runonceex"
Executa-Comandos "runvirtual" " Software,Gets RunVirtual entries," "./rip.exe -r NTUSER.DAT -p runvirtual"
Executa-Comandos "runvirtual_tln" " Software,Gets RunVirtual entries," "./rip.exe -r NTUSER.DAT -p runvirtual_tln"
Executa-Comandos "ryuk_gpo" "Get GPO policy settings from Software hive related to Ryuk,," "./rip.exe -r Software -p ryuk_gpo"
Executa-Comandos "samparse" "Parse SAM file for user & group mbrshp info,," "./rip.exe -r SAM -p samparse"
Executa-Comandos "samparse_tln" "Parse SAM file for user acct info (TLN),," "./rip.exe -r SAM -p samparse_tln"
Executa-Comandos "schedagent" "Get SchedulingAgent key contents,," "./rip.exe -r Software -p schedagent"
Executa-Comandos "scriptleturl" " USRCLASS.DAT,Check CLSIDs for ScriptletURL subkeys," "./rip.exe -r Software -p scriptleturl"
Executa-Comandos "searchscopes" "Gets contents of user's SearchScopes key,," "./rip.exe -r NTUSER.DAT -p searchscopes"
Executa-Comandos "secctr" "Get data from Security Center key,," "./rip.exe -r Software -p secctr"
Executa-Comandos "secrets" "Get the last write time for the Policy\Secrets key,," "./rip.exe -r Security -p secrets"
Executa-Comandos "secrets_tln" "Get the last write time for the Policy\Secrets key,," "./rip.exe -r Security -p secrets_tln"
Executa-Comandos "securityproviders" "Gets SecurityProvider value from System hive,," "./rip.exe -r System -p securityproviders"
Executa-Comandos "services" "Lists services/drivers in Services key by LastWrite times,," "./rip.exe -r System -p services"
Executa-Comandos "sevenzip" "Gets records of histories from 7-Zip keys,," "./rip.exe -r NTUSER.DAT -p sevenzip"
Executa-Comandos "sfc" "Get SFC values,," "./rip.exe -r Software -p sfc"
Executa-Comandos "shares" "Get list of shares from System hive file,," "./rip.exe -r System -p shares"
Executa-Comandos "shc" "Gets SHC entries from user hive,," "./rip.exe -r NTUSER.DAT -p shc"
Executa-Comandos "shellbags" "Shell/BagMRU traversal in Win7+ USRCLASS.DAT hives,," "./rip.exe -r USRCLASS.DAT -p shellbags"
Executa-Comandos "shellbags_tln" "Shell/BagMRU traversal in Win7 USRCLASS.DAT hives,," "./rip.exe -r USRCLASS.DAT -p shellbags_tln"
Executa-Comandos "shellfolders" "Gets user's shell folders values,," "./rip.exe -r NTUSER.DAT -p shellfolders"
Executa-Comandos "shelloverlay" "Gets ShellIconOverlayIdentifiers values,," "./rip.exe -r Software -p shelloverlay"
Executa-Comandos "shimcache" "Parse file refs from System hive AppCompatCache data,," "./rip.exe -r System -p shimcache"
Executa-Comandos "shimcache_tln" "Parse file refs from System hive AppCompatCache data,," "./rip.exe -r System -p shimcache_tln"
Executa-Comandos "shutdown" "Gets ShutdownTime value from System hive,," "./rip.exe -r System -p shutdown"
Executa-Comandos "silentprocessexit" "Gets contents of SilentProcessExit key,," "./rip.exe -r Software -p silentprocessexit"
Executa-Comandos "silentprocessexit_tln" "Gets contents of SilentProcessExit key,," "./rip.exe -r Software -p silentprocessexit_tln"
Executa-Comandos "sizes" "Scans a hive file looking for binary value data of a min size (5000),," "./rip.exe -r All -p sizes"
Executa-Comandos "slack" "Parse hive, print slack space, retrieve keys/values" "./rip.exe -r All -p slack"
Executa-Comandos "slack_tln" "Parse hive, print slack space, retrieve keys/values" "./rip.exe -r All -p slack_tln"
Executa-Comandos "source_os" "Parse Source OS subkey values,," "./rip.exe -r System -p source_os"
Executa-Comandos "speech" "Get values from user's Speech key,," "./rip.exe -r NTUSER.DAT -p speech"
Executa-Comandos "speech_tln" "Get values from user's Speech key,," "./rip.exe -r NTUSER.DAT -p speech_tln"
Executa-Comandos "spp_clients" "Determines volumes monitored by VSS,," "./rip.exe -r Software -p spp_clients"
Executa-Comandos "srum" "Gets contents of SRUM subkeys,," "./rip.exe -r Software -p srum"
Executa-Comandos "ssid" "Get WZCSVC SSID Info,," "./rip.exe -r Software -p ssid"
Executa-Comandos "susclient" "Extracts SusClient* info, including HDD SN (if avail)," "./rip.exe -r Software -p susclient"
Executa-Comandos "svc" "Lists Services key contents by LastWrite time (CSV),," "./rip.exe -r System -p svc"
Executa-Comandos "svcdll" "Lists Services keys with ServiceDll values,," "./rip.exe -r System -p svcdll"
Executa-Comandos "svc_tln" "Lists Services key contents by LastWrite time (CSV),," "./rip.exe -r System -p svc_tln"
Executa-Comandos "syscache" "Parse SysCache.hve file,," "./rip.exe -r syscache -p syscache"
Executa-Comandos "syscache_csv" ",," "./rip.exe -r syscache -p syscache_csv"
Executa-Comandos "syscache_tln" ",," "./rip.exe -r syscache -p syscache_tln"
Executa-Comandos "sysinternals" "Checks for SysInternals apps keys,," "./rip.exe -r NTUSER.DAT -p sysinternals"
Executa-Comandos "sysinternals_tln" "Checks for SysInternals apps keys (TLN),," "./rip.exe -r NTUSER.DAT -p sysinternals_tln"
Executa-Comandos "systemindex" "Gets systemindex\..\Paths info from Windows Search key,," "./rip.exe -r Software -p systemindex"
Executa-Comandos "taskcache" "Checks TaskCache\Tree root keys (not subkeys),," "./rip.exe -r Software -p taskcache"
Executa-Comandos "taskcache_tln" "Checks TaskCache\Tree root keys (not subkeys),," "./rip.exe -r Software -p taskcache_tln"
Executa-Comandos "tasks" "Checks TaskCache\Tasks subkeys,," "./rip.exe -r Software -p tasks"
Executa-Comandos "tasks_tln" "Checks TaskCache\Tasks subkeys,," "./rip.exe -r Software -p tasks_tln"
Executa-Comandos "termcert" "Gets Terminal Server certificate,," "./rip.exe -r System -p termcert"
Executa-Comandos "termserv" " Software,Gets Terminal Server settings from System and Software hives," "./rip.exe -r System -p termserv"
Executa-Comandos "thispcpolicy" "Gets ThisPCPolicy values,," "./rip.exe -r Software -p thispcpolicy"
Executa-Comandos "timezone" "Get TimeZoneInformation key contents,," "./rip.exe -r System -p timezone"
Executa-Comandos "tracing" "Gets list of apps that can be traced,," "./rip.exe -r Software -p tracing"
Executa-Comandos "tracing_tln" "Gets list of apps that can be traced (TLN),," "./rip.exe -r Software -p tracing_tln"
Executa-Comandos "tsclient" "Displays contents of user's Terminal Server Client\Default key,," "./rip.exe -r NTUSER.DAT -p tsclient"
Executa-Comandos "tsclient_tln" "Displays contents of user's Terminal Server Client key (TLN),," "./rip.exe -r NTUSER.DAT -p tsclient_tln"
Executa-Comandos "typedpaths" "Gets contents of user's typedpaths key,," "./rip.exe -r NTUSER.DAT -p typedpaths"
Executa-Comandos "typedpaths_tln" "Gets contents of user's typedpaths key (TLN),," "./rip.exe -r NTUSER.DAT -p typedpaths_tln"
Executa-Comandos "typedurls" "Returns contents of user's TypedURLs key.,," "./rip.exe -r NTUSER.DAT -p typedurls"
Executa-Comandos "typedurlstime" "Returns contents of user's TypedURLsTime key.,," "./rip.exe -r NTUSER.DAT -p typedurlstime"
Executa-Comandos "typedurlstime_tln" "Returns contents of Win8 user's TypedURLsTime key (TLN).,," "./rip.exe -r NTUSER.DAT -p typedurlstime_tln"
Executa-Comandos "typedurls_tln" "Returns MRU for user's TypedURLs key (TLN),," "./rip.exe -r NTUSER.DAT -p typedurls_tln"
Executa-Comandos "uac" "Get Select User Account Control (UAC) Values from HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System,," "./rip.exe -r Software -p uac"
Executa-Comandos "uacbypass" " Software,Get possible UAC bypass settings," "./rip.exe -r USRCLASS.DAT -p uacbypass"
Executa-Comandos "uninstall" " NTUSER.DAT,Gets contents of Uninstall keys from Software, NTUSER.DAT hives" "./rip.exe -r Software -p uninstall"
Executa-Comandos "uninstall_tln" " NTUSER.DAT,Gets contents of Uninstall keys from Software, NTUSER.DAT hives(TLN format)" "./rip.exe -r Software -p uninstall_tln"
Executa-Comandos "usb" "Get USB key info,," "./rip.exe -r System -p usb"
Executa-Comandos "usbdevices" "Parses Enum\USB key for USB & WPD devices,," "./rip.exe -r System -p usbdevices"
Executa-Comandos "usbstor" "Get USBStor key info,," "./rip.exe -r System -p usbstor"
Executa-Comandos "userassist" "Displays contents of UserAssist subkeys,," "./rip.exe -r NTUSER.DAT -p userassist"
Executa-Comandos "userassist_tln" "Displays contents of UserAssist subkeys in TLN format,," "./rip.exe -r NTUSER.DAT -p userassist_tln"
Executa-Comandos "volinfocache" "Gets VolumeInfoCache from Windows Search key,," "./rip.exe -r Software -p volinfocache"
Executa-Comandos "wab" "Get WAB DLLPath settings,," "./rip.exe -r Software -p wab"
Executa-Comandos "wab_tln" "Get WAB DLLPath settings,," "./rip.exe -r Software -p wab_tln"
Executa-Comandos "watp" "Gets contents of Windows Advanced Threat Protection key,," "./rip.exe -r Software -p watp"
Executa-Comandos "wbem" "Get some contents from WBEM key,," "./rip.exe -r Software -p wbem"
Executa-Comandos "wc_shares" "Gets contents of user's WorkgroupCrawler/Shares subkeys,," "./rip.exe -r NTUSER.DAT -p wc_shares"
Executa-Comandos "winlogon_tln" "Alerts on values from the WinLogon key (TLN),," "./rip.exe -r Software -p winlogon_tln"
Executa-Comandos "winrar" "Get WinRAR\ArcHistory entries,," "./rip.exe -r NTUSER.DAT -p winrar"
Executa-Comandos "winrar_tln" "Get WinRAR\ArcHistory entries (TLN),," "./rip.exe -r NTUSER.DAT -p winrar_tln"
Executa-Comandos "winscp" "Gets user's WinSCP 2 data,," "./rip.exe -r NTUSER.DAT -p winscp"
Executa-Comandos "winver" "Get Windows version & build info,," "./rip.exe -r Software -p winver"
Executa-Comandos "winzip" "Get WinZip extract and filemenu values,," "./rip.exe -r NTUSER.DAT -p winzip"
Executa-Comandos "wordwheelquery" "Gets contents of user's WordWheelQuery key,," "./rip.exe -r NTUSER.DAT -p wordwheelquery"
Executa-Comandos "wordwheelquery_tln" "Gets contents of user's WordWheelQuery key,," "./rip.exe -r NTUSER.DAT -p wordwheelquery_tln"
Executa-Comandos "wow64" "Gets contents of WOW64\x86 key,," "./rip.exe -r Software -p wow64"
Executa-Comandos "wpdbusenum" "Get WpdBusEnum subkey info,," "./rip.exe -r System -p wpdbusenum"
Executa-Comandos "wrdata" "Collects WebRoot AV Data,," "./rip.exe -r Software -p wrdata"
Executa-Comandos "wrdata_tln" "Collects WebRoot AV Data,," "./rip.exe -r Software -p wrdata_tln"
Executa-Comandos "wsh_settings" "Gets WSH Settings,," "./rip.exe -r Software -p wsh_settings"

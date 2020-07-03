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
Executa-Comandos "uninstall" " NTUSER.DAT,Gets contents of Uninstall keys from Software, NTUSER.DAT hives" "./rip.exe -r NTUSER.DAT -p uninstall"

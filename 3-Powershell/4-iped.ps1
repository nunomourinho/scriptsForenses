$dataHoje=Get-Timestamp
$ficheiro="C:\Users\admlocal\Desktop\relatorio-iped\iped_" + $dataHoje + ".tex"

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

  Write-Host "Relatório: Escrita a seccao " $seccao " no ficheiro " $ficheiro
  Add-Content -Path $ficheiro -Value "\newpage"
  Add-Content -Path $ficheiro -Value "\section{$seccao}"
  }


function Executa-Comandos() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$msg, 
        [Parameter(Mandatory)]
        [string]$comandos
    )
    
  Write-Host  "Relatório:  $comandos "
  Add-Content -Path $ficheiro -Value "\textbf{Descrição do propósito:} $msg  \newline \newline"
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
    # $_ Variável do erro
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
  Add-Content -Path $ficheiro -Value "Início: $start "
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
cd C:\IPED-3.17.2\iped-3.17.2
Get-Timestamp
Escreve-Seccao "Processar Imagem pelo processador de evidências digitais IPED"
Executa-Comandos "Inventário e de processamento da imagem" "iped -d C:\imagem\CIF2020.001 -o c:\resultados"
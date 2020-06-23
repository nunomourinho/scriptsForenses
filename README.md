# scriptsForenses
Scripts para recolha de informação Forense

Têm como objetivo a recolha de informação em Windows, e a exportação dos resultados para LaTeX.

No LaTeX, para poder utilizar listagens, use o código:

``` latex
\tcbuselibrary{listings,breakable}
\tcbuselibrary{minted,skins}

\newtcblisting{bashcode}[1][]{
  listing engine=minted,
  colback=bashcodebg,
  colframe=black!70,
  listing only,
  minted style=colorful,
  minted language=bash,
  minted options={linenos=true,breaklines,breakanywhere, numbersep=3mm,texcl=true,#1},
  left=8mm,enhanced,breakable,
  overlay ={\begin{tcbclipinterior}\fill[black!25] (frame.south west)
            rectangle ([xshift=8mm]frame.north west);\end{tcbclipinterior}}
            
  overlay broken={\begin{tcbclipinterior}\fill[black!25] (frame.south west)
            rectangle ([xshift=8mm]frame.north west);\end{tcbclipinterior}}
}

\newtcblisting{powershell}[1][]{
  listing engine=minted,
  colback=bashcodebg,
  colframe=black!70,
  listing only,
  minted style=colorful,
  minted language=bash,
  minted options={linenos=true,breaklines,breakanywhere, numbersep=3mm,texcl=true,#1},
  left=8mm,enhanced,breakable,
  overlay ={\begin{tcbclipinterior}\fill[black!25] (frame.south west)
            rectangle ([xshift=8mm]frame.north west);\end{tcbclipinterior}}
            
  overlay broken={\begin{tcbclipinterior}\fill[black!25] (frame.south west)
            rectangle ([xshift=8mm]frame.north west);\end{tcbclipinterior}}
}


\newtcblisting{tempo}[1][]{
  listing engine=minted,
  colback=tempobg,
  colframe=black!70,
  listing only,
  minted style=colorful,
  minted language=bash,
  minted options={linenos=false,breaklines,texcl=true,#1},
  left=8mm,enhanced,breakable,
  overlay ={\begin{tcbclipinterior}\fill[black!25] (frame.south west)           
            rectangle ([]frame.north west);\end{tcbclipinterior}}
            
  overlay broken={\begin{tcbclipinterior}\fill[black!25] (frame.south west)
            rectangle ([]frame.north west);\end{tcbclipinterior}}
}

\newtcblisting{observacoes}[1][]{
  listing engine=minted,
  colback=red!5!white,
  colframe=red!75!black,
  listing only,
  minted style=colorful,
  minted language=html,
  title={Comentário aos resultados obtidos},
  minted options={linenos=false,breaklines,texcl=true,#1},
  left=8mm,enhanced,breakable,
  overlay ={\begin{tcbclipinterior}\fill[black!25] (frame.south west)           
            rectangle ([]frame.north west);\end{tcbclipinterior}}
            
  overlay broken={\begin{tcbclipinterior}\fill[black!25] (frame.south west)
            rectangle ([]frame.north west);\end{tcbclipinterior}}
}
\definecolor{bashcodebg}{rgb}{0.85,0.85,0.85}
\definecolor{tempobg}{rgb}{0.75,0.75,0.75}
\definecolor{observacoesbg}{rgb}{0.95,0.0,0.0}

```

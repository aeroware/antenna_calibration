%%
%% This is file `esapub.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% esapub.dtx  (with options: `class')
%% authblk.dtx  (with options: `package,subpack')
%% ===========================================================================
%% This LaTeX class file is provided free of charge by the author to assist
%% generating camera-ready copy for ESA publications. No warranty is implied,
%% either that the resulting format is correct or that the code runs without
%% errors. It is provided as is, in the hope that it may be found useful by
%% other contributors to ESA publications.
%% 
%% See the accompanying file esapub.tex for details of usage.
%% ===========================================================================
%% 
%% Copyright 1999 Patrick W Daly
%% Max-Planck-Institut f\"ur Aeronomie
%% Max-Planck-Str. 2
%% D-37191 Katlenburg-Lindau
%% Germany
%% E-mail: daly@linmpi.mpg.de
%%
%%
%% Modified in August 2005 (top and bottom margins, fonts affiliations and title, headers, paper size)  
%% by Anik De Groof
%% Centre for Plasma Astrophysics, K.U.Leuven
%% Celestijnenlaan 200B
%% B-3001 Leuven 
%% Belgium
%% E-mail: anik.degroof@wis.kuleuven.be
%%
%% -------------------------------------------------
\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesPackage{esapub}
          [2001/04/25 1.1 (PWD)]

\LoadClassWithOptions{article}
\AtEndOfPackage{%
\renewcommand*{\Authfont}{\bfseries}
\setlength{\affilsep}{2mm} \setcounter{Maxaffil}{1}}
\setlength{\textheight}{23.5truecm} \addtolength{\textheight}{\topskip}
\setlength{\textwidth}{17cm} \setlength{\columnsep}{1cm}

\setlength{\oddsidemargin}{0.5\paperwidth}
\addtolength{\oddsidemargin}{-0.5\textwidth}
\addtolength{\oddsidemargin}{-1in}
\setlength{\evensidemargin}{\oddsidemargin}
\setlength{\headheight}{12pt} \setlength{\headsep}{20pt}
\setlength{\topmargin}{0.5\paperheight}
\addtolength{\topmargin}{-0.5\textheight}
%\addtolength{\topmargin}{-\headheight}
%\addtolength{\topmargin}{-\headsep}
\addtolength{\topmargin}{-1.7in}

\setlength{\parindent}{0\p@} \setlength{\parskip}{10\p@ plus 1\p@ minus
1\p@}
\renewcommand\normalsize{%
   \@setfontsize\normalsize\@xpt\@xipt
   \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}
\normalsize

\renewcommand\section{\@startsection {section}{1}{\z@}%
          {-3.5ex \@plus -1ex \@minus -.2ex}%
          {2.3ex \@plus.2ex}%
          {\normalfont\normalsize\bfseries\MakeUppercase}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
          {-3.25ex\@plus -1ex \@minus -.2ex}%
          {1.5ex \@plus .2ex}%
          {\normalfont\normalsize\bfseries}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
          {-3.0ex\@plus -1ex \@minus -.2ex}%
          {1.8ex \@plus .2ex}%
          {\normalfont\normalsize\centering}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
          {3.25ex \@plus1ex \@minus.2ex}%
          {-1em}%
          {\normalfont\normalsize\bfseries}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
          {3.25ex \@plus1ex \@minus .2ex}%
          {-1em}%
          {\normalfont\normalsize\bfseries}}

\def\@seccntformat#1{\csname the#1\endcsname.\quad}
\renewenvironment{abstract}{%
  \if@twocolumn
    \section*{\abstractname}
  \else
    \begin{center}
      \textbf{\abstractname}\vspace{-0.5em}\vspace{\z@}
    \end{center}
    \quotation
  \fi
}{%
  \if!\@keywords!\else
    \par\vspace{5\p@}Key words: \@keywords.\fi
  \if@twocolumn\else
     \endquotation
  \fi
}
\def\keywords#1{\gdef\@keywords{#1}}
\def\@keywords{}
\def\ps@plain{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\thepage\hfil\slshape\leftmark}%
    \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
    \let\@mkboth\@gobbletwo
    }

\ps@plain
\renewcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \if@twocolumn
        \twocolumn[\@maketitle]%
    \else
      \newpage
      \global\@topnum\z@
      \@maketitle
    \fi
%    \thispagestyle{plain}\@thanks
    \thispagestyle{empty}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\def\@maketitle{%
  \newpage
  \null
  \vskip 2em \vskip 0.0cm%
  \begin{center}%
  \let \footnote \thanks
    {\normalfont\large\bfseries \MakeUppercase{\@title} \par}%
    \vskip 1.5em%
    {\normalsize
      \lineskip .5em \vskip 3mm%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
  \end{center}%
  \par
  \vskip 3.5em}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\itshape#1. #2}%
  \ifdim \wd\@tempboxa >\hsize \itshape
    #1. #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

\newcommand\biblab[1]{#1}

\renewenvironment{thebibliography}[1]
{\section*{\refname}%
\@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}%
\list
{\biblab{\@arabic\c@enumiv.}} % First arguement for list definition defines labels
{\settowidth\labelwidth{\biblab{#1}}%
\leftmargin\labelwidth
\advance\leftmargin\labelsep
\@openbib@code
\usecounter{enumiv}%
\let\p@enumiv\@empty
\renewcommand\theenumiv{\@arabic\c@enumiv}}%  Second arguement defines spacing
\sloppy
\clubpenalty4000
\@clubpenalty \clubpenalty
\widowpenalty4000%
\sfcode`\.\@m}
{\def\@noitemerr
{\@latex@warning{Empty `thebibliography' environment}}%
\endlist}

%%
%% \renewcommand\bibitem[2][]{\item\ignorespaces}

\AtBeginDocument{\@ifundefined{bibsep}{\newlength{\bibsep}}{}
                   \setlength{\bibsep}{4\p@ plus2\p@ minus2\p@}
                 \@ifundefined{bibhang}{\newlength{\bibhang}}{}
                   \setlength{\bibhang}{1em}
                 \let\bibfont=\relax}
%% Copyright 1997-1999 Patrick W Daly - revision November 2003 A. Kelly E-mail: kellya@astro.warwick.ac.uk
%% Max-Planck-Institut f\"ur Aeronomie
%% Max-Planck-Str. 2
%% D-37191 Katlenburg-Lindau
%% Germany
%% E-mail: daly@linmpi.mpg.de
\def\ModuleVersion#1[#2]{}
    \ModuleVersion{authblk}
          [2001/02/27 1.3 (PWD)]
%% authblk coding copyright (C) 1997 Patrick W. Daly
\newcommand\Authfont{\normalfont}
\newcommand\Affilfont{\normalfont\it} 
\newcommand\Authsep{, }
\newcommand\Authands{, and }
\newcommand\Authand{ and }
\newlength{\affilsep}\setlength{\affilsep}{1em}
\newlength{\@affilsep}
\newcounter{Maxaffil}
\setcounter{Maxaffil}{2}
\newcounter{authors}
\newcounter{affil}
\newif\ifnewaffil \newaffiltrue
\newcommand\AB@authnote[1]{\textsuperscript{\normalfont#1}}
\newcommand\AB@affilnote[1]{\textsuperscript{\normalfont#1}}
\providecommand\textsuperscript[1]{$^{#1}$}
\newcommand\AB@blk@and{\protect\Authfont\protect\AB@setsep}
\newcommand\AB@pand{\protect\and \protect\Authfont \protect\AB@setsep}
\@namedef{@sep1}{}
\@namedef{@sep2}{\Authand}
\newcommand\AB@affilsep{\protect\Affilfont}
\newcommand\AB@affilsepx{\protect\\\protect\Affilfont}
\newcommand\AB@setsep{\setlength{\@affilsep}{\affilsep}}
\newcommand\AB@resetsep{\setlength{\@affilsep}{\z@}}
\newcommand\AB@authlist{}
\newcommand\AB@affillist{}
\newcommand\AB@authors{}
\newcommand\AB@empty{}
\xdef\AB@author{\noexpand\AB@blk@and\@author}
\renewcommand\author[2][]%
      {\ifnewaffil\addtocounter{affil}{1}%
       \edef\AB@thenote{\arabic{affil}}\fi
      \if\relax#1\relax\def\AB@note{\AB@thenote}\else\def\AB@note{#1}%
        \setcounter{Maxaffil}{0}\fi
      \ifnum\value{authors}>1\relax
      \@namedef{@sep\number\c@authors}{\Authsep}\fi
      \addtocounter{authors}{1}%
      \begingroup
          \let\protect\@unexpandable@protect \let\and\AB@pand
          \def\thanks{\protect\thanks}\def\footnote{\protect\footnote}%
         \@temptokena=\expandafter{\AB@authors}%
         {\def\\{\protect\\[\@affilsep]\protect\Affilfont
              \protect\AB@resetsep}%
              \xdef\AB@author{\AB@blk@and#2}%
       \ifnewaffil\gdef\AB@las{}\gdef\AB@lasx{\protect\Authand}\gdef\AB@as{}%
           \xdef\AB@authors{\the\@temptokena\AB@blk@and}%
       \else
          \xdef\AB@authors{\the\@temptokena\AB@as\AB@au@str}%
          \global\let\AB@las\AB@lasx\gdef\AB@lasx{\protect\Authands}%
          \gdef\AB@as{\Authsep}%
       \fi
       \gdef\AB@au@str{#2}}%
         \@temptokena=\expandafter{\AB@authlist}%
         \let\\=\authorcr
         \xdef\AB@authlist{\the\@temptokena
           \protect\@nameuse{@sep\number\c@authors}%
           \protect\Authfont#2\AB@authnote{\AB@note}}%
      \endgroup
      \ifnum\value{authors}>2\relax
      \@namedef{@sep\number\c@authors}{\Authands}\fi
      \newaffilfalse
}
\newcommand\authorcr{\protect\\ \protect\Authfont \protect\AB@setsep}%
\newcommand\affil[2][]%
   {\newaffiltrue\let\AB@blk@and\AB@pand
      \if\relax#1\relax\def\AB@note{\AB@thenote}\else\def\AB@note{#1}%
        \setcounter{Maxaffil}{0}\fi
      \begingroup
        \let\protect\@unexpandable@protect
        \def\thanks{\protect\thanks}\def\footnote{\protect\footnote}%
        \@temptokena=\expandafter{\AB@authors}%
        {\def\\{\protect\\\protect\Affilfont}\xdef\AB@temp{#2}}%
         \xdef\AB@authors{\the\@temptokena\AB@las\AB@au@str
         \protect\\[\affilsep]\protect\Affilfont\AB@temp}%
         \gdef\AB@las{}\gdef\AB@au@str{}%
        {\def\\{, \ignorespaces}\xdef\AB@temp{#2}}%
        \@temptokena=\expandafter{\AB@affillist}%
        \xdef\AB@affillist{\the\@temptokena \AB@affilsep
          \AB@affilnote{\AB@note}\protect\Affilfont\AB@temp}%
      \endgroup
       \let\AB@affilsep\AB@affilsepx
}
\def\@author{}
\renewcommand\@author{\ifx\AB@affillist\AB@empty\AB@author\else
      \ifnum\value{affil}>\value{Maxaffil}\def\rlap##1{##1}%
    \AB@authlist\\[\affilsep]\AB@affillist
    \else  \AB@authors\fi\fi}
\let\AB@maketitle=\maketitle
\def\maketitle
  {{\renewenvironment{tabular}[2][]{\begin{center}}
                                   {\end{center}}
  \AB@maketitle}}
%% 
%% <<<<< End of generated file <<<<<<
%%
%% End of file `esapub.cls'.

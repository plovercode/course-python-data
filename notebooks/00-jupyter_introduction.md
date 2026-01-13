---
jupytext:
  formats: ipynb,md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.18.1
kernelspec:
  display_name: Python 3 (ipykernel)
  language: python
  name: python3
---

<p><font size="6"><b>Jupyter notebook INTRODUCTION </b></font></p>

> *© 2026, Joris Van den Bossche and Stijn Van Hoey  (<mailto:jorisvandenbossche@gmail.com>, <mailto:stijnvanhoey@gmail.com>). Licensed under [CC BY 4.0 Creative Commons](http://creativecommons.org/licenses/by/4.0/)*

---

```{code-cell} ipython3
from IPython.display import Image
Image(url='http://python.org/images/python-logo.gif')
```

# Introduction

+++

To run Python, we are going to use Jupyter Notebooks via JupyterLab for this course. Jupyter notebooks are common in data science and visualization and serve as a convenient common-denominator experience for running Python code interactively. Jupyter notebooks let us __execute and view the results of our Python code interactively__ within the notebook.

__JupyterLab__ is an application server with a web user interface from [Project Jupyter](https://jupyter.org/) that enables one to work with documents and activities such as __Jupyter notebooks__ (a notebook is a file stored on your computer as a JSON file).

+++

<div class="alert alert-info">

__INFO__

Jupyter Notebook files have the file extension `.ipynb` to distinguish them from plain-text files.
    
</div>

+++

<big><center>To run a cell: push the start triangle in the menu or type **SHIFT + ENTER/RETURN**<br><br>
![](../img/shiftenter.jpg)

+++

# Notebook cell types

+++

We will work in **Jupyter notebooks** during this course. A notebook is a collection of `cells`, that can contain different content:

+++

## Code

```{code-cell} ipython3
# Code cell, then we are using python
print('Hello DS')
```

```{code-cell} ipython3
DS = 10
print(DS + 5) # Yes, we advise to use Python 3 (!)
```

Writing code is what you will do most during this course!

+++

## Markdown

+++

Text cells, using Markdown syntax. With the syntax, you can make text **bold** or *italic*, amongst many other things...

+++

* list
* with
* items

[Link to interesting resources](https://www.youtube.com/watch?v=z9Uz1icjwrM) or images: ![images](https://upload.wikimedia.org/wikipedia/commons/c/c3/Python-logo-notext.svg)

> Blockquotes if you like them
> This line is part of the same blockquote.

+++

Mathematical formulas can also be incorporated (LaTeX it is...)
$$\frac{dBZV}{dt}=BZV_{in} - k_1 .BZV$$
$$\frac{dOZ}{dt}=k_2 .(OZ_{sat}-OZ) - k_1 .BZV$$

+++

Or tables:

course | points
 --- | --- 
 Math | 8
 Chemistry | 4

or tables with Latex..

 Symbool | verklaring
 --- | --- 
 $$BZV_{(t=0)}$$	      | initiële biochemische zuurstofvraag (7.33 mg.l-1)
 $$OZ_{(t=0)}$$	    | initiële opgeloste zuurstof (8.5 mg.l-1)
 $$BZV_{in}$$		  | input BZV(1 mg.l-1.min-1)
 $$OZ_{sat}$$		  | saturatieconcentratie opgeloste zuurstof (11 mg.l-1)
 $$k_1$$		      | bacteriële degradatiesnelheid (0.3 min-1)
 $$k_2$$		      | reäeratieconstante (0.4 min-1)

+++

Code can also be incorporated, but than just to illustrate:

+++

```python
BOT = 12
print(BOT)
```

+++

See also: https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet

+++

## HTML

+++

You can also use HTML commands, just check this cell:
<h3> html-adapted titel with &#60;h3&#62; </h3> <p></p>
<b> Bold text &#60;b&#62; </b> of <i>or italic &#60;i&#62; </i>

+++

## Headings of different sizes: section
### subsection
#### subsubsection

+++

# Notebook handling ESSENTIALS

+++

## Execution: SHIFT + ENTER

**REMEMBER**: To run a cell: <strike>push the start triangle in the menu or</strike> type **SHIFT + ENTER**

![](../img/shiftenter.jpg)

+++

## Completion: TAB
![](../img/tabbutton.jpg)

+++

* The **TAB** button is essential: It provides you all **possible actions** you can do after loading in a library *AND* it is used for **automatic autocompletion**:

```{code-cell} ipython3
import os
os.mkdir
```

```{code-cell} ipython3
my_very_long_variable_name = 3
```

```{raw-cell}
my_ + TAB
```

## Help: SHIFT + TAB
![](../img/shift-tab.png)

+++

* The  **SHIFT-TAB** combination is ultra essential to get information/help about the current operation

```{code-cell} ipython3
round(3.2)
```

```{code-cell} ipython3
import os
os.mkdir
```

```{code-cell} ipython3
# An alternative is to put a question mark behind the command
os.mkdir?
```

<div class="alert alert-success">
    <b>EXERCISE</b>: What happens if you put two question marks behind the command?
</div>

```{code-cell} ipython3
import glob
glob.glob??
```

## *edit* mode vs *command* mode

* *edit* mode means you're editing a cell, i.e. with your cursor inside a cell to type content -->  <font color="blue">blue colored border</font>
* *command* mode means you're NOT editing(!), i.e. NOT with your cursor inside a cell to type content --> selected cell has a grey border

To start editing, click inside a cell or 
<img src="../img/enterbutton.png" alt="Key enter" style="width:150px">

To stop editing,
<img src="../img/keyescape.png" alt="Key A" style="width:150px">

+++

## new cell A-bove
<img src="../img/keya.png" alt="Key A" style="width:150px">

Create a new cell above with the key A... when in *command* mode

+++

## new cell B-elow
<img src="../img/keyb.png" alt="Key B" style="width:150px">

Create a new cell below with the key B... when in *command* mode

+++

## CTRL + SHIFT + C

+++

Just do it!

+++

## Trouble...

+++

<div class="alert alert-danger">
    <b>NOTE</b>: When you're stuck, or things do crash: 
    <ul>
    <li> first try <code>Kernel</code> > <code>Interrupt</code> -> your cell should stop running
    <li> if no succes -> <code>Kernel</code> > <code>Restart</code> -> restart your notebook
    </ul>
</div>

+++

* **Stackoverflow** is really, really, really nice!

  http://stackoverflow.com/questions/tagged/python

+++

* Google search is with you!

+++

<big><center>**REMEMBER**: To run a cell: <strike>push the start triangle in the menu or</strike> type **SHIFT + ENTER**
![](../img/shiftenter.jpg)

+++

<div class="alert alert-info">

__Kernels?__

The JupyterLab docs define kernels as “separate processes started by the server that runs your code in different programming languages and environments.” When we open a Jupyter Notebook, that starts a kernel - a process - that is going to run the code. In this lesson, we’ll be using the Jupyter ipython kernel which lets us run Python 3 code interactively.

Using other Jupyter kernels for other programming languages would let us write and execute code in other programming languages in the same JupyterLab interface, like R, Java, Julia, Ruby, JavaScript, Fortran, etc.
</div>

+++

# some MAGIC...

+++

## `%psearch`

```{code-cell} ipython3
%psearch os.*dir
```

## `%%timeit`

```{code-cell} ipython3
%%timeit

mylist = range(1000)
for i in mylist:
    i = i**2
```

```{code-cell} ipython3
import numpy as np
```

```{code-cell} ipython3
%%timeit

np.arange(1000)**2
```

## `%whos`

```{code-cell} ipython3
%whos
```

## `%lsmagic`

```{code-cell} ipython3
%lsmagic
```

# Let's get started!

```{code-cell} ipython3
from IPython.display import FileLink, FileLinks
```

```{code-cell} ipython3
FileLinks('.', recursive=False)
```

The follow-up notebooks provide additional background (largely adopted from the [scientific python notes](http://www.scipy-lectures.org/), which you can explore on your own to get more background on the Python syntax if specific elements would not be clear. 

For now, we will work on the `python_rehearsal.ipynb` notebook, which is a short summary version of the other notebooks to quickly grasp the main elements

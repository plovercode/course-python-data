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

<p><font size="6"><b>01 - Pandas: Data Structures </b></font></p>

> *© 2026, Joris Van den Bossche and Stijn Van Hoey  (<mailto:jorisvandenbossche@gmail.com>, <mailto:stijnvanhoey@gmail.com>). Licensed under [CC BY 4.0 Creative Commons](http://creativecommons.org/licenses/by/4.0/)*

---

```{code-cell} ipython3
import pandas as pd
import matplotlib.pyplot as plt
```

# Introduction

+++

Let's directly start with importing some data: the `titanic` dataset about the passengers of the Titanic and their survival:

```{code-cell} ipython3
df = pd.read_csv("data/titanic.csv")
```

```{code-cell} ipython3
df.head()
```

Starting from reading such a tabular dataset, Pandas provides the functionalities to answer questions about this data in a few lines of code. Let's start with a few examples as illustration:

+++

<div class="alert alert-warning">
    
What is the age distribution of the passengers?

</div>

```{code-cell} ipython3
df['Age'].hist()
```

<div class="alert alert-warning">

How does the survival rate of the passengers differ between sexes?

</div>

```{code-cell} ipython3
df.groupby('Sex')[['Survived']].mean()
```

<div class="alert alert-warning">

Or how does the survival rate differ between the different classes of the Titanic? 

</div>

```{code-cell} ipython3
df.groupby('Pclass')['Survived'].mean().plot.bar()
```

<div class="alert alert-warning">

Are young people (e.g. < 25 years) likely to survive?

</div>

```{code-cell} ipython3
df['Survived'].mean()
```

```{code-cell} ipython3
df25 = df[df['Age'] <= 25]
df25['Survived'].mean()
```

All the needed functionality for the above examples will be explained throughout the course, but as a start: the data types to work with.

+++

# The pandas data structures: `DataFrame` and `Series`

+++

To load the pandas package and start working with it, we first import the package. The community agreed alias for pandas is `pd`,  which we will also use here:

```{code-cell} ipython3
import pandas as pd
```

Let's start with getting some data. 

In practice, most of the time you will import the data from some data source (text file, excel, database, ..), and Pandas provides functions for many different formats. 

But to start here, let's create a small dataset about a few countries manually from a dictionar of lists:

```{code-cell} ipython3
data = {'country': ['Belgium', 'France', 'Germany', 'Netherlands', 'United Kingdom'],
        'population': [11.3, 64.3, 81.3, 16.9, 64.9],
        'area': [30510, 671308, 357050, 41526, 244820],
        'capital': ['Brussels', 'Paris', 'Berlin', 'Amsterdam', 'London']}
countries = pd.DataFrame(data)
countries
```

The object created here is a **DataFrame**:

```{code-cell} ipython3
type(countries)
```

A `DataFrame` is a 2-dimensional, **tablular data structure** comprised of rows and columns. It is similar to a spreadsheet, a database (SQL) table or the data.frame in R.

<img align="center" width=50% src="../img/pandas/01_table_dataframe1.svg">

+++

A DataFrame can store data of different types (including characters, integers, floating point values, categorical data and more) in columns. In pandas, we can check the data types of the columns with the `dtypes` attribute:

```{code-cell} ipython3
countries.dtypes
```

## Each column in a `DataFrame` is a `Series`

When selecting a single column of a pandas `DataFrame`, the result is a pandas `Series`, a 1-dimensional data structure. 

To select the column, use the column label in between square brackets `[]`.

```{code-cell} ipython3
countries['population']
```

```{code-cell} ipython3
s = countries['population']
type(s)
```

## Pandas objects have attributes and methods

Pandas provides a lot of functionalities for the DataFrame and Series. The `.dtypes` shown above is an *attribute* of the DataFrame. Another example is the `.columns` attribute, returning the column names of the DataFrame:

```{code-cell} ipython3
countries.columns
```

In addition, there are also functions that can be called on a DataFrame or Series, i.e. *methods*. As methods are functions, do not forget to use parentheses `()`.

A few examples that can help exploring the data:

```{code-cell} ipython3
countries.head() # Top rows
```

```{code-cell} ipython3
countries.tail() # Bottom rows
```

The ``describe`` method computes summary statistics for each column:

```{code-cell} ipython3
countries['population'].describe()
```

**Sort**ing your data **by** a specific column is another important first-check:

```{code-cell} ipython3
countries.sort_values(by='population')
```

The **`plot`** method can be used to quickly visualize the data in different ways:

```{code-cell} ipython3
countries.plot()
```

However, for this dataset, it does not say that much:

```{code-cell} ipython3
countries['population'].plot.barh()  # or .plot(kind='barh')
```

<div class="alert alert-success">

**EXERCISE**:

* You can play with the `kind` keyword or accessor of the `plot` method in the figure above: 'line', 'bar', 'hist', 'density', 'area', 'pie', 'scatter', 'hexbin', 'box'

Note: doing `df.plot(kind="bar", ...)` or `df.plot.bar(...)` is exactly equivalent. You will see both ways in the wild.
    
</div>

+++

<div style="border: 5px solid #3776ab; border-radius: 2px; padding: 2em;">

## Python recap
    
Python objects have **attributes** and **methods**:
    
* Attribute: `obj.attribute` (no parentheses!) -> property of the object (pandas examples: `dtypes`, `columns`, `shape`, ..)
* Method: `obj.method()` (function call with parentheses) -> action (pandas examples: `mean()`, `sort_values()`, ...)

</div>

+++

# Importing and exporting data

+++

A wide range of input/output formats are natively supported by pandas:

* CSV, text
* SQL database
* Excel
* HDF5
* json
* html
* pickle
* sas, stata
* Parquet
* ...

```{code-cell} ipython3
# pd.read_
```

```{code-cell} ipython3
# countries.to_
```

<div class="alert alert-info">

**Note: I/O interface**

* All readers are `pd.read_...`
* All writers are `DataFrame.to_...`

</div>

+++

# Application on a real dataset

+++

Throughout the pandas notebooks, many of exercises will use the titanic dataset. This dataset has records of all the passengers of the Titanic, with characteristics of the passengers (age, class, etc. See below), and an indication whether they survived the disaster.


The available metadata of the titanic data set provides the following information:

VARIABLE   |  DESCRIPTION
------ | --------
Survived       | Survival (0 = No; 1 = Yes)
Pclass         | Passenger Class (1 = 1st; 2 = 2nd; 3 = 3rd)
Name           | Name
Sex            | Sex
Age            | Age
SibSp          | Number of Siblings/Spouses Aboard
Parch          | Number of Parents/Children Aboard
Ticket         | Ticket Number
Fare           | Passenger Fare
Cabin          | Cabin
Embarked       | Port of Embarkation (C = Cherbourg; Q = Queenstown; S = Southampton)

+++

<div class="alert alert-success">

**EXERCISE**:

* Read the CSV file (available at `data/titanic.csv`) into a pandas DataFrame. Call the result `df`.

<details><summary>Hints</summary>

- The read functions in pandas start with `pd.read_`. Combine this with TAB to see the options interactively.

</details>  

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df = pd.read_csv("data/titanic.csv")
```

<div class="alert alert-success">

**EXERCISE**:

* Quick exploration: show the first 5 rows of the DataFrame.

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df.head()
```

<div class="alert alert-success">

**EXERCISE**:

* How many records (i.e. rows) has the titanic dataset?

<details><summary>Hints</summary>

* The length of a DataFrame gives the number of rows (`len(..)`). Alternatively, you can check the "shape" (number of rows, number of columns) of the DataFrame using the `shape` attribute. 

</details>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(df)
```

<div class="alert alert-success">
    <b>EXERCISE</b>:

* Select the 'Age' column.

<details><summary>Hints</summary>

* Use the `[]` indexing notation and the column label (the name expressed as a string).

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Age']
```

<div class="alert alert-success">
    <b>EXERCISE</b>:

* Make a box plot of the Fare column.

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Fare'].plot.box()  # or .plot(kind='box')
```

<div class="alert alert-success">
    
**EXERCISE**:

* Sort the rows of the DataFrame by 'Age' column, with the oldest passenger at the top. Check the help of the `sort_values` function and find out how to sort from the largest values to the lowest values

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df.sort_values(by='Age', ascending=False)
```

---
# Acknowledgement


> This notebook is partly based on material of Jake Vanderplas (https://github.com/jakevdp/OsloWorkshop2014).

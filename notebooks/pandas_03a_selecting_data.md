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

<p><font size="6"><b>03 - Pandas: Indexing and selecting data - part I</b></font></p>


> *© 2026, Joris Van den Bossche and Stijn Van Hoey  (<mailto:jorisvandenbossche@gmail.com>, <mailto:stijnvanhoey@gmail.com>). Licensed under [CC BY 4.0 Creative Commons](http://creativecommons.org/licenses/by/4.0/)*

---

```{code-cell} ipython3
import pandas as pd
```

```{code-cell} ipython3
# redefining the example DataFrame

data = {'country': ['Belgium', 'France', 'Germany', 'Netherlands', 'United Kingdom'],
        'population': [11.3, 64.3, 81.3, 16.9, 64.9],
        'area': [30510, 671308, 357050, 41526, 244820],
        'capital': ['Brussels', 'Paris', 'Berlin', 'Amsterdam', 'London']}
countries = pd.DataFrame(data)
countries
```

# Subsetting data

+++

## Subset variables (columns)

+++

For a DataFrame, basic indexing selects the columns (cfr. the dictionaries of pure python)

Selecting a **single column**:

```{code-cell} ipython3
countries['area'] # single []
```

Remember that the same syntax can also be used to *add* a new columns: `df['new'] = ...`.

We can also select **multiple columns** by passing a list of column names into `[]`:

```{code-cell} ipython3
countries[['area', 'population']] # double [[]]
```

## Subset observations (rows)

+++

Using `[]`, slicing or boolean indexing accesses the **rows**:

+++

### Slicing

```{code-cell} ipython3
countries[0:4]
```

### Boolean indexing (filtering)

+++

Often, you want to select rows based on a certain condition. This can be done with *'boolean indexing'* (like a where clause in SQL) and comparable to numpy. 

The indexer (or boolean mask) should be 1-dimensional and the same length as the thing being indexed.

```{code-cell} ipython3
countries['area'] > 100000
```

```{code-cell} ipython3
countries[countries['area'] > 100000]
```

```{code-cell} ipython3
countries[countries['population'] > 50]
```

An overview of the possible comparison operations:

Operator   |  Description
------ | --------
==       | Equal
!=       | Not equal
\>       | Greater than
\>=       | Greater than or equal
\<       | Lesser than
<=       | Lesser than or equal

and to combine multiple conditions:

Operator   |  Description
------ | --------
&       | And (`cond1 & cond2`)
\|       | Or (`cond1 \| cond2`)

+++

<div class="alert alert-info" style="font-size:120%">
<b>REMEMBER</b>: <br><br>

So as a summary, `[]` provides the following convenience shortcuts:

* **Series**: selecting a **label**: `s[label]`
* **DataFrame**: selecting a single or multiple **columns**:`df['col']` or `df[['col1', 'col2']]`
* **DataFrame**: slicing or filtering the **rows**: `df['row_label1':'row_label2']` or `df[mask]`

</div>

+++

## Some other useful methods: `isin` and `string` methods

+++

The `isin` method of Series is very useful to select rows that may contain certain values:

```{code-cell} ipython3
s = countries['capital']
```

```{code-cell} ipython3
#s.isin?
```

```{code-cell} ipython3
s.isin(['Berlin', 'London'])
```

This can then be used to filter the dataframe with boolean indexing:

```{code-cell} ipython3
countries[countries['capital'].isin(['Berlin', 'London'])]
```

Let's say we want to select all data for which the capital starts with a 'B'. In Python, when having a string, we could use the `startswith` method:

```{code-cell} ipython3
string = 'Berlin'
```

```{code-cell} ipython3
string.startswith('B')
```

In pandas, these are available on a Series through the `str` namespace:

```{code-cell} ipython3
countries['capital'].str.startswith('B')
```

For an overview of all string methods, see: https://pandas.pydata.org/pandas-docs/stable/reference/series.html#string-handling

+++

# Exercises using the Titanic dataset

```{code-cell} ipython3
df = pd.read_csv("data/titanic.csv")
```

```{code-cell} ipython3
df.head()
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>Select all rows for male passengers and calculate the mean age of those passengers. Do the same for the female passengers.</li>
</ul>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

males = df[df['Sex'] == 'male']
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

males['Age'].mean()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df[df['Sex'] == 'female']['Age'].mean()
```

We will later see an easier way to calculate both averages at the same time with groupby.

+++

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>How many passengers older than 70 were on the Titanic?</li>
</ul>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(df[df['Age'] > 70])
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

(df['Age'] > 70).sum()
```

<div class="alert alert-success">

<b>EXERCISE</b>:

* Select the passengers that are between 30 and 40 years old?

<details><summary>Hints</summary>

- To combine multiple conditions, you can use `&` (and) or `|` (or). But you might need to use brackets, because those operators have a higher precedence than the comparison operators.

</details>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df[(df['Age'] > 30) & (df['Age'] <= 40)]
```

<div class="alert alert-success">

<b>EXERCISE</b>:

For a single string `name = 'Braund, Mr. Owen Harris'`, split this string (check the `split()` method of a string) and get the first element of the resulting list.
    
<details><summary>Hints</summary>

- No Pandas in this exercise, just standard Python.
- The `split()` method of a string returns a python list. Accessing elements of a python list can be done using the square brackets indexing (`a_list[i]`).
    
</details> 

</div>

```{code-cell} ipython3
name = 'Braund, Mr. Owen Harris'
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

name.split(",")[0]
```

<div class="alert alert-success">

<b>EXERCISE</b>:
    
Convert the solution of the previous exercise to all strings of the `Name` column at once. Split the 'Name' column on the `,`, extract the first part (the surname), and add this as new column 'Surname'. 
    
<details><summary>Hints</summary>

- Pandas uses the `str` accessor to use the string methods such as `split`, e.g. `.str.split(...)` as the equivalent of the `split()` method of a single string (note: there is a small difference in the naming of the first keyword argument: `sep` vs `pat`).
- The [`.str.get()`](https://pandas.pydata.org/docs/reference/api/pandas.Series.str.get.html#pandas.Series.str.get) can be used to get the n-th element of a list, which is what the `str.split()` returns. This is the equivalent of selecting an element of a single list (`a_list[i]`) but then for all values of the Series.
- One can chain multiple `.str` methods, e.g. `str.SOMEMETHOD(...).str.SOMEOTHERMETHOD(...)`.
    
</details>    

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Surname'] = df['Name'].str.split(",").str.get(0)
df['Surname']
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>Select all passenger that have a surname starting with 'Williams'.</li>
</ul>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df[df['Surname'].str.startswith('Williams')]
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>Select all rows for the passengers with a surname of more than 15 characters.</li>
</ul>
    
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df[df['Surname'].str.len() > 15]
```

# [OPTIONAL] more exercises

+++

For the quick ones among you, here are some more exercises with some larger dataframe with film data. These exercises are based on the [PyCon tutorial of Brandon Rhodes](https://github.com/brandon-rhodes/pycon-pandas-tutorial/) (so all credit to him!) and the datasets he prepared for that. You can download these data from here: [titles.csv](https://course-python-data.s3.eu-central-1.amazonaws.com/titles.csv) and [cast.csv](https://course-python-data.s3.eu-central-1.amazonaws.com/cast.csv) and put them in the `/notebooks/data` folder.

```{code-cell} ipython3
cast = pd.read_csv('data/cast.csv')
cast.head()
```

```{code-cell} ipython3
titles = pd.read_csv('data/titles.csv')
titles.head()
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>How many movies are listed in the titles dataframe?</li>
</ul>
    
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(titles)
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>What are the earliest two films listed in the titles dataframe?</li>
</ul>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

titles.sort_values('year').head(2)
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

titles.nsmallest(2, columns="year")
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>How many movies have the title "Hamlet"?</li>
</ul>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(titles[titles['title'] == 'Hamlet'])
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>List all of the "Treasure Island" movies from earliest to most recent.</li>
</ul>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

titles[titles['title'] == 'Treasure Island'].sort_values('year')
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>How many movies were made from 1950 through 1959?</li>
</ul>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(titles[(titles['year'] >= 1950) & (titles['year'] <= 1959)])
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(titles[titles['year'] // 10 == 195])
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>How many roles in the movie "Inception" are NOT ranked by an "n" value?</li>
</ul>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

inception = cast[cast['title'] == 'Inception']
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(inception[inception['n'].isna()])
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

inception['n'].isna().sum()
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>But how many roles in the movie "Inception" did receive an "n" value?</li>
</ul>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(inception[inception['n'].notna()])
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>Display the cast of the "Titanic" (the most famous 1997 one) in their correct "n"-value order, ignoring roles that did not earn a numeric "n" value.</li>
</ul>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

titanic = cast[(cast['title'] == 'Titanic') & (cast['year'] == 1997)]
titanic = titanic[titanic['n'].notna()]
titanic.sort_values('n')
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>List the supporting roles (having n=2) played by Brad Pitt in the 1990s, in order by year.</li>
</ul>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

brad = cast[cast['name'] == 'Brad Pitt']
brad = brad[brad['year'] // 10 == 199]
brad = brad[brad['n'] == 2]
brad.sort_values('year')
```

# Acknowledgement


> The optional exercises are based on the [PyCon tutorial of Brandon Rhodes](https://github.com/brandon-rhodes/pycon-pandas-tutorial/) (so all credit to him!) and the datasets he prepared for that.

---

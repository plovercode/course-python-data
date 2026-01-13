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

<p><font size="6"><b>08 - Pandas: Tidy data and reshaping</b></font></p>


> *© 2026, Joris Van den Bossche and Stijn Van Hoey  (<mailto:jorisvandenbossche@gmail.com>, <mailto:stijnvanhoey@gmail.com>). Licensed under [CC BY 4.0 Creative Commons](http://creativecommons.org/licenses/by/4.0/)*

---

```{code-cell} ipython3
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
```

# Tidy data

In a [tidy dataset](https://vita.had.co.nz/papers/tidy-data.pdf) (also sometimes called 'long-form' data or 'denormalized' data) each observation is stored in its own row and each column contains a single variable:

![](../img/tidy_data_scheme.png)

Consider the following example with measurements in different Waste Water Treatment Plants (WWTP):

```{code-cell} ipython3
data = pd.DataFrame({
   'WWTP': ['Destelbergen', 'Landegem', 'Dendermonde', 'Eeklo'],
   'Treatment A': [8.0, 7.5, 8.3, 6.5],
   'Treatment B': [6.3, 5.2, 6.2, 7.2]
})
data
```

This data representation is not "tidy":

- Each row contains two observations of pH (each from a different treatment)
- 'Treatment' (A or B) is a variable not in its own column, but used as column headers

+++

A "tidy" version would rather look like:

<table style="margin-left:0px;">
<thead>
<tr>
<th align="right"></th>
<th align="left">WWTP</th>
<th align="left">Treatment</th>
<th align="right">pH</th>
</tr>
</thead>
<tbody><tr>
<td align="right">0</td>
<td align="left">Destelbergen</td>
<td align="left">A</td>
<td align="right">8</td>
</tr>
<tr>
<td align="right">1</td>
<td align="left">Landegem</td>
<td align="left">A</td>
<td align="right">7.5</td>
</tr>
<tr>
<td align="right">2</td>
<td align="left">Dendermonde</td>
<td align="left">A</td>
<td align="right">8.3</td>
</tr>
<tr>
<td align="right">3</td>
<td align="left">Eeklo</td>
<td align="left">A</td>
<td align="right">6.5</td>
</tr>
<tr>
<td align="right">4</td>
<td align="left">Destelbergen</td>
<td align="left">B</td>
<td align="right">6.3</td>
</tr>
<tr>
<td align="right">5</td>
<td align="left">Landegem</td>
<td align="left">B</td>
<td align="right">5.2</td>
</tr>
<tr>
<td align="right">6</td>
<td align="left">Dendermonde</td>
<td align="left">B</td>
<td align="right">6.2</td>
</tr>
<tr>
<td align="right">7</td>
<td align="left">Eeklo</td>
<td align="left">B</td>
<td align="right">7.2</td>
</tr>
</tbody></table>

* Where each row is now one observation, i.e. one measurement for a certain location and treatment
* Each variable is its own column

+++

## Melt - from wide to long/tidy format

We can use `melt()` to make a dataframe longer, i.e. to make a *tidy* version of your data:

```{code-cell} ipython3
pd.melt(data)  #, id_vars=["WWTP"])
```

```{code-cell} ipython3
data_long = pd.melt(data, id_vars=["WWTP"], 
                    value_name="pH", var_name="Treatment")
data_long
```

The usage of the tidy data representation has some important benefits when working with `groupby` or data visualization libraries such as Seaborn:

```{code-cell} ipython3
data_long.groupby("Treatment")["pH"].mean()  # switch to `WWTP`
```

Applying Seaborn on the (wide) original format of the datadoes not fit as there is no way to link the two treatment columns to a certain representation:

```python
sns.catplot(data=data, x="WWTP", y="...", hue="...", kind="bar")  # this doesn't work that easily
```

Whereas using the long format, the "treatment" column can be represented by color (hue), e.g.

```{code-cell} ipython3
sns.catplot(data=data_long, x="WWTP", y="pH", 
            hue="Treatment", kind="bar")  # switch `WWTP` and `Treatment`
```

## Exercise with energy consumption data

To practice the "melt" operation, we are going to use a dataset from Fluvius (who operates and manages the gas and elektricity networks in Flanders) about the monthly consumption of elektricity and gas in 2021 (https://www.fluvius.be/sites/fluvius/files/2021-10/verbruiksgegevens-per-maand.xlsx).

This data is available as an Excel file.

+++ {"clear_cell": false}

<div class="alert alert-success">

**EXERCISE**:

* Read the "verbruiksgegevens-per-maand.xlsx" file (in the "data/" directory) into a DataFrame `df`.
* Drop the "Regio" column (this column has a constant value "Regio 1" and thus is not that interesting).

<details><summary>Hints</summary>

- Reading Excel files can be done with the `pd.read_excel()` function, passing the path to the file as first argument.
- To drop a column, use the `columns` keyword in the `drop()` method.

</details>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df = pd.read_excel("data/verbruiksgegevens-per-maand.xlsx")
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df = df.drop(columns=["Regio"])
df
```

+++ {"clear_cell": false}

<div class="alert alert-success">

**EXERCISE**:

The actual data (consumption numbers) is spread over multiple columns: one column per month. Make a tidy version of this dataset with a single "consumption" column, and an additional "time" column. 
    
Make sure to keep the "Hoofdgemeente", "Energie" and "SLP"  columns in the data set. The "SLP" column contains additional categories about the type of elektricity or gas consumption (eg household vs non-household consumption).

Use `pd.melt()` to create a long or tidy version of the dataset, and call the result `df_tidy`.

<details><summary>Hints</summary>

- If there are columns in the original dataset that you want to keep (with repeated values), pass those names to the `id_vars` keyword of `pd.melt()`.
- You can use the `var_name` and `value_name` keywords to directly specify the column names to use for the new variable and value columns.

</details>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_tidy = pd.melt(df, id_vars=["Hoofdgemeente", "Energie", "SLP"], var_name="time", value_name="consumption")
df_tidy
```

+++ {"clear_cell": false}

<div class="alert alert-success">

**EXERCISE**:

Convert the "time" column to a column with a datetime data type using `pd.to_datetime`.

<details><summary>Hints</summary>

* When using `pd.to_datetime`, remember to specify a `format`.

</details>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_tidy["time"] = pd.to_datetime(df_tidy["time"], format="%Y%m")
```

+++ {"clear_cell": false}

<div class="alert alert-success">

**EXERCISE**:

* Calculate the total consumption of elektricity and gas over all municipalities ("Hoofdgemeente") for each month. Assign the result to a dataframe called `df_overall`.
* Using `df_overall`, make a line plot of the consumption of elektricity vs gas over time. 
  * Create a separate subplot for elektricity and for gas, putting them next to each other. 
  * Ensure that the y-limit starts at 0 for both subplots.

<details><summary>Hints</summary>

* If we want to sum the consumption over all municipalities that means we should _not_ include this variable in the groupby keys. On the other hand, we want to calculate the sum *for each* month ("time") and *for each* category of elektricity/gas ("Energie").
* Creating a line plot with seaborn can be done with `sns.relplot(..., kind="line")`.
* If you want to split the plot into multiple subplots based on a variable, check the `row` or `col` keyword.
* The `sns.relplot` returns a "facet grid" object, and you can change an element of each of the subplots of this object using the `set()` method of this object. To set the y-limits, you can use the `ylim` keyword.
    
</details>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_overall = df_tidy.groupby(["time", "Energie"])[["consumption"]].sum() # or with .reset_index()
df_overall.head()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

facet = sns.relplot(x="time", y="consumption", col="Energie",
                    data=df_overall, kind="line")
facet.set(ylim=(0, None))
```

# Pivoting data

+++

## Cfr. excel

+++

People who know Excel, probably know the **Pivot** functionality:

+++

![](../img/pandas/pivot_excel.png)

+++

The data of the table:

```{code-cell} ipython3
excelample = pd.DataFrame({'Month': ["January", "January", "January", "January", 
                                  "February", "February", "February", "February", 
                                  "March", "March", "March", "March"],
                   'Category': ["Transportation", "Grocery", "Household", "Entertainment",
                                "Transportation", "Grocery", "Household", "Entertainment",
                                "Transportation", "Grocery", "Household", "Entertainment"],
                   'Amount': [74., 235., 175., 100., 115., 240., 225., 125., 90., 260., 200., 120.]})
```

```{code-cell} ipython3
excelample
```

```{code-cell} ipython3
excelample_pivot = excelample.pivot(index="Category", columns="Month", values="Amount")
excelample_pivot
```

Interested in *Grand totals*?

```{code-cell} ipython3
# sum columns
excelample_pivot.sum(axis=1)
```

```{code-cell} ipython3
# sum rows
excelample_pivot.sum(axis=0)
```

## Pivot is just reordering your data:

+++

Small subsample of the titanic dataset:

```{code-cell} ipython3
df = pd.DataFrame({'Fare': [7.25, 71.2833, 51.8625, 30.0708, 7.8542, 13.0],
                   'Pclass': [3, 1, 1, 2, 3, 2],
                   'Sex': ['male', 'female', 'male', 'female', 'female', 'male'],
                   'Survived': [0, 1, 0, 1, 0, 1]})
```

```{code-cell} ipython3
df
```

```{code-cell} ipython3
df.pivot(index='Pclass', columns='Sex', values='Fare')
```

```{code-cell} ipython3
df.pivot(index='Pclass', columns='Sex', values='Survived')
```

So far, so good...

+++

Let's now use the full titanic dataset:

```{code-cell} ipython3
df = pd.read_csv("data/titanic.csv")
```

```{code-cell} ipython3
df.head()
```

And try the same pivot (*no worries about the try-except, this is here just used to catch a loooong error*):

```{code-cell} ipython3
try:
    df.pivot(index='Sex', columns='Pclass', values='Fare')
except Exception as e:
    print("Exception!", e)
```

This does not work, because we would end up with multiple values for one cell of the resulting frame, as the error says: `duplicated` values for the columns in the selection. As an example, consider the following rows of our three columns of interest:

```{code-cell} ipython3
df.loc[[1, 3], ["Sex", 'Pclass', 'Fare']]
```

Since `pivot` is just restructering data, where would both values of `Fare` for the same combination of `Sex` and `Pclass` need to go?

Well, they need to be combined, according to an `aggregation` functionality, which is supported by the function`pivot_table`

+++

<div class="alert alert-danger">

<b>NOTE</b>:

 <ul>
  <li><b>Pivot</b> is purely restructering: a single value for each index/column combination is required.</li>
</ul>

</div>

+++

## Pivot tables - aggregating while pivoting

```{code-cell} ipython3
df = pd.read_csv("data/titanic.csv")
```

```{code-cell} ipython3
df.pivot_table(index='Sex', columns='Pclass', values='Fare')
```

<div class="alert alert-info">

<b>REMEMBER</b>:

* By default, `pivot_table` takes the **mean** of all values that would end up into one cell. However, you can also specify other aggregation functions using the `aggfunc` keyword.

</div>

```{code-cell} ipython3
df.pivot_table(index='Sex', columns='Pclass', 
               values='Fare', aggfunc='max')
```

```{code-cell} ipython3
df.pivot_table(index='Sex', columns='Pclass', 
               values='Fare', aggfunc='count')
```

<div class="alert alert-info">

<b>REMEMBER</b>:

 <ul>
  <li>There is a shortcut function for a <code>pivot_table</code> with a <code>aggfunc='count'</code> as aggregation: <code>crosstab</code></li>
</ul>
</div>

```{code-cell} ipython3
pd.crosstab(index=df['Sex'], columns=df['Pclass'])
```

## Exercises

+++ {"clear_cell": false}

<div class="alert alert-success">

__EXERCISE__

Make a pivot table with the survival rates for Pclass vs Sex.

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df.pivot_table(index='Pclass', columns='Sex', 
               values='Survived', aggfunc='mean')
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

fig, ax1 = plt.subplots()
(df.pivot_table(index='Pclass', columns='Sex', 
               values='Survived', aggfunc='mean')
   .plot.bar(rot=0, ax=ax1)
)
ax1.set_ylabel('Survival ratio')
```

+++ {"clear_cell": false}

<div class="alert alert-success">

__EXERCISE__

Make a table of the median Fare payed by aged/underaged vs Sex.

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Underaged'] = df['Age'] <= 18
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df.pivot_table(index='Underaged', columns='Sex', 
               values='Fare', aggfunc='median')
```

<div class="alert alert-success">

__EXERCISE__

A pivot table aggregates values for each combination of the new row index and column values. That reminds of the "groupby" operation.
    
Can you mimick the pivot table of the first exercise (a pivot table with the survival rates for Pclass vs Sex) using `groupby()`?

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_survival = df.groupby(["Pclass", "Sex"])["Survived"].mean().reset_index()
df_survival
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_survival.pivot(index="Pclass", columns="Sex", values="Survived")
```

# Reshaping with `stack` and `unstack`

+++

The docs say:

> Pivot a level of the (possibly hierarchical) column labels, returning a
DataFrame (or Series in the case of an object with a single level of
column labels) having a hierarchical index with a new inner-most level
of row labels.

Indeed... 
<img src="../img/pandas/schema-stack.svg" width=50%>

Before we speak about `hierarchical index`, first check it in practice on the following dummy example:

```{code-cell} ipython3
df = pd.DataFrame({'A':['one', 'one', 'two', 'two'], 
                   'B':['a', 'b', 'a', 'b'], 
                   'C':range(4)})
df
```

To use `stack`/`unstack`, we need the values we want to shift from rows to columns or the other way around as the index:

```{code-cell} ipython3
df = df.set_index(['A', 'B']) # Indeed, you can combine two indices
df
```

```{code-cell} ipython3
result = df['C'].unstack()
result
```

```{code-cell} ipython3
df = result.stack().reset_index(name='C')
df
```

<div class="alert alert-info">

<b>REMEMBER</b>:

 <ul>
  <li><b>stack</b>: make your data <i>longer</i> and <i>smaller</i> </li>
  <li><b>unstack</b>: make your data <i>shorter</i> and <i>wider</i> </li>
</ul>
</div>

+++

## Mimick pivot table

+++

To better understand and reason about pivot tables, we can express this method as a combination of more basic steps. In short, the pivot is a convenient way of expressing the combination of a `groupby` and `stack/unstack`.

```{code-cell} ipython3
df = pd.read_csv("data/titanic.csv")
```

```{code-cell} ipython3
df.head()
```

## Exercises

```{code-cell} ipython3
df.pivot_table(index='Pclass', columns='Sex', 
               values='Survived', aggfunc='mean')
```

<div class="alert alert-success">

<b>EXERCISE</b>:

 <ul>
  <li>Get the same result as above based on a combination of `groupby` and `unstack`</li>
  <li>First use `groupby` to calculate the survival ratio for all groups`unstack`</li>
  <li>Then, use `unstack` to reshape the output of the groupby operation</li>
</ul>
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df.groupby(['Pclass', 'Sex'])['Survived'].mean().unstack()
```

# [OPTIONAL] Exercises: use the reshaping methods with the movie data

+++

These exercises are based on the [PyCon tutorial of Brandon Rhodes](https://github.com/brandon-rhodes/pycon-pandas-tutorial/) (so credit to him!) and the datasets he prepared for that. You can download these data from here: [titles.csv](https://course-python-data.s3.eu-central-1.amazonaws.com/titles.csv) and [cast.csv](https://course-python-data.s3.eu-central-1.amazonaws.com/cast.csv) and put them in the `/notebooks/data` folder.

```{code-cell} ipython3
cast = pd.read_csv('data/cast.csv')
cast.head()
```

```{code-cell} ipython3
titles = pd.read_csv('data/titles.csv')
titles.head()
```

<div class="alert alert-success">

__EXERCISE__

Plot the number of actor roles each year and the number of actress roles each year over the whole period of available movie data.

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

grouped = cast.groupby(['year', 'type']).size()
table = grouped.unstack('type')
table.plot()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

cast.pivot_table(index='year', columns='type', values="character", aggfunc='count').plot() 
# for the values column to use in the aggfunc, take a column with no NaN values in order to count effectively all values
# -> at this stage: aha-erlebnis about crosstab function(!)
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

pd.crosstab(index=cast['year'], columns=cast['type']).plot()
```

<div class="alert alert-success">

__EXERCISE__

Plot the number of actor roles each year and the number of actress roles each year. Use kind='area' as plot type.

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

pd.crosstab(index=cast['year'], columns=cast['type']).plot.area()
```

<div class="alert alert-success">

__EXERCISE__

Plot the fraction of roles that have been 'actor' roles each year over the whole period of available movie data.

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

grouped = cast.groupby(['year', 'type']).size()
table = grouped.unstack('type').fillna(0)
(table['actor'] / (table['actor'] + table['actress'])).plot(ylim=[0, 1])
```

<div class="alert alert-success">

__EXERCISE__

Define a year as a "Superman year" when films of that year feature more Superman characters than Batman characters. How many years in film history have been Superman years?

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

c = cast
c = c[(c.character == 'Superman') | (c.character == 'Batman')]
c = c.groupby(['year', 'character']).size()
c = c.unstack()
c = c.fillna(0)
c.head()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

d = c.Superman - c.Batman
print('Superman years:')
print(len(d[d > 0.0]))
```

```{code-cell} ipython3

```

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

<p><font size="6"><b> 02 - Pandas: Basic operations on Series and DataFrames</b></font></p>


> *© 2026, Joris Van den Bossche and Stijn Van Hoey  (<mailto:jorisvandenbossche@gmail.com>, <mailto:stijnvanhoey@gmail.com>). Licensed under [CC BY 4.0 Creative Commons](http://creativecommons.org/licenses/by/4.0/)*

---

```{code-cell} ipython3
import pandas as pd

import numpy as np
import matplotlib.pyplot as plt
```

```{code-cell} ipython3
# redefining the example DataFrame

countries = pd.DataFrame({'country': ['Belgium', 'France', 'Germany', 'Netherlands', 'United Kingdom'],
        'population': [11.3, 64.3, 81.3, 16.9, 64.9],
        'area': [30510, 671308, 357050, 41526, 244820],
        'capital': ['Brussels', 'Paris', 'Berlin', 'Amsterdam', 'London']})
```

```{code-cell} ipython3
countries.head()
```

# Elementwise-operations

+++

The typical arithmetic (+, -, \*, /) and comparison (==, >, <, ...) operations work *element-wise*.

With as scalar:

```{code-cell} ipython3
population = countries['population']
population
```

```{code-cell} ipython3
population * 1000
```

```{code-cell} ipython3
population > 50
```

With two Series objects:

```{code-cell} ipython3
countries['population'] / countries['area']
```

## Adding new columns

We can add a new column to a DataFrame with similar syntax as selecting a columns: create a new column by assigning the output to the DataFrame with a new column name in between the `[]`.

For example, to add the population density calculated above, we can do:

```{code-cell} ipython3
countries['population_density'] = countries['population'] / countries['area'] * 1e6
```

```{code-cell} ipython3
countries
```

<div class="alert alert-warning">

**REMEMBER**

Create a __new column__ by assigning the output to the DataFrame with a __new column name in between the []__.

</div>

+++

# Aggregations (reductions)

+++

Pandas provides a large set of **summary** functions that operate on different kinds of pandas objects (DataFrames, Series, Index) and produce single value. When applied to a DataFrame, the result is returned as a pandas Series (one value for each column).

+++

The average population number:

```{code-cell} ipython3
population.mean()
```

The minimum area:

```{code-cell} ipython3
countries['area'].min()
```

For dataframes, we get a Series with one value for each column (in this case of mixed data types, we need to specify to only calculate the median of the numeric column, as trying to calculate the median of a string column would raise an error):

```{code-cell} ipython3
countries.median(numeric_only=True)
```

# Application on a real dataset

+++

Reading in the titanic data set...

```{code-cell} ipython3
df = pd.read_csv("data/titanic.csv")
```

Quick exploration first...

```{code-cell} ipython3
df.head()
```

```{code-cell} ipython3
len(df)
```

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

**EXERCISE**

What is the average age of the passengers?

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Age'].mean()
```

<div class="alert alert-success">

**EXERCISE**

Plot the age distribution of the titanic passengers

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Age'].plot.hist()  # bins=30, log=True)
```

<div class="alert alert-success">

**EXERCISE**

What is the survival rate? (the relative number of people that survived)

<details><summary>Hints</summary>

- the 'Survived' column indicates whether someone survived (1) or not (0). 

</details>
    
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Survived'].sum() / len(df['Survived'])
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Survived'].mean()
```

<div class="alert alert-success">

**EXERCISE**

What is the maximum Fare? And the median?

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Fare'].max()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Fare'].median()
```

<div class="alert alert-success">

**EXERCISE**
    
Calculate the 75th percentile (`quantile`) of the Fare price 
    
<details><summary>Hints</summary>

- look in the 'docstring' how to specify the percentile, either range [0, 1] or [0, 100]

</details>    

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Fare'].quantile(0.75)
```

<div class="alert alert-success">

**EXERCISE**

Calculate the scaled Fares (scaled relative to its mean), and add this as a new column ('Fare_scaled') to the DataFrame.

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Fare'] / df['Fare'].mean()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['Fare_scaled'] = df['Fare'] / df['Fare'].mean()
df.head()
```

<div class="alert alert-success">

**EXERCISE**

* Calculate the log of the Fares. 
    
<details><summary>Hints</summary>

- check the `np.log` function.

</details>  

</div>

```{code-cell} ipython3
import numpy as np
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

np.log(df['Fare'])
```

# Numpy -  multidimensional data arrays

+++

NumPy is the fundamental package for scientific computing with Python. It contains among other things:

* a powerful N-dimensional array/vector/matrix object
* sophisticated (broadcasting) functions
* function implementation in C/Fortran assuring good performance if vectorized
* tools for integrating C/C++ and Fortran code
* useful linear algebra, Fourier transform, and random number capabilities

Also known as *array oriented computing*. The recommended convention to import numpy is:

```{code-cell} ipython3
import numpy as np
```

## Speed

+++

Memory-efficient container that provides fast numerical operations:

```{code-cell} ipython3
L = range(1000)
%timeit [i**2 for i in L]
```

```{code-cell} ipython3
a = np.arange(1000)
%timeit a**2
```

## It's used by Pandas under the hood

+++

The columns of a DataFrame are internally stored using numpy arrays. We can also retrieve this data as numpy arrays, for example using the `to_numpy()` method:

```{code-cell} ipython3
arr = countries["population"].to_numpy()
arr
```

What we said above about element-wise operations and reductions works the same for numpy arrays:

```{code-cell} ipython3
arr + 10
```

```{code-cell} ipython3
arr.mean()
```

Numpy contains more numerical functions than pandas, for example to calculate the log:

```{code-cell} ipython3
np.log(arr)
```

Those functions can *also* be applied on pandas objects:

```{code-cell} ipython3
np.log(countries["population"])
```

<div class="alert alert-info">

__NumPy__ provides

* multi-dimensional, homogeneously typed arrays  (single data type!)

<br>

__Pandas__ provides

* 2D, heterogeneous data structure (multiple data types!)
* labeled (named) row and column index

</div>

+++

# Acknowledgement


> This notebook is partly based on material of Jake Vanderplas (https://github.com/jakevdp/OsloWorkshop2014).

---

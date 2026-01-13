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

<p><font size="6"><b>07 - Pandas: Working with missing data </b></font></p>


> *© 2026, Joris Van den Bossche and Stijn Van Hoey  (<mailto:jorisvandenbossche@gmail.com>, <mailto:stijnvanhoey@gmail.com>). Licensed under [CC BY 4.0 Creative Commons](http://creativecommons.org/licenses/by/4.0/)*

---

```{code-cell} ipython3
import numpy as np
import pandas as pd
```

```{code-cell} ipython3
df = pd.DataFrame({'A': [1, 2, np.nan],
                   'B': [4, np.nan, np.nan],
                   'C': [7, 8, 9]})
df
```

## Missing values in Pandas

+++

For numerical data, the "NaN" (Not-A-Number) floating point value is used as missing value indicator:

```{code-cell} ipython3
df.loc[2, 'A']
```

```{code-cell} ipython3
np.nan
```

<div class="alert alert-warning">

**NOTE**: because NaN is a float value, it is currently not possible to have integer columns with missing values. Notice how the columns in the example above were casted to float dtype.

</div>

+++

### Missing values are skipped by default in *reductions*

```{code-cell} ipython3
df['A'].mean()
```

```{code-cell} ipython3
df['A'].mean(skipna=False)
```

### ... but propagated in *element-wise arithmetic*

```{code-cell} ipython3
df['A'] + 3
```

## Checking missing values

+++

Checking for a missing value cannot be done with an equality operation (`==`) because NaN is not equal to iself:

```{code-cell} ipython3
df['A'] == np.nan
```

```{code-cell} ipython3
np.nan == np.nan
```

Therefore, dedicated methods are available: `isna()` and `notna()`

```{code-cell} ipython3
df['A'].isna()
```

```{code-cell} ipython3
df['A'].notna()
```

```{code-cell} ipython3
df['A'].isna().sum()
```

```{code-cell} ipython3
df.isna().sum()
```

```{code-cell} ipython3
df
```

## Dropping missing values

+++

Dropping missing values can be done with `isna()`/`notna()` and boolean indexing (eg `df[df['A'].notna()]`), but pandas also provides some convenient helper functions for this:

```{code-cell} ipython3
df.dropna()
```

By default it drop rows if there is a NaN in any of the columns. To limit this to we subset of the columns, use the `subset` keyword:

```{code-cell} ipython3
df.dropna(subset=['A', 'C'])
```

## Filling missing values

+++

Filling missing values with a scalar:

```{code-cell} ipython3
df.fillna(0)
```

Further, more advanced filling techniques are available in the ``interpolate()`` method.

+++

<div class="alert alert-info" style="font-size:120%">

**REMEMBER**: <br>

* Missing value indicator: `np.nan` (`NaN`)
* Reductions: skipped by default
* Mathematical operations (eg `+`): propagate by default
* Specific functions:
    * `isna()`, `notna()`
    * `dropna()`
    * `fillna()`, `interpolate()`

</div>

```{code-cell} ipython3

```

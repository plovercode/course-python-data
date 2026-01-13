---
jupytext:
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

<p><font size="6"><b>06 - Pandas: Methods for data cleaning</b></font></p>

> *© 2026, Joris Van den Bossche and Stijn Van Hoey  (<mailto:jorisvandenbossche@gmail.com>, <mailto:stijnvanhoey@gmail.com>). Licensed under [CC BY 4.0 Creative Commons](http://creativecommons.org/licenses/by/4.0/)*

---

```{code-cell} ipython3
import pandas as pd

import numpy as np
import matplotlib.pyplot as plt
```

A number of Pandas functions are useful when cleaning up raw data and converting it to a data set ready for analysis and visualisation. In this notebook a selection of methods are introduced:

- `drop`
- `rename`
- `replace`
- `explode`
- `drop_duplicates`/`duplicates`
- `astype`
- `unique`
- `.str.`-methods

__Note:__ Working with _missing values_ is tackled in a dedicated notebook [pandas_07_missing_values](./pandas_07_missing_values.ipynb).

+++

We showcase using a _dirty_ example data:

```{code-cell} ipython3
countries = pd.DataFrame({'county name': ['Belgium', 'Flance', 'Germany', 'Netherlands', ['United Kingdom', 'Germany']],
                          'population': [11.3, 64.3, 81.3, 16.9, 64.9],
                          'area': [30510, 671308, 357050, 41526, [244820, np.nan]],
                          'capital': ['Brussels', ' Paris         ', 'Barlin', 'Amsterdam', 'London']})
countries
```

## `drop`

+++

Drop columns (or rows) by name (this can also be achieved by selecting the columns you want to keep, but if you only want to drop a few columns, `drop()` is easier). Specify a list of column names to drop:

```{code-cell} ipython3
countries.drop(columns=["area", "capital"])
```

## `rename`

+++

Use a `dict` with the dictionary keys the old column/index name and the dictionary values the new column/index name:

```{code-cell} ipython3
countries = countries.rename(columns={"county name": "country"})
```

## `replace`

+++

Replace values in a column. Different inputs can be used. The most basic one is providing a value `to_replace` and a new `value`:

```{code-cell} ipython3
countries["capital"].replace("Barlin", "Berlin")
```

Similar to `rename`, one can use a `dict` with the dictionary keys the old data and the dictionary values the new data:

```{code-cell} ipython3
countries = countries.replace({"Barlin": "Berlin", "Flance": "France"})
countries
```

## `explode`

+++

[`explode`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.explode.html) multiple values in a cell to individual records (rows). Not regularly required, but very powerful when in case:

```{code-cell} ipython3
countries_exploded = countries.explode(["country", "area"])
countries_exploded
```

## `drop_duplicates`

+++

Checking duplicate values in a data set with [`duplicated`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.duplicated.html) or remove duplicate values with [`drop_duplicates`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.drop_duplicates.html):

```{code-cell} ipython3
countries_exploded.duplicated(subset=["country"])
```

```{code-cell} ipython3
countries_exploded = countries_exploded.drop_duplicates(subset=["country"], keep="first").copy()  # More on this copy later
countries_exploded
```

## `astype`

+++

Pandas read functions might not always use the most appropriate data type for each of the columns. Converting them to a different data type can also improve the memory usage of the DataFrame (e.g. `int16` versus `float64`). The [`astype` ](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.astype.html) method supports data type conversion to both [Numpy data types](https://numpy.org/doc/stable/user/basics.types.html) as well as [Pandas specific data types](https://pandas.pydata.org/docs/user_guide/basics.html#dtypes).

```{code-cell} ipython3
countries_exploded.dtypes
```

```{code-cell} ipython3
countries_exploded["area"] = countries_exploded["area"].astype(int)
```

```{code-cell} ipython3
countries_exploded.dtypes
```

## `unique`

+++

Working with larger data sets, knowing which values are in a column:

```{code-cell} ipython3
countries_exploded["capital"].unique()
```

## `.str.`-methods

+++

Noticed the redundant spaces in the capital column? 

Whereas `replace` could work for this specific case (it also accepts _regular expressions_):

```python
countries_exploded["capital"].replace(r"^\s+|\s+", "", regex=True)
```

Pandas provides a set of convenient __string__ methods to handle these (element-wise) cleaning of strings, each of them accessible with the `.str.` accessor (e.g. `str.split`, `str.startswith`, `removeprefix`):

```{code-cell} ipython3
countries_exploded["capital"] = countries_exploded["capital"].str.strip()
countries_exploded["capital"].unique()
```

<div class="alert alert-info">
    
__INFO__

For an overview of the available `.str.`-methods, see https://pandas.pydata.org/docs/user_guide/text.html#method-summary

</div>

+++

## Exercises: application on a real dataset

+++

For these exercises, we will use data of road casualties in Belgium in 2020 [made available by statbel](https://statbel.fgov.be/en/open-data/road-casualties-2020). The [metadata](https://statbel.fgov.be/sites/default/files/files/opendata/Verkeersslachtoffers/TF_ACCIDENTS_VICTIMS_META.xlsx) is available as well as a reference. The data contains the number of victims due to road causalities:

- `MS_VCT`: Number of victims
- `MS_VIC_OK`: Number of uninjured
- `MS_SLY_INJ`: Number of slightly injured
- `MS_SERLY_INJ`: Number of severely injured
- `MS_MORY_INJ`: Number of mortally injured
- `MS_DEAD`: Number of dead
- `MS_DEAD_30_DAYS`: Number of dead after 30 days

Together with metadata about date and time, the victim and road type, light conditions, location,...

Pandas can load the data directly from the `zip`-file :

```{code-cell} ipython3
casualties_raw = pd.read_csv("./data/TF_ACCIDENTS_VICTIMS_2020.zip", 
                         compression='zip', 
                         sep="|", 
                         low_memory=False)
casualties_raw.head()
```

<div class="alert alert-info">
    
__INTERMEZZO - display options__

Pandas provides a number of configurable settings to display data, for example `display.max_rows`, `display.precision` and `display.max_columns`. When exploring a new data set, adjusting the `display.max_columns` setting is of particular interest to be able to scroll the full data set.
    
See https://pandas.pydata.org/docs/user_guide/options.html#options-and-settings for the documentation and an [overview of the available settings](https://pandas.pydata.org/docs/user_guide/options.html#available-options)

</div>

```{code-cell} ipython3
pd.options.display.max_columns = 45
```

```{code-cell} ipython3
casualties_raw.head()
```

Whereas the data is already well organised and structured, some adjustments are required to support further analysis:

- Combine the day and hour into a single datetime-aware data type.
- Clean up the column names.
- Metadata is always provided both in Dutch and French.
- ...

Let's apply the cleaning methods to clean up the data in the next set of exercises.

+++

<div class="alert alert-success">

**EXERCISE**

Check the unique values of the `TX_SEX_DESCR_NL` column.

Based on the the values, create a mapping dictionary to replace the values with the english version (`"Mannelijk" -> "male", "Vrouwelijk" -> "female"`). Use `None` for the unknown values (`Onbekend` in Dutch). Apply the mapping to overwrite the values in the `TX_SEX_DESCR_NL` column with the new value.

<details><summary>Hints</summary>
    
- Create the mapping by hand and define a Python dictionary.
- Use the `replace()` method to update the values of the `TX_SEX_DESCR_NL` column. You can call this method on the column (Series object).

</details>

</div>

```{code-cell} ipython3
casualties_raw["TX_SEX_DESCR_NL"]
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

casualties_raw["TX_SEX_DESCR_NL"].unique()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

gender_mapping = {"Vrouwelijk": "female", "Mannelijk": "male", "Onbekend": None}
casualties_raw["TX_SEX_DESCR_NL"] = casualties_raw["TX_SEX_DESCR_NL"].replace(gender_mapping)
casualties_raw["TX_SEX_DESCR_NL"].unique()
```

```{code-cell} ipython3
casualties_raw["TX_SEX_DESCR_NL"]
```

<div class="alert alert-success">

**EXERCISE**

Check the unique values of the `DT_HOUR` column. Which of the data values is used as _not a number_ (not known)? Verify the amount of records that for which `DT_HOUR` is not known.
    
A check with the data provider confirmed that the record(s) with value 99 did actually happen at 9 AM and are a typo instead of _not a number_ replacement value. Replace the 99 values with the real hour of the day in the `DT_HOUR` column.

<details><summary>Hints</summary>
    
- The number `99` is not a valid hour of the day and used as _not a number_ data point.
- Only one data record has an unknown hour of the day.
- Remember the `replace()` method that we used in the previous exercise. We can again provide a mapping, or in this case of only replacing a single value, you can also provide the original value and new value as two positional arguments.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

casualties_raw["DT_HOUR"].unique()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

(casualties_raw["DT_HOUR"] == 99).sum()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

casualties_raw["DT_HOUR"] = casualties_raw["DT_HOUR"].replace(99, 9)
```

<div class="alert alert-info">
    
__INTERMEZZO__ - List comprehensions

A [list comprehension](https://docs.python.org/3/glossary.html#term-list-comprehension) is a compact way to process all or part of the elements, comparable to a for-loop, in a sequence and return a list.
    
For example, the code in the following example:
    
```python
example = [2, 3, 4]
updated_example = []
for element in example:
    updated_example.append(element*2)
```    

will produce the same result `updated_example=[4, 6, 8]` as:

```python
updated_example = [element*2 for element in example]
```
    
The latter is a __list comprehension__, which is a more compact way of writing the for-loop to return the updated list.
    
The loop can also contain an if-statement, e.g.
    
```python
example = [2, 3, 4]
updated_example = []
for element in example:
    if element != 3:
        updated_example.append(element*2)
```

and

```python
updated_example = [element*2 for element in example if element != 3]
```
    
will both result in `[4, 8]`.   
</div>

+++

<div class="alert alert-success">

**EXERCISE**

Remove all the `_FR` metadata columns  from the `casualties_raw` data set and assign the result to a new variable `casualties_nl`. Use the `column_names_with_fr` variable derived in the next cell to remove the columns.

<details><summary>Hints</summary>
    
- Remove columns with the `drop()` method. The method works with one or more column names.
- Make sure to explicitly set the `columns=` parameter.

__NOTE__ The `column_names_with_fr` variable is created using the `df.columns` attribute of the DataFrame:
- Instead of enlisting the column names manually, a [list comprehension](https://docs.python.org/3/tutorial/datastructures.html#list-comprehensions) - a _feature of standard Python_ - is used to select the columns names ending on `_FR`. Loop over the column names in `casualties_raw.columns`.
- Within the list comprehension, the [`endswith()`](https://docs.python.org/3/library/stdtypes.html#str.endswith) standard string method is used to check if a column name ends on `_FR`. 
- ! Pandas also provides the `.str.endswith()` method, but this is for the data values inside a DataFrame. In this exercise we want to adjust the column names itself.    
    
</details>

</div>

```{code-cell} ipython3
column_names_with_fr = [col for col in casualties_raw.columns if col.endswith("_FR")]
column_names_with_fr
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

casualties_nl = casualties_raw.drop(columns=column_names_with_fr)
casualties_nl
```

<div class="alert alert-success">

**EXERCISE**

A number of the remaining metadata columns names have the `TX_` and the `_DESCR_NL` in the column name. Clean up these column names by removing the `TX_` at the start and the `_DESCR_NL` at the end of the column names using the helper function `clean_column_name` defined in the next cell. Update the `casualties_nl` variable, assign the result to the variable `casualties`.

<details><summary>Hints</summary>
    
- To rename columns, we can use the `rename()` method.
- The input of the `rename()` method can also be a function in addition to a dictionary. When passing a function to `rename()`, pandas will under the hood call this function for each the column name individually, and use the return value as the renamed column name.
- Make sure to explicitly set the `columns=` parameter.    
    
__NOTE__ The function `clean_column_name` takes as input a string and returns the string after removing the prefix and suffix. `removeprefix()` and `removesuffix()` are [Python string methods](https://docs.python.org/3/library/stdtypes.html#string-methods) to remove start/trailing characters if present.

</details>

</div>

```{code-cell} ipython3
def clean_column_name(name):
    """
    Takes a string and returns it after removing "TX_" and "_DESCR_NL".
    """
    return name.removeprefix("TX_").removesuffix("_DESCR_NL")

# example to show what the 'clean_column_name' function does
clean_column_name("TX_DAY_OF_WEEK_DESCR_NL")
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

casualties = casualties_nl.rename(columns=clean_column_name)
casualties.head()
```

<div class="alert alert-success">

**EXERCISE**

The day (`DT_DAY`) and hour (`DT_HOUR`) are two separate columns instead of a single `datetime` data type column. 
    
- Check the data types of the `DT_DAY` and `DT_HOUR` columns.
- Combine the two columns into a single column (using _string concatenation_) and use the `pd.to_datetime` function to convert the combined column (call the new column `"datetime"`).

<details><summary>Hints</summary>
    
- The data type of columns is available as the `dtypes` attribute.
- String concatenation is done element-wise in pandas using the `+` operator. Do not forget to convert the `DT_HOUR` column into a `str` column using the `astype()` before trying to concatenate it with the day.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

casualties[["DT_DAY", "DT_HOUR"]].dtypes
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

casualties["datetime"] = casualties["DT_DAY"] + " " + casualties["DT_HOUR"].astype(str)
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

casualties["datetime"] = pd.to_datetime(casualties["datetime"])
casualties["datetime"]
```

<div class="alert alert-success">

**EXERCISE**

For columns consisting of a limited number of categories with (_ordinal data_) or without a logical order, Pandas has a specific data type: `Categorical`. An example in the data set is the `DAY_OF_WEEK` (from `Monday` -> `Sunday`). 
    
For this conversion, the `astype` is not sufficient. Use the `pd.Categorical` function (check the documentation) to create a new column `week_day` with the week days defined as a Categorical variable. Use Monday as the first day of the week and make sure the categories are ordered.

<details><summary>Hints</summary>
    
- See [Pandas categorical info](https://pandas.pydata.org/pandas-docs/stable/user_guide/categorical.html#object-creation) for more information
- Use `ordered=True` to define ordered data.  

</details>

</div>

```{code-cell} ipython3
# Conversion to english weekday names
casualties["DAY_OF_WEEK"] = casualties["DAY_OF_WEEK"].replace({"maandag": "Monday", 
                                                               "dinsdag": "Tuesday", 
                                                               "woensdag": "Wednesday", 
                                                               "donderdag": "Thursday", 
                                                               "vrijdag": "Friday", 
                                                               "zaterdag": "Saturday", 
                                                               "zondag": "Sunday"})
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

casualties["week_day"] = pd.Categorical(casualties["DAY_OF_WEEK"], 
                                        categories=["Monday", "Tuesday", "Wednesday", "Thursday", 
                                                    "Friday", "Saturday", "Sunday"], 
                                        ordered=True)
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

casualties["week_day"].dtype
```

<div class="alert alert-success">

**(OPTIONAL) EXERCISE**

In the `AGE_CLS` column, the age is formatted as `X tot Y jaar` (i.e. _x till y year_). Remove the Dutch description and convert the data into a format `Y - Y` to define the age classes. 
    
Use the string methods as much as possible. The `Onbekend`, `  ` (empty string) and `75 jaar en meer` data values can be done by direct replacement into `None`, `None` and `> 75` respectively.

<details><summary>Hints</summary>
    
- Use the `.str.replace()` (note the difference with the Pandas `replace()` method) and the `str.removesuffix()` methods to convert the data format.
- Add an additional `str.strip` to get rid of the spaces and the 'unknown' number of spaces in the empty string case.
- Using the `replace()` method with a dictionary just works for the remaining two values:  `{"Onbekend": None, "75 jaar en meer": ">75"}`. It will leave other values (not specified in the dictionary) as is.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

casualties["AGE_CLS"] = casualties["AGE_CLS"].str.replace(" tot ", " - ").str.removesuffix(" jaar").str.strip()
casualties["AGE_CLS"] = casualties["AGE_CLS"].replace({"Onbekend": None, "75 jaar en meer": ">75", "": None})
```

```{code-cell} ipython3
# verify outcome
casualties["AGE_CLS"].unique()
```

<div class="alert alert-success">

**(OPTIONAL) EXERCISE**

The data set contains the number of victims. The link with the individual accidents is not available in the current data set and multiple records/rows of the data set can belong to a single accident. 
    
We can expect that records with the same day, hour, municipality , light condition, road type and build up area are probably linked to the same accident. Try to estimate the number of accidents.

<details><summary>Hints</summary>
    
- This exercise is a special case of the `drop_duplicates` method. When we drop duplicate records when `"DT_DAY", "DT_HOUR",  "CD_MUNTY_REFNIS", "BUILD_UP_AREA","LIGHT_COND", "ROAD_TYPE"` are all the same, we have an estimate on the number of accidents.
- Use the `subset` parameter to define a specific set of column names.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

unique_combinations = ["DT_DAY", "DT_HOUR",  "CD_MUNTY_REFNIS", "BUILD_UP_AREA","LIGHT_COND", "ROAD_TYPE"]
casualties.drop_duplicates(subset=unique_combinations).shape
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

# alternative using `duplicated`
(~casualties.duplicated(subset=unique_combinations)).sum()
```

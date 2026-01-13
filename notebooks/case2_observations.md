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

<p><font size="6"><b>CASE - Observation data</b></font></p>

> *© 2026, Joris Van den Bossche and Stijn Van Hoey  (<mailto:jorisvandenbossche@gmail.com>, <mailto:stijnvanhoey@gmail.com>). Licensed under [CC BY 4.0 Creative Commons](http://creativecommons.org/licenses/by/4.0/)*

---

```{code-cell} ipython3
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

plt.style.use('seaborn-v0_8-whitegrid')
```

## Introduction

+++

Observation data of species (when and where is a given species observed) is typical in biodiversity studies. Large international initiatives support the collection of this data by volunteers, e.g. [iNaturalist](https://www.inaturalist.org/). Thanks to initiatives like [GBIF](https://www.gbif.org/), a lot of these data is also openly available. 

In this example, data originates from a [study](http://esapubs.org/archive/ecol/E090/118/metadata.htm) of a Chihuahuan desert ecosystem near Portal, Arizona. It is a long-term observation study in 24 different plots (each plot identified with a `verbatimLocality` identifier) and defines, apart from the species, location and date of the observations, also the sex and the weight (if available).

The data consists of two data sets:

1. `observations.csv` the individual observations.
2. `species_names.csv` the overview list of the species names.

Let's start with the observations data!

+++

## Reading in the observations data

+++

<div class="alert alert-success">

**EXERCISE**

- Read in the `data/observations.csv` file with Pandas and assign the resulting DataFrame to a variable with the name `observations`.
- Make sure the 'occurrenceID' column is used as the index of the resulting DataFrame while reading in the data set.
- Inspect the first five rows of the DataFrame and the data types of each of the data columns.

<details><summary>Hints</summary>
    
- All read functions in Pandas start with `pd.read_...`.
- Setting a column as index can be done with an argument of the `read_csv` function To check the documentation of a function, use the keystroke combination of SHIFT + TAB when the cursor is on the function.
- Remember `.head()` and `.info()`?
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations = pd.read_csv("data/observations.csv", index_col="occurrenceID")
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations.head()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations.info()
```

<div class="alert alert-success">

**EXERCISE**

Create a new column with the name `eventDate` which contains datetime-aware information of each observation. To do so, combine the columns `day`, `month` and `year` into a datetime-aware data type by using the `pd.to_datetime` function from Pandas (check the help of that function to see how multiple columns with the year, month and day can be converted).

<details><summary>Hints</summary>

- `pd.to_datetime` can automatically combine the information from multiple columns. To select multiple columns, use a list of column names, e.g. `df[["my_col1", "my_col2"]]`
- To create a new column, assign the result to new name, e.g. `df["my_new_col"] = df["my_col"] + 1`
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations["eventDate"] =  pd.to_datetime(observations[["year", "month", "day"]])
observations
```

<div class="alert alert-success">

**EXERCISE**

For convenience when this dataset will be combined with other datasets, add a new column, `datasetName`, to the survey data set with `"Ecological Archives E090-118-D1."` as value for each of the individual records (static value for the entire data set)

<details><summary>Hints</summary>

- When a column does not exist, a new `df["a_new_column"]` can be created by assigning a value to it.
- Pandas will automatically broadcast a single string value to each of the rows in the DataFrame.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations["datasetName"] = "Ecological Archives E090-118-D1."
```

## Cleaning the `verbatimSex` column

```{code-cell} ipython3
observations["verbatimSex"].unique()
```

For the further analysis (and the species concerned in this specific data set), the `sex` information should be either `male` or `female`. We want to create a new column, named `sex` and convert the current values to the corresponding sex, taking into account the following mapping:
* `M` -> `male`
* `F` -> `female`
* `R` -> `male`
* `P` -> `female`
* `Z` -> nan

+++

<div class="alert alert-success">

**EXERCISE**

- Express the mapping of the values (e.g. `M` -> `male`) into a Python dictionary object with the variable name `sex_dict`. `Z` values correspond to _Not a Number_, which can be defined as `np.nan`. 
- Use the `sex_dict` dictionary to replace the values in the `verbatimSex` column to the new values and save the mapped values in a new column 'sex' of the DataFrame.
- Check the conversion by printing the unique values within the new column `sex`.

<details><summary>Hints</summary>
    
- A dictionary is a Python standard library data structure, see https://docs.python.org/3/tutorial/datastructures.html#dictionaries - no Pandas magic involved when you need a key/value mapping.
- When you need to replace values, look for the Pandas method `replace`.    
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

sex_dict = {"M": "male",
            "F": "female",
            "R": "male",
            "P": "female",
            "Z": np.nan}
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations['sex'] = observations['verbatimSex'].replace(sex_dict)
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations["sex"].unique()
```

## Tackle missing values (NaN) and duplicate values

+++

See [pandas_07_missing_values.ipynb](pandas_07_missing_values.ipynb) for an overview of functionality to work with missing values.

+++

<div class="alert alert-success">

**EXERCISE**

How many records in the data set have no information about the `species_ID`? Use the `isna()` method to find out.

<details><summary>Hints</summary>

- Do NOT use `survey_data_processed['species_ID'] == np.nan`, but use the available method `isna()` to check if a value is NaN
- The result of an (element-wise) condition returns a set of True/False values, corresponding to 1/0 values. The amount of True values is equal to the sum.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations['species_ID'].isna().sum()
```

<div class="alert alert-success">

**EXERCISE**

How many duplicate records are present in the dataset? Use the method `duplicated()` to check if a row is a duplicate.

<details><summary>Hints</summary>
    
- The result of an (element-wise) condition returns a set of True/False values, corresponding to 1/0 values. The amount of True values is equal to the sum.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations.duplicated().sum()
```

<div class="alert alert-success">

**EXERCISE**

- Select all duplicate data by filtering the `observations` data and assign the result to a new variable `duplicate_observations`. The `duplicated()` method provides a `keep` argument define which duplicates (if any) to mark.
- Sort the `duplicate_observations` data on both the columns `eventDate` and `verbatimLocality` and show the first 9 records.

<details><summary>Hints</summary>

- Check the documentation of the `duplicated` method to find out which value the argument `keep` requires to select all duplicate data.
- `sort_values()` can work with a single columns name as well as a list of names.

</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

duplicate_observations = observations[observations.duplicated(keep=False)]
duplicate_observations.sort_values(["eventDate", "verbatimLocality"]).head(9)
```

<div class="alert alert-success">

**EXERCISE**

- Exclude the duplicate values (i.e. keep the first occurrence while removing the other ones) from the `observations` data set and save the result as `observations_unique`. Use the `drop duplicates()` method from Pandas.
- How many observations are still left in the data set?    

<details><summary>Hints</summary>

- `keep=First` is the default option for `drop_duplicates`
- The number of rows in a DataFrame is equal to the `len`gth

</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations_unique = observations.drop_duplicates()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(observations_unique)
```

<div class="alert alert-success">

**EXERCISE**

Use the `dropna()` method to find out:    

- For how many observations (rows) we have all the information available (i.e. no NaN values in any of the columns)? 
- For how many observations (rows) we do have the `species_ID` data available ? 
- Remove the data without `species_ID` data from the observations and assign the result to a new variable `observations_with_ID`

<details><summary>Hints</summary>

- `dropna` by default removes by default all rows for which _any_ of the columns contains a `NaN` value.
- To specify which specific columns to check, use the `subset` argument

</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(observations_unique.dropna())
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(observations_unique.dropna(subset=['species_ID']))
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations_with_ID = observations_unique.dropna(subset=['species_ID'])
observations_with_ID.head()
```

<div class="alert alert-success">

**EXERCISE**

Filter the  `observations` data and select only those records that do not have a `species_ID` while having information on the `sex`. Store the result as variable `not_identified`.

<details><summary>Hints</summary>

- To combine logical operators element-wise in Pandas, use the `&` operator.
- Pandas provides both a `isna()` and a `notna()` method to check the existence of `NaN` values.

</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

mask = observations['species_ID'].isna() & observations['sex'].notna()
not_identified = observations[mask]
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

not_identified.head()
```

## Species abundance

+++

<div class="alert alert-success">

**EXERCISE**

Which 8 species (use the `name` column to identify the different species) have been observed most over the entire data set?

<details><summary>Hints</summary>

- Pandas provide a function to combine sorting and showing the first n records, see [here](https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.nlargest.html)...
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations.groupby("name").size().nlargest(8)
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

observations['name'].value_counts().iloc[:8]
```

<div class="alert alert-success">

**EXERCISE**

- What is the number of different species (`name`) in each of the `verbatimLocality` plots? Use the `nunique` method. Assign the output to a new variable `n_species_per_plot`.
- Define a Matplotlib `Figure` (`fig`) and `Axes` (`ax`) to prepare a plot. Make an horizontal bar chart using Pandas `plot` function linked to the just created Matplotlib `ax`. Each bar represents the `species per plot/verbatimLocality`. Change the y-label to 'Plot number'.

<details><summary>Hints</summary>

- _...in each of the..._ should provide a hint to use `groupby` for this exercise. The `nunique` is the aggregation function for each of the groups.
- `fig, ax = plt.subplots()` prepares a Matplotlib Figure and Axes.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

n_species_per_plot = observations.groupby(["verbatimLocality"])["name"].nunique()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

fig, ax = plt.subplots(figsize=(6, 6))
n_species_per_plot.plot(kind="barh", ax=ax)
ax.set_ylabel("Plot number");
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

## Alternative option to calculate the species per plot:
## inspired on the pivot table we already had:
#species_per_plot = observations.reset_index().pivot_table(
#      index="species_ID", columns="verbatimLocality", values="occurrenceID", aggfunc='count')
#n_species_per_plot = species_per_plot.count()
```

<div class="alert alert-success">

**EXERCISE**

- What is the number of plots (`verbatimLocality`) each of the species (`name`) have been observed in? Assign the output to a new variable `n_plots_per_species`. Sort the counts from low to high.
- Make an horizontal bar chart using Pandas `plot` function to show the number of plots each of the species was found (using the `n_plots_per_species` variable).  

<details><summary>Hints</summary>

- Use the previous exercise to solve this one.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

n_plots_per_species = observations.groupby(["name"])["verbatimLocality"].nunique().sort_values()

fig, ax = plt.subplots(figsize=(10, 8))
n_plots_per_species.plot(kind="barh", ax=ax)
ax.set_xlabel("Number of plots");
ax.set_ylabel("");
```

<div class="alert alert-success">

**EXERCISE**

- Starting from the `observations`, calculate the amount of males and females present in each of the plots (`verbatimLocality`). The result should return the counts for each of the combinations of `sex` and `verbatimLocality`. Assign to a new variable `n_plot_sex` and ensure the counts are in a column named "count".
- Use a `pivot()` to convert the `n_plot_sex` DataFrame to a new DataFrame with the `verbatimLocality` as index and `male`/`female` as column names. Assign to a new variable `pivoted`.

<details><summary>Hints</summary>

- _...for each of the combinations..._ `groupby` can also be used with multiple columns at the same time.
- If a `groupby` operation gives a Series as result, you can give that Series a name with the `.rename(..)` method.
- `reset_index()` is useful function to convert multiple indices into columns again.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

n_plot_sex = observations.groupby(["sex", "verbatimLocality"]).size().rename("count").reset_index()
n_plot_sex.head()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

pivoted = n_plot_sex.pivot(columns="sex", index="verbatimLocality", values="count")
pivoted.head()
```

As such, we can use the variable `pivoted` to plot the result:

```{code-cell} ipython3
pivoted.plot(kind='bar', figsize=(12, 6), rot=0)
```

<div class="alert alert-success">

**EXERCISE**

Recreate the previous plot with the `catplot` function from the Seaborn library directly starting from <code>observations</code> DataFrame. 

<details><summary>Hints</summary>

- Check the `kind` argument of the `catplot` function to find out how to use counts to define the bars instead of a `y` value.
- To link a column to different colors, use the `hue` argument
- Using `height` and `aspect`, the figure size can be optimized.

    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

sns.catplot(data=observations, x="verbatimLocality", 
            hue="sex", kind="count", height=3, aspect=3)
```

<div class="alert alert-success">

**EXERCISE**

- Create a table, called `heatmap_prep`, based on the `observations` DataFrame with the row index the individual years, in the column the months of the year (1-> 12) and as values of the table, the counts for each of these year/month combinations.
- Using the seaborn <a href="http://seaborn.pydata.org/generated/seaborn.heatmap.html">documentation</a>, make a heatmap starting from the `heatmap_prep` variable.

<details><summary>Hints</summary>

- A `pivot_table` has an `aggfunc` parameter by which the aggregation of the cells combined into the year/month element are combined (e.g. mean, max, count,...). 
- You can use the `species_ID` to count the number of observations.
- seaborn has an `heatmap` function which requires a short-form DataFrame, comparable to giving each element in a table a color value.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

heatmap_prep = observations.pivot_table(index='year', columns='month', 
                                        values="species_ID", aggfunc='count')
fig, ax = plt.subplots(figsize=(10, 8))
ax = sns.heatmap(heatmap_prep, cmap='Reds')
```

## Adding the names of the observed species

```{code-cell} ipython3
# Recap from previous exercises - remove duplicates and observations without species information
observations_unique_ = observations.drop_duplicates()
observations_data = observations_unique_.dropna(subset=['species_ID'])
```

In the data set `observations`, the column `specied_ID` provides an identifier and the `name` column the species name. The taxonomic information of each speciess is provided in a separate file `species_names.csv`:

```{code-cell} ipython3
species_names = pd.read_csv("data/species_names.csv")
species_names.head()
```

The species names contains for each identifier in the `ID` column the scientific name and taxonomic information of a species. The `species_names` data set contains in total 38 different scientific names:

```{code-cell} ipython3
species_names.shape
```

For further analysis, let's combine both in a single DataFrame in the following exercise.

+++

<div class="alert alert-success">

**EXERCISE**

Combine the DataFrames `observations_data` and `species_names` by adding the corresponding species name information (class, kingdom,..) to the individual observations using the `pd.merge()` function. Assign the output to a new variable `survey_data`. Use the `species_ID` to combine the both DataFrames.

<details><summary>Hints</summary>

- This is an example of a database JOIN operation. Pandas provides the `pd.merge` function to join two data sets using a common identifier.
- Take into account that our key-column is different for `observations` and `species_names`, respectively `specied_ID` and `ID`. The `pd.merge()` function has `left_on` and `right_on` keywords to specify the name of the column in the left and right `DataFrame` to merge on.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

survey_data = pd.merge(observations_data, species_names, how="left",
                       left_on="species_ID", right_on="ID")
survey_data
```

## Select subsets according to taxa of species

```{code-cell} ipython3
survey_data['taxa'].value_counts()
#survey_data.groupby('taxa').size()
```

<div class="alert alert-success">

**EXERCISE**

- Select the observations for which the `taxa` is equal to 'Rabbit', 'Bird' or 'Reptile'. Assign the result to a variable `non_rodent_species`. Use the `isin` method for the selection.

<details><summary>Hints</summary>

- You do not have to combine three different conditions, but use the `isin` operator with a list of names.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

non_rodent_species = survey_data[survey_data['taxa'].isin(['Rabbit', 'Bird', 'Reptile'])]
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(non_rodent_species)
```

<div class="alert alert-success">

**EXERCISE**

Select the observations for which the `name` starts with the characters 'r' (make sure it does not matter if a capital character is used in the 'taxa' name). Call the resulting variable `r_species`.

<details><summary>Hints</summary>

- Remember the `.str.` construction to provide all kind of string functionalities? You can combine multiple of these after each other.
- If the presence of capital letters should not matter, make everything lowercase first before comparing (`.lower()`)    
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

r_species = survey_data[survey_data['name'].str.lower().str.startswith('r')]
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(r_species)
```

```{code-cell} ipython3
r_species["name"].value_counts()
```

<div class="alert alert-success">

**EXERCISE**

Select the observations that are not Birds. Call the resulting variable <code>non_bird_species</code>.

<details><summary>Hints</summary>

- Logical operators like `==`, `!=`, `>`,... can still be used.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

non_bird_species = survey_data[survey_data['taxa'] != 'Bird']
```

```{code-cell} ipython3
len(non_bird_species)
```

<div class="alert alert-success">

**EXERCISE**

Select the __Bird__ (taxa is Bird) observations from 1985-01 till 1989-12 usint the `eventDate` column. Call the resulting variable `birds_85_89`.

<details><summary>Hints</summary>

- No hints, you can do this! (with the help of some `<=` and `&`, and don't forget the put brackets around each comparison that you combine)
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

birds_85_89 = survey_data[(survey_data["eventDate"] >= "1985-01-01")
                          & (survey_data["eventDate"] <= "1989-12-31 23:59")
                          & (survey_data['taxa'] == 'Bird')]
birds_85_89.head()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

# alternative solution
birds_85_89 = survey_data[(survey_data["eventDate"].dt.year >= 1985)
                          & (survey_data["eventDate"].dt.year <= 1989) 
                          & (survey_data['taxa'] == 'Bird')]
birds_85_89.head()
```

<div class="alert alert-success">

**EXERCISE**

- Drop the observations for which no `weight` information is available.
- On the filtered data, compare the median weight for each of the species (use the `name` column)
- Sort the output from high to low median weight (i.e. descending)
    
__Note__ You can do this all in a single line statement, but don't have to do it as such!

<details><summary>Hints</summary>    

- You will need `dropna`, `groupby`, `median` and `sort_values`.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

# Multiple lines
obs_with_weight = survey_data.dropna(subset=["weight"])
median_weight = obs_with_weight.groupby(['name'])["weight"].median()
median_weight.sort_values(ascending=False)
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

# Single line statement
survey_data.dropna(subset=["weight"]).groupby(['name'])["weight"].median().sort_values(ascending=False)
```

Remark that we started from a `tidy` data format (also called *long* format) and converted to *short* format with in the row index the years, in the column the months and the counts for each of these year/month combinations as values.

+++

<div class="alert alert-success">

**EXERCISE**

- Make a summary table with the number of records of each of the species in each of the plots (called `verbatimLocality`)? Each of the species `name`s is a row index and each of the `verbatimLocality` plots is a column name.
- Use the Seaborn <a href="http://seaborn.pydata.org/generated/seaborn.heatmap.html">documentation</a> to make a heatmap.

<details><summary>Hints</summary>

- Make sure to pass the correct columns to respectively the `index`, `columns`, `values` and `aggfunc` parameters of the `pivot_table` function. You can use the `ID` to count the number of observations for each name/locality combination (when counting rows, the exact column doesn't matter).

</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

species_per_plot = survey_data.reset_index().pivot_table(index="name", 
                                                         columns="verbatimLocality", 
                                                         values="ID", 
                                                         aggfunc='count')
species_per_plot.head()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

fig, ax = plt.subplots(figsize=(8,8))
sns.heatmap(species_per_plot, ax=ax, cmap='Greens')
```

<div class="alert alert-success">

**EXERCISE**

Make a plot visualizing the evolution of the number of observations for each of the individual __years__ (i.e. annual counts) using the `resample` method.

<details><summary>Hints</summary>

- You want to `resample` the data using the `eventDate` column to create annual counts. If the index is not a datetime-index, you can use the `on=` keyword to specify which datetime column to use. You can either use `YE` or `YS`.
- `resample` needs an aggregation function on how to combine the values within a single 'group' (in this case data within a year). In this example, we want to know the `size` of each group, i.e. the number of records within each year.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

survey_data.resample('YE', on='eventDate').size().plot()
```

## (OPTIONAL SECTION) Evolution of species during monitoring period

+++

*In this section, all plots can be made with the embedded Pandas plot function, unless specificly asked*

+++

<div class="alert alert-success">

**EXERCISE**

Plot using Pandas `plot` function the number of records for `Dipodomys merriami` for each month of the year (January (1) -> December (12)), aggregated over all years.

<details><summary>Hints</summary>

- _...for each month of..._ requires `groupby`. 
- `resample` is not useful here, as we do not want to change the time-interval, but look at month of the year (over all years)
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

merriami = survey_data[survey_data["name"] == "Dipodomys merriami"]
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

fig, ax = plt.subplots()
merriami.groupby(merriami['eventDate'].dt.month).size().plot(kind="barh", ax=ax)
ax.set_xlabel("number of occurrences")
ax.set_ylabel("Month of the year")
```

<div class="alert alert-success">

**EXERCISE**

Plot, for the species 'Dipodomys merriami', 'Dipodomys ordii', 'Reithrodontomys megalotis' and 'Chaetodipus baileyi', the monthly number of records as a function of time for the whole monitoring period. Plot each of the individual species in a separate subplot and provide them all with the same y-axis scale

<details><summary>Hints</summary>

- `isin` is useful to select from within a list of elements.
- `groupby` AND `resample` need to be combined. We do want to change the time-interval to represent data as a function of time (`resample`, using `ME`) and we want to do this _for each name/species_ (`groupby`). The order matters!
- `unstack` is a Pandas function a bit similar to `pivot`. Check the [unstack documentation](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.unstack.html) as it might be helpful for this exercise.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

subsetspecies = survey_data[survey_data["name"].isin(['Dipodomys merriami', 'Dipodomys ordii',
                                                      'Reithrodontomys megalotis', 'Chaetodipus baileyi'])]
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

month_evolution = subsetspecies.groupby("name").resample('ME', on='eventDate').size()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

species_evolution = month_evolution.unstack(level=0)
axs = species_evolution.plot(subplots=True, figsize=(14, 8), sharey=True)
```

<div class="alert alert-success">

**EXERCISE**

Recreate the same plot as in the previous exercise using Seaborn `relplot` functon with the `month_evolution` variable.

<details><summary>Hints</summary>

- We want to have the `counts` as a function of `eventDate`, so link these columns to y and x respectively.
- To create subplots in Seaborn, the usage of _facetting_ (splitting data sets to multiple facets) is used by linking a column name to the `row`/`col` parameter. 
- Using `height` and `aspect`, the figure size can be optimized.
    
</details>

```{code-cell} ipython3
# Given as solution..
subsetspecies = survey_data[survey_data["name"].isin(['Dipodomys merriami', 'Dipodomys ordii',
                                                      'Reithrodontomys megalotis', 'Chaetodipus baileyi'])]
month_evolution = subsetspecies.groupby("name").resample('ME', on='eventDate').size().rename("counts")
month_evolution = month_evolution.reset_index()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

sns.relplot(data=month_evolution, x='eventDate', y="counts", 
            row="name", kind="line", hue="name", height=2, aspect=5)
```

<div class="alert alert-success">

**EXERCISE**

Plot the annual amount of occurrences for each of the 'taxa' as a function of time using Seaborn. Plot each taxa in a separate subplot and do not share the y-axis among the facets.

<details><summary>Hints</summary>

- Combine `resample` and `groupby`!
- Check out the previous exercise for the plot function.
- Pass the `sharey=False` to the `facet_kws` argument as a dictionary.
    
</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

year_evolution = survey_data.groupby("taxa").resample('YE', on='eventDate').size()
year_evolution.name = "counts"
year_evolution = year_evolution.reset_index()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

year_evolution.head()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

sns.relplot(data=year_evolution, x='eventDate', y="counts", 
            col="taxa", col_wrap=2, kind="line", height=2, aspect=5, 
            facet_kws={"sharey": False})
```

<div class="alert alert-success">

**EXERCISE**

The observations where taken by volunteers. You wonder on which day of the week the most observations where done. Calculate for each day of the week (`weekday`) the number of observations and make a barplot.

<details><summary>Hints</summary>

- Did you know the Python standard Library has a module `calendar` which contains names of week days, month names,...?

</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

fig, ax = plt.subplots()
survey_data.groupby(survey_data["eventDate"].dt.weekday).size().plot(kind='barh', color='#66b266', ax=ax)

import calendar
xticks = ax.set_yticklabels(calendar.day_name)
```

Nice work!

```{code-cell} ipython3

```

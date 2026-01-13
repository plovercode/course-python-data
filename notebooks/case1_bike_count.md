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

<p><font size="6"><b> CASE - Bike count data</b></font></p>

> *© 2026, Joris Van den Bossche and Stijn Van Hoey  (<mailto:jorisvandenbossche@gmail.com>, <mailto:stijnvanhoey@gmail.com>). Licensed under [CC BY 4.0 Creative Commons](http://creativecommons.org/licenses/by/4.0/)*

---

+++

<img src="https://static.nieuwsblad.be/Assets/Images_Upload/2014/04/17/57b8f34e-5042-11e2-80ee-5d1d7b74455f_original.jpg.h380.jpg.568.jpg?maxheight=460&maxwidth=638&scale=both">

+++

In this case study, we will make use of the openly available [bike count data of the city of Ghent (Belgium)](https://data.stad.gent/explore/dataset/fietstelpaal-coupure-links-2022-gent/information/?sort=-ordening). At the Coupure Links, next to the Faculty of Bioscience Engineering, a counter keeps track of the number of passing cyclists in both directions.

Data is made available by the City of Ghent, _"Mobiliteitsbedrijf Gent"_ as [licentie Gratis Hergebruik ](https://www.vlaanderen.be/digitaal-vlaanderen/onze-oplossingen/open-data/voorwaarden-voor-het-hergebruik-van-overheidsinformatie/modellicentie-gratis-hergebruik). Original data is downloaded and adjusted for exercise purpose (e.g. remove character in column name 'Code').

```{code-cell} ipython3
import pandas as pd
import matplotlib.pyplot as plt
plt.style.use('seaborn-v0_8-whitegrid')
```

# Reading and processing the data

+++

## Read csv data

+++

The data is available on the open data portal of the city, and we downloaded them in the `CSV` format, and provide the data of 2022 zipped as `data/fietstelpaal-coupure-links-2022-gent.zip`.

This dataset contains the historical data of the bike counters, and consists of the following columns:

- `Code`: Short code used to identify the location of the bike counter
- `Locatie`: Full location name of the bike counter
- `Datum`: Date
- `Uur5Minuten`: Hour, rounded to 5-minute frequency
- `Ordening`: Time-zone aware timestamp of the counts
- `Totaal`: Total number of bikers passing
- `Hoofdrichting`: Number of bikers passing from 'Rozemarijnbrug' (centre of Ghent) to 'Contributiebrug' (Mariakerke), bikers heading north
- `Tegenrichting`: Number of bikers passing from 'Contributiebrug' (Mariakerke) to 'Rozemarijnbrug' (centre of Ghent), bikers heading south

+++

<div class="alert alert-success">

**EXERCISE**

- Read the zipped csv file from the url into a DataFrame `df`, the delimiter of the data is `;`
- Inspect the first and last 5 rows, and check the number of observations
- Inspect the data types of the different columns

<details><summary>Hints</summary>

- With the cursor on a function, you can combine the SHIFT + TAB keystrokes to see the documentation of a function.
- Both the `sep` and `delimiter` argument will work to define the delimiter.
- Methods like `head`/`tail` have round brackets `()`, attributes like `dtypes` not.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df = pd.read_csv("data/fietstelpaal-coupure-links-2022-gent.zip", sep=';')
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df.head()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df.tail()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

len(df)
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df.dtypes
```

## Data processing

```{code-cell} ipython3
df.head()
```

As explained above, the timestamp information is contained both in the combination of the `Datum` and `Uur5Minuten` column or the `Ordening` column. To convert to a time series, we have to convert the timestamp information to actual Pandas timestamp objects.

+++

<div class="alert alert-success">

**EXERCISE**

Pre-process the data:

* Convert the 'Ordening' column into a pandas Timestamp Series, and assign the data to a new column named `"timestamp"`. Make sure to read the data as `UTC`
* Set the resulting `"timestamp"` column as the index of the `df` DataFrame.
* Remove the original 'Datum', 'Uur5Minuten', 'Code' and 'Ordening' columns using the `drop()` method, and call the new dataframe `df2022`.
* Rename the columns in the DataFrame 'Tegenrichting', 'Hoofdrichting' to resp. 'direction_centre', 'direction_mariakerke' using the `rename()` method. Translate the 'Locatie' columns to 'location' and the 'Totaal' column to 'total'.
    
The `rename()` and `drop()` functions are introduced in [pandas_06_data_cleaning.ipynb](./pandas_06_data_cleaning.ipynb) together with other cleaning functions required during data preprocessing.

<details><summary>Hints</summary>

- When converting strings to a `datetime` with `pd.to_datetime`, specifying the format will make the conversion a lot faster. See the format codes in the [Python documentation](https://docs.python.org/3/library/datetime.html#strftime-and-strptime-format-codes).
- The `to_datetime` function has an option `utc=True` to convert all timestamps as UTC timestamp. Otherwise the conversion will fail.   
- `drop()` can remove both rows and columns using the names of the index or column name. Make sure to define `columns=` argument to remove columns.
- `rename()` can be used for both row and column names. It needs a dictionary with the current names as keys and the new names as values, and pass this to the `columns=` keyword for renaming the column names.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df["timestamp"] = pd.to_datetime(df["Ordening"], format="%Y-%m-%dT%H:%M:%S%z", utc=True)
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df = df.set_index("timestamp")
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df2022 = df.drop(columns=['Datum', 'Uur5Minuten', 'Ordening', 'Code'])
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df2022 = df2022.rename(columns={'Tegenrichting': 'direction_centre',
                                'Hoofdrichting': 'direction_mariakerke',
                                'Totaal': 'total',
                                'Locatie': 'location'})
```

```{code-cell} ipython3
df2022.head()
```

Having the data available with an interpreted `datetime`, provides us the possibility of having time aware plotting:

```{code-cell} ipython3
fig, ax = plt.subplots(figsize=(10, 6))
df2022.plot(colormap='coolwarm', ax=ax)
```

<div class="alert alert-info">

 <b>Remember</b>: Whenever possible, specify the date format to interpret the dates to `datetime` values!

</div>

+++

### Write the dataset cleaning as a function

In order to make it easier to reuse the code for the pre-processing we have implemented, let's convert the code to a Python function:

+++

<div class="alert alert-success">

**EXERCISE**

Write a function `process_bike_count_data(df)` that performs the processing steps as done above for an input Pandas DataFrame and returns the updated DataFrame. Test the functionality on the data file of 2023, `fietstelpaal-coupure-links-2023-gent.zip` and call the result `df2023`.

<details><summary>Hints</summary>

- Want to know more about proper documenting your Python functions? Check out the official guide of [numpydoc](https://numpydoc.readthedocs.io/en/latest/format.html). The `Parameters` and `Returns` sections should always be explained.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

def process_bike_count_data(df):
    """Process the provided dataframe: parse datetimes and rename columns.

    Parameters
    ----------
    df : pandas.DataFrame
        DataFrame as read from the raw `fietstellingen`,
        containing the 'Datum', 'Uur5Minuten', 
        'Ordening', 'Totaal', 'Tegenrichting', 'Hoofdrichting' columns.

    Returns
    -------
    df2 : pandas.DataFrame
        DataFrame with the datetime info as index and the
        `direction_centre` and `direction_mariakerke` columns
        with the counts.
    """
    timestamps = pd.to_datetime(df["Ordening"], format="%Y-%m-%dT%H:%M:%S%z", utc=True)    
    df2 = df.drop(columns=['Datum', 'Uur5Minuten', 'Ordening', 'Code'])
    df2["timestamp"] = timestamps
    df2 = df2.set_index("timestamp")
    df2 = df2.rename(columns={'Tegenrichting': 'direction_centre',
                              'Hoofdrichting': 'direction_mariakerke',
                              'Totaal': 'total',
                              'Locatie': 'location'
                             })
    return df2
```

```{code-cell} ipython3
df_raw = pd.read_csv("data/fietstelpaal-coupure-links-2023-gent.zip", sep=';')
df2023 = process_bike_count_data(df_raw)
df2023.tail()
```

### Store our collected dataset as an interim data product

+++

As we finish our data-collection step, we want to save this result as an interim data output of our small investigation. As such, we do not have to re-download and process all the files each time something goes wrong, but can restart from our interim step:

+++

```python
pd.concat([df2022, df2023]).drop(columns=["location", "total"]).sort_index().to_csv("data/fietstelpaal-coupure-links-gent.zip", index=True)
```

+++

__Note:__ Check the notebook [pandas_09_combining_datasets.ipynb](./pandas_09_combining_datasets.ipynb) for more information on the `pd.concat` function.

+++

## Data exploration and analysis

+++

We now have a cleaned-up dataset of the bike counts at Coupure Links in Ghent (Belgium). Next, we want to get an impression of the characteristics and properties of the data.

+++

### Load the processed data

+++

Reading the file in from the interim file containing multiple years of data:

```{code-cell} ipython3
df = pd.read_csv("data/fietstelpaal-coupure-links-gent.zip", index_col=0, parse_dates=True)
```

```{code-cell} ipython3
df
```

The timestamp data is timezone-aware in UTC. For some of the analyses further in this notebook, we will check the time of the day. In this case, it's useful to view the timestamps in the wall time of Belgium, such that the interpretation of the hours matches with our local time perception (for example, observing that there is a peak in cyclists at 8:00 in the morning).
We can convert the UTC values to local time using `tz_convert()`:

```{code-cell} ipython3
df = df.tz_convert("Europe/Brussels")
df
```

### Count interval verification

+++

The number of bikers are counted for intervals of approximately 5 minutes. But let's check if this is indeed the case. Calculate the difference between each of the consecutive values of the index. We can use the `Series.diff()` method:

```{code-cell} ipython3
df.head()
```

The count of the possible intervals is of interest:

```{code-cell} ipython3
df.index.to_series().diff().value_counts()
```

There are a few records that are not 5min. Do you know where the values of `0 days 01:05:00` and the duplicate entries with `0 days 00:00:00` are coming from?

```{code-cell} ipython3
df.describe()
```

### Quiet periods

+++

<div class="alert alert-success">

**EXERCISE**

Create a new pandas Series `df_both` which contains the sum of the counts of both directions.

<details><summary>Hints</summary>

- Check the purpose of the `axis` argument of the `sum` method.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_both = df.sum(axis=1)
df_both
```

<div class="alert alert-success">

**EXERCISE**

Using the `df_both` from the previous exercise, create a new Series `df_quiet` which contains only those intervals for which less than 5 cyclists passed in both directions combined

<details><summary>Hints</summary>

- Use the `[]` to select data. You can use conditions (so-called _boolean indexing_) returning True/False inside the brackets.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_quiet = df_both[df_both < 5]
df_quiet
```

<div class="alert alert-success">

**EXERCISE**

Using the original data `df`, select only the intervals for which less than 3 cyclists passed in one or the other direction. Hence, less than 3 cyclists towards the center or less than 3 cyclists towards Mariakerke.

<details><summary>Hints</summary>

- To combine conditions use the `|` (or) or the `&` (and) operators.
- Make sure to use `()` around each individual condition.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df[(df['direction_centre'] < 3) | (df['direction_mariakerke'] < 3)]
```

### Count statistics

+++

<div class="alert alert-success">

**EXERCISE**

What is the average number of bikers passing every 5 min in each direction?

<details><summary>Hints</summary>

- As the time series is already 5min level, this is just the same as taking the mean.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df.mean()
```

<div class="alert alert-success">

**EXERCISE**

What is the average number of bikers passing each hour?

<details><summary>Hints</summary>

- Use `resample()` to first calculate the number of bikers passing each hour.
- `resample` requires an aggregation function that defines how to combine the values within each group (in this case all values within each hour).

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df.resample('h').sum().mean()
```

<div class="alert alert-success">

**EXERCISE**

What are the 10 highest peak values observed during any of the intervals for the direction towards the center of Ghent?

<details><summary>Hints</summary>

- Pandas provides the `nsmallest` and  `nlargest` methods to derive N smallest/largest values of a column.

</details>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df['direction_centre'].nlargest(10)
# alternative:
# df['direction_centre'].sort_values(ascending=False).head(10)
```

<div class="alert alert-success">

**EXERCISE**

What is the maximum number of cyclist that passed on a single day calculated on both directions combined?

<details><summary>Hints</summary>

- Combine both directions by taking the sum.
- Next, `resample` to daily values
- Get the maximum value or ask for the n largest to see the dates as well.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_both = df.sum(axis=1)
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_daily = df_both.resample('D').sum()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_daily.max()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_daily.nlargest(10)
```

### Trends as function of time

+++

<div class="alert alert-success">

**EXERCISE**

How does the long-term trend look like? Calculate monthly sums and plot the result.

<details><summary>Hints</summary>

- The symbol for monthly resampling is `ME` or `MS`.
- Use the `plot` method of Pandas, which will generate a line plot of each numeric column by default.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_monthly = df.resample('ME').sum()
df_monthly.plot()
```

<div class="alert alert-success">

**EXERCISE**

Let's have a look at some short term patterns. For the data of the first 3 weeks of January 2023, calculate the hourly counts and visualize them.

<details><summary>Hints</summary>

- Slicing is done using `[]`, you can use string representation of dates to select from a `datetime` index: e.g. `'2010-01-01':'2020-12-31'`

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_hourly = df.resample('h').sum()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_hourly.head()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

df_hourly['2023-01-01':'2023-01-21'].plot()
```

**New Year's Eve 2022-2023**

+++

<div class="alert alert-success">

**EXERCISE**

- Select a subset of the dataset from 2022-12-31 12:00:00 until 2023-01-01 12:00:00 and assign the result to a new variable `newyear`
- Plot the selected data `newyear`.
- Use a `rolling` function with a window of 10 values (check documentation of the function) to smooth the data of this period and make a plot of the smoothed version.

<details><summary>Hints</summary>

- Just like `resample`, `rolling` requires an aggregate statistic (e.g. mean, median,...) to combine the values within the window.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

newyear = df["2022-12-31 12:00:00": "2023-01-01 12:00:00"]
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

newyear.plot()
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

newyear.rolling(10, center=True).mean().plot(linewidth=2)
```

A more advanced usage of Matplotlib to create a combined plot:

```{code-cell} ipython3
:tags: [nbtutor-solution]

# A more in-detail plotting version of the graph.
fig, ax = plt.subplots()
newyear.plot(ax=ax, color=['LightGreen', 'LightBlue'], legend=False, rot=0)
newyear.rolling(10, center=True).mean().plot(linewidth=2, ax=ax, color=['DarkGreen', 'DarkBlue'], rot=0)

ax.set_xlabel('')
ax.set_ylabel('Cyclists count')
```

---

## The power of `groupby`...

Looking at the data in the above exercises, there seems to be clearly a:

- daily pattern
- weekly pattern
- yearly pattern

Such patterns can easily be calculated and visualized in pandas using the `DatetimeIndex` attributes `dayofweek` combined with `groupby` functionality. Below a taste of the possibilities, and we will learn about this in the proceeding notebooks:

+++

**Weekly pattern**:

```{code-cell} ipython3
df_daily = df.resample('D').sum()
```

```{code-cell} ipython3
df_daily.groupby(df_daily.index.dayofweek).mean().plot(kind='bar')
```

**Daily pattern:**

```{code-cell} ipython3
df_hourly = df.resample('h').sum()
```

```{code-cell} ipython3
df_hourly.groupby(df_hourly.index.hour).mean().plot()
```

So the daily pattern is clearly different for both directions. In the morning more people go towards the centre, in the evening more people go back to Mariakerke. The morning peak is also more condensed.

+++

**Monthly pattern**

```{code-cell} ipython3
df_monthly = df.resample('ME').sum()
```

```{code-cell} ipython3
from calendar import month_abbr
```

```{code-cell} ipython3
ax = df_monthly.groupby(df_monthly.index.month).mean().plot()
ax.set_ylim(0)
xlabels = ax.set_xticks(list(range(13))[1::2], list(month_abbr)[1::2]) #too lazy to write the month values yourself...
```

## Acknowledgements
Thanks to the [city of Ghent](https://data.stad.gent/) for opening their data

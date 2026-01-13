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

<p><font size="6"><b>04 - Pandas: Working with time series data</b></font></p>

> *© 2026, Joris Van den Bossche and Stijn Van Hoey  (<mailto:jorisvandenbossche@gmail.com>, <mailto:stijnvanhoey@gmail.com>). Licensed under [CC BY 4.0 Creative Commons](http://creativecommons.org/licenses/by/4.0/)*

---

```{code-cell} ipython3
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

plt.style.use('ggplot')
```

# Dates and times in pandas

+++

Pandas has its own date and time objects, which are compatible with the [standard `datetime` objects](https://docs.python.org/3/library/datetime.html), but provide some more functionality to work with.  

Consider the following datetime information, represented as strings:

```{code-cell} ipython3
s = pd.Series(['2016-12-09 10:00:00', '2016-12-09 11:00:00', '2016-12-09 12:00:00'])
```

```{code-cell} ipython3
s
```

The `to_datetime` function can be used to convert string formatted dates into Pandas __Timestamp__ objects:

```{code-cell} ipython3
ts = pd.to_datetime(s)
ts
```

Notice the data type of this series has changed: the `datetime64[ns]` dtype. This indicates that we have a series of actual timestamp values.

+++

Like with standard Python [`datetime.datetime` objects](https://docs.python.org/3/library/datetime.html#datetime.datetime), there are several useful attributes available on the pandas `Timestamp`. And those are also available on a Series with datetime data using the **`.dt`** accessor. For example, we can get the month, hour, day of the week,... (experiment with tab completion!) for each of the timestamps:

```{code-cell} ipython3
ts.dt.month
```

```{code-cell} ipython3
ts.dt.hour
```

```{code-cell} ipython3
ts.dt.dayofweek
```

Each of the individual elements in the Series is a pandas `Timestamp` object:

```{code-cell} ipython3
ts[0]
```

The `Timestamp` object can also be constructed from a string and provides access to the Timestamp attributes:

```{code-cell} ipython3
ts_singe = pd.Timestamp('2016-12-21 23:02')
```

```{code-cell} ipython3
ts_singe.month, ts_singe.hour, ts_singe.dayofweek
```

There is also a `Timedelta` type, which can e.g. be used to add intervals of time:

```{code-cell} ipython3
ts + pd.Timedelta('5 days')
```

To quickly construct some regular time series data, the [``pd.date_range``](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.date_range.html) function comes in handy:

```{code-cell} ipython3
pd.Series(pd.date_range(start="2016-01-01", periods=10, freq='3h'))
```

## Parsing datetime strings

+++

![](http://imgs.xkcd.com/comics/iso_8601.png)

+++

Unfortunately, when working with real world data, you encounter many different `datetime` formats. Most of the time when you have to deal with them, they come in text format, e.g. from a `CSV` file. To work with those data in Pandas, we first have to *parse* the strings to actual `Timestamp` objects.

+++

<div class="alert alert-info">
<b>REMEMBER</b>: <br><br>

To convert different kind of string formatted dates to Timestamp objects: use the `pandas.to_datetime` function 

</div>

```{code-cell} ipython3
pd.to_datetime("2016-12-09")
```

```{code-cell} ipython3
pd.to_datetime("09/12/2016")
```

```{code-cell} ipython3
pd.to_datetime("09/12/2016", format="%d/%m/%Y")
```

A detailed overview of how to specify the `format` string, see the table in the python documentation: https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior

+++

# Time series data: `Timestamp` in the index

+++

## River discharge example data

+++

For the following demonstration of the time series functionality, we use a sample of discharge data of the Maarkebeek (Flanders) with 3 hour averaged values, derived from the [Waterinfo website](https://www.waterinfo.be/).

```{code-cell} ipython3
data = pd.read_csv("data/vmm_flowdata.csv")
```

```{code-cell} ipython3
data.head()
```

We already know how to parse a date column with Pandas:

```{code-cell} ipython3
data['Time'] = pd.to_datetime(data['Time'])
```

With `set_index('datetime')`, we set the column with datetime values as the index, which can be done by both `Series` and `DataFrame`.

```{code-cell} ipython3
data = data.set_index("Time")
```

```{code-cell} ipython3
data
```

The steps above are provided as built-in functionality of `read_csv`:

```{code-cell} ipython3
data = pd.read_csv("data/vmm_flowdata.csv", index_col=0, parse_dates=True)
```

<div class="alert alert-info">
<b>REMEMBER</b>: <br><br>

`pd.read_csv` provides a lot of built-in functionality to support this kind of transactions when reading in a file! Check the help of the read_csv function...

</div>

+++

## The DatetimeIndex

+++

When we ensure the DataFrame has a `DatetimeIndex`, time-series related functionality becomes available:

```{code-cell} ipython3
data.index
```

Similar to a Series with datetime data, there are some attributes of the timestamp values available:

```{code-cell} ipython3
data.index.day
```

```{code-cell} ipython3
data.index.dayofyear
```

```{code-cell} ipython3
data.index.year
```

The `plot` method will also adapt its labels (when you zoom in, you can see the different levels of detail of the datetime labels):

```{code-cell} ipython3
%matplotlib widget
```

```{code-cell} ipython3
data.plot()
```

```{code-cell} ipython3
# switching back to static inline plots (the default)
%matplotlib inline
```

We have too much data to sensibly plot on one figure. Let's see how we can easily select part of the data or aggregate the data to other time resolutions in the next sections.

+++

## Selecting data from a time series

+++

We can use label based indexing on a timeseries as expected:

```{code-cell} ipython3
data[pd.Timestamp("2012-01-01 09:00"):pd.Timestamp("2012-01-01 19:00")]
```

But, for convenience, indexing a time series also works with strings:

```{code-cell} ipython3
data["2012-01-01 09:00":"2012-01-01 19:00"]
```

A nice feature is **"partial string" indexing**, where we can do implicit slicing by providing a partial datetime string.

E.g. all data of 2013:

```{code-cell} ipython3
data['2013':]
```

Or all data of January up to March 2012:

```{code-cell} ipython3
data['2012-01':'2012-03']
```

# Exercises

Let's practice this yourself using the same dataset:

```{code-cell} ipython3
data = pd.read_csv("data/vmm_flowdata.csv", index_col=0, parse_dates=True)
```

<div class="alert alert-success">

**EXERCISE:**

Select all data starting from 2012

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

data['2012':]
```

<div class="alert alert-success">

**EXERCISE**:

Select all data in January for all different years

<details><summary>Hints</summary>

* Remember you can get information about the month of each timestamp using the `month` attribute of the DatetimeIndex.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

data[data.index.month == 1]
```

<div class="alert alert-success">

**EXERCISE**:

Select all data in April, May and June for all different years

<details><summary>Hints</summary>

* If you want to check for equality with multiple possible values (equal to x OR equal to y OR ...), the `isin()` method can be easier to use.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

data[data.index.month.isin([4, 5, 6])]
```

<div class="alert alert-success">

**EXERCISE**

Select all 'daytime' data (between 8h and 20h) for all days
    
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

data[(data.index.hour > 8) & (data.index.hour < 20)]
```

# The power of pandas: `resample`

+++

A very powerfull method is **`resample`: converting the frequency of the time series** (e.g. from hourly to daily data).

The time series has a frequency of 1 hour. I want to change this to daily:

```{code-cell} ipython3
data.resample('D').mean().head()
```

Other mathematical methods can also be specified:

```{code-cell} ipython3
data.resample('D').max().head()
```

<div class="alert alert-info">
<b>REMEMBER</b>: <br><br>

The string to specify the new time frequency: http://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#offset-aliases <br>

These strings can also be combined with numbers, eg `'10D'`...

</div>

```{code-cell} ipython3
data.resample('ME').mean().plot() # 10D, MS
```

<div class="alert alert-success">

**EXERCISE**

Plot the monthly standard deviation of the columns. Use the last day of each month to represent the month.

<details><summary>Hints</summary>

* Pandas has both a [`ME` and `MS` month (offset)](https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#dateoffset-objects) to represent the month by the 'calendar month end' (`ME`) or 'calendar month start' (`MS`) respectively.

</details>
    
</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

data.resample('ME').std().plot() # 'A'
```

<div class="alert alert-success">

**EXERCISE**

Plot the monthly mean and median values for the years 2011-2012 for 'L06_347'. Use the last day of each month to represent the month.

<details><summary>Hints</summary>

* Did you know <a href="https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.agg.html"><code>agg</code></a> to derive multiple statistics at the same time?

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

subset = data['2011':'2012']['L06_347']
subset.resample('ME').agg(['mean', 'median']).plot()
```

<div class="alert alert-success">

**EXERCISE**

Plot the monthly mininum and maximum daily average value of the 'LS06_348' column. Use the first day of each month to represent the month.

```{code-cell} ipython3
:tags: [nbtutor-solution]

daily = data['LS06_348'].resample('D').mean() # daily averages calculated
```

```{code-cell} ipython3
:tags: [nbtutor-solution]

daily.resample('MS').agg(['min', 'max']).plot() # monthly minimum and maximum values of these daily averages
```

<div class="alert alert-success">
    
**EXERCISE**
    
Make a bar plot of the mean of the stations in year of 2013

<details><summary>Hints</summary>

* If you can directly slice and aggregate the data, you do not have to use resample.

</details>

</div>

```{code-cell} ipython3
:tags: [nbtutor-solution]

data['2013':'2013'].mean().plot(kind='barh')
```

```{code-cell} ipython3

```

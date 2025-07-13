# Polars

DataFrames for the new era.

<https://pola.rs>

```python
import polars as pl
# filter
df.filter(pl.col("age") >= 10, pl.col("Salary") > 52_000)

# create new columns. reassign var if you want to keep it.
df = df.with_columns((pl.col("Salary") / 12).round(2).alias("Monthly Earnings"))

# drop a column
df = df.drop("Monthly Engineering")

# sort ascending by Salary
df.sort("Salary", descending=True)

# filter and aggregate afterwards. print max salary
df.filter(pl.col("age") > 30)['Salary'].max()

# group by departmenet and run aggregate function over the result.
df.group_by("Department").agg([
  pl.col("Salary").mean().alias("average salary"),
  pl.col("Age").min().alias("Youngest age")
])

# count NULL values in a column
df.null_count()

# shows with rows in a column are null
df.select(pl.col("Salary").is_null()

# show rows that are not null
df.filter(pl.col("salary").is_not_null())

# fill null values with literal value 50
df.with_columns(pl.col("salary").fill_null(pl.lit(50)))
# fill 'f'orward. take last valid value fill it in until next non-null value.
df.with_columns(pl.col("salary").fill_null(strategy='f'))
# fill 'b'ackward
df.with_columns(pl.col("salary").fill_null(strategy='b'))
# interpolate
df.with_columns(pl.col("salary").interpolate())

# Serializing
# write
df.write_csv("data.csv")
df.write_json("data.json")

# read. we can specify the column type (e.g. turn the date string into an actual date type)
df2 = pl.read_csv("data.csv")
```

## Plotting

```python
df["Age"].plot.bar()
df.plot.scatter(x="Age", y="Salary", by="Name")

## Conversion

* `to_numpy()` method to convert data to numpy format.
```



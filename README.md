# Matrix Tests #

A package dedicated to running statistical hypothesis tests on rows and columns of matrices.

## Examples ##

**1) Running one way ANOVA on every column of iris data using Species as groups**

```r
col_oneway_equalvar(iris[,-5], iris$Species)
```
```
             obs.tot obs.groups  sumsq.between  sumsq.within  meansq.between  meansq.within df.between df.within  statistic       pvalue
Sepal.Length     150          3       63.21213       38.9562       31.606067     0.26500816          2       147  119.26450 1.669669e-31
Sepal.Width      150          3       11.34493       16.9620        5.672467     0.11538776          2       147   49.16004 4.492017e-17
Petal.Length     150          3      437.10280       27.2226      218.551400     0.18518776          2       147 1180.16118 2.856777e-91
Petal.Width      150          3       80.41333        6.1566       40.206667     0.04188163          2       147  960.00715 4.169446e-85
```

**2) t-test on each row of 2 matrices each with a million rows.**

```r
X <- matrix(rnorm(10000000), ncol=10)
Y <- matrix(rnorm(10000000), ncol=10)
```

**The usual way** &#9200; 2 minutes 16 seconds

```r
res1 <- vector(nrow(X), mode="list")

for(i in 1:nrow(X)) {
  res1[[i]] <- t.test(X[i,], Y[i,])
}
```

```
  res1[1:2]
[[1]]

        Welch Two Sample t-test

data:  X[i, ] and Y[i, ]
t = 0.46049, df = 16.685, p-value = 0.6511
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.8330197  1.2973259
sample estimates:
  mean of x   mean of y
-0.06643757 -0.29859071


[[2]]

        Welch Two Sample t-test

data:  X[i, ] and Y[i, ]
t = -0.96859, df = 17.958, p-value = 0.3456
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -1.6005787  0.5905608
sample estimates:
  mean of x   mean of y
-0.02447724  0.48053173
```

**matrixTest way** &#9200; 2.4 seconds

```r
res2 <- row_t_welch(X, Y)
```
```
> res2[1:2,]
  obs.x obs.y obs.tot      mean.x     mean.y  mean.diff    var.x     var.y stderr          df  statistic    pvalue   conf.low conf.high alternative mean.null conf.level
1    10    10      20 -0.06643757 -0.2985907  0.2321531 1.627547 0.9140158 0.5041392 16.68493  0.4604941 0.6511065 -0.8330197 1.2973259   two.sided         0       0.95
2    10    10      20 -0.02447724  0.4805317 -0.5050090 1.424720 1.2936936 0.5213841 17.95828 -0.9685930 0.3456133 -1.6005787 0.5905608   two.sided         0       0.95
```

## Goals ##

1. Fast execution via vectorization.
2. Output that is detailed and easy to use.
3. Result compatibility with tests that are implemented in R.

## Available Tests ##

|             Name                   |      matrixTests            |       R equivalent
|------------------------------------|-----------------------------|-------------------------------------
| Single sample t.test               | `row_t_onesample(x)`        | `t.test(x)`
| Welch t.test                       | `row_t_welch(x, y)`         | `t.test(x, y)`
| Equal variance t.test              | `row_t_equalvar(x, y)`      | `t.test(x, y, var.equal=TRUE)`
| Paired t.test                      | `row_t_paired(x, y)`        | `t.test(x, y, paired=TRUE)`
| Pearson's correlation test         | `row_cor_pearson(x, y)`     | `cor.test(x, y)`
| Welch oneway ANOVA                 | `row_oneway_welch(x, g)`    | `oneway.test(x, g)`
| Equal variance oneway ANOVA        | `row_oneway_equalvar(x, g)` | `oneway.test(x, g, var.equal=TRUE)`
| Kruskal-Wallis test                | `row_kruskalwallis(x, g)`   | `kruskal.test(x, g)`
| Bartlett's test                    | `row_bartlett(x, g)`        | `bartlett.test(x, g)`

## Test-Based Procedures ##

|             Description             |      matrixTests       |       R equivalent
|-------------------------------------|------------------------|-------------------------------------
| EVORA                               | `row_ievora(x, g)`     | ---

## Installation ##

Using the `devtools` library:

```r
library(devtools)
install_github("KKPMW/matrixTests")
```

## Dependencies ##

1. `matrixStats` package.

## Design Decisions ##

The following design decision were taken (in no particular order):

### Function Names ###

Function names are composed of 3 elements separated by dots where needed:

`[row/col]_testname_variant`

The variant part can be dropped when not applicable or when only a single
variant for that test is implemented so far.

A few examples: `row_oneway_equalvar`, `row_bartlett`

In order to make the function names shorter the word *test* is not included.

### Single Test Per Function ###

Functions should provide a single type of test.

This means that some of the tests that in base R are implemented under a single
function will be split into different functions. For example in base R function
`t.test()` has parameters that can specify the type of t.test to use:
equal variance or Welch adjusted, paired or non paired.

In this package those types of choices are separated into separate functions
for the following reasons:

1. Output structure returned by a function is not dependant on the input values.
2. User is made to choose the test explicitly with no hidden defaults.
3. This convention makes it easier to add more test types later.

### Input Values ###

The functions try to make sense of the provided inputs when possible.
All the cases when the inputs are incorrectly specified should throw an error.

Edge cases should be handled gracefully. For example when input is a numeric
`matrix` with 0 rows - the result is a 0 row `data.frame`.

Below is a short list of implemented input rules:

1. Main parameters are numeric matrices.
2. Vectors are transformed into a 1-row matrix.
3. Data frames are automatically transformed into matrices if all of their
   columns are numeric.
4. When two matrices are required - either number of their rows should match or
   the second matrix must have only single row/column. In which case the same
   row/column will be repeated for all values of x.
5. Group specifications and additional parameters typically can have only one
   value that will be applied to all the rows.
6. In some cases additional parameters can have a separate value for each row.
   Those cases are specified in the help documentation.


### Outputs ###

Outputs are contained in a `data.frame` with each row providing the result of
the test performed on the corresponding row of the input matrix.

#### Output categories ####

Columns hold the relevant results that can be divided into 3 main categories:

1. Descriptive statistics related to the test. Typically ordered by increasing
complexity. For example: 1) number of observations, 2) means, 3) variances.

2. Outputs related to the test itself. Typically ordered by increasing complexity.
For example: 1) degrees of freedom, 2) test statistic, 3) p-value, 4) confidence interval.

3. Input parameters that were chosen for the row. Ordered by their appearance in
the function call. For example: 1) alternative hypothesis type, 2) mean of null hypothesis, 3) confidence level.

#### Column names ####

Column names of the output are written in consistent fashion and typically have two parts:
field and specification, separated by a dot.

All the fields are written as a single word and abbreviated if needed:

* **obs** - number of observations
* **mean** - estimated mean
* **var** - estimated variance
* **df** - degrees of freedom
* **statistic** - test statistic
* **pvalue** - p-value
* **stderr** - standard error
* **cor** - estimated correlation

Specifications are included only when necessary - when field is used more than once
or when clarification is necessary.

* **obs.x** - number of x observations
* **obs.tot** - total number of observations
* **mean.x** - mean of x
* **mean.diff** - mean of x and y difference
* **conf.low** - lower confidence interval
* **conf.high** - higher confidence interval

#### Row names ####

Row names are transfered from the main input matrix. If the row names of the
matrix were not unique - they are made unique using `make.unique()`. In case
input matrix had no row names the numbers `1:nrow(x)` are used.

### Compatibility with R ###

Results of tests should be as compatible as possible with the ones implemented
in base R. Allowed exceptions are cases where R's implementation is incorrect
or limiting.

A good example is `oneway.test()` which works only if all groups have more than
2 observations even when *var.equal* is set to *TRUE*. The strict requirement
for the test to run technically is for at least one group to have more than 1
observation. Therefore in such cases `row_oneway_equalvar()` works even if base
R version throws an error.

For another such example consider `bartlett.test()`. This function works without
any warnings when supplied with constant data and returns NA values:

```r
bartlett.test(rep(1,4), c("a","a","b","b"))
```
```
        Bartlett test of homogeneity of variances

data:  rep(1, 4) and c("a", "a", "b", "b")
Bartlett's K-squared = NaN, df = 1, p-value = NA
```

The typical behaviour in such situations for base R tests is to throw an error:

```r
t.test(c(1,1,1,1) ~ c("a","a","b","b"))
```
```
Error in t.test.default(x = c(1, 1), y = c(1, 1)) :
  data are essentially constant
```

Functions in this package try to be consistent with each other and be as
informative as possible. Therefore in such cases `row_bartlett()` will throw a
warning even if base R function does not.

```r
row_bartlett(c(1,1,1,1), c("a","a","b","b"))
```
```
  obs.tot obs.groups var.pooled df statistic pvalue
1       4          2          0  1        NA     NA
Warning message:
row_bartlett: 1 of the rows had zero variance in all of the groups.
First occurrence at row 1
```

### Warnings and Errors ###

Errors are produced only when the input parameters are not correctly specified.

Warnings are shown in situations when there was something wrong with doing a
test itself given the specified input parameters.

Such a decision for warnings was taken because users will typically perform
multiple tests (one for each row). The function cannot fail when one or few
of those tests cannot be completed. So even when R base tests throw an error
the functions in this package will instead produce an informative warning for
the row that failed and if needed will set all it's return values related to the
test to `NA` so that the user will not be able to use them by mistake.

Note that in these cases only test-related values like test statistic, p-value
and confidence interval are set to NA. Other returned values: number of
observations, means, variances and similar will still be returned as usual.

As an example of such behaviour consider the case when base t-test with Welch
correction fails because it has not enough observations:

```r
t.test(c(1,2), 3)
```
```
Error in t.test.default(c(1, 2), 3) : not enough 'y' observations
```

Function in this package proceeds, but throws a warning and takes care to set
the failed outputs to NA:

```r
row_t_welch(c(1,2), 3)
```
```
  obs.x obs.y obs.tot mean.x mean.y mean.diff var.x var.y  stderr  df statistic pvalue conf.low conf.high alternative mean.null conf.level
1     2     1       3    1.5      3      -1.5   0.5   NaN     NaN NaN        NA     NA       NA        NA   two.sided         0       0.95
Warning message:
row_t_welch: 1 of the rows had less than 2 "y" observations.
First occurrence at row 1
```

This allows the function continue working in cases where typically we have enough
observations per group but some rows might not have enough due to NA values.

```r
mat1 <- rbind(c(1,2), c(3,NA))
mat2 <- rbind(c(2,3), c(0,4))
row_t_welch(mat1, mat2)
```
```
  obs.x obs.y obs.tot mean.x mean.y mean.diff var.x var.y stderr     df statistic    pvalue  conf.low conf.high alternative mean.null conf.level
1     2     2       4    1.5    2.5        -1   0.5   0.5 0.7071068   2 -1.414214 0.2928932 -4.042435  2.042435   two.sided         0       0.95
2     1     2       3    3.0    2.0         1   NaN   8.0       NaN NaN        NA        NA        NA        NA   two.sided         0       0.95
row_t_welch: 1 of the rows had less than 2 "x" observations.
First occurrence at row 2
```

### NA and NaN values ###

`NA` and `NaN` values from the input matrices are silently removed and each
row is treated like a vector that has no `NA`/`NaN` values.

When `NA` or `NaN` values are present in the parameter specifying the groups
the corresponding values from the input matrices are dropped before doing the
tests. For example if the specified group variable has a `NA`:

```r
x <- rnorm(5)
g <- c(NA,"a", "a", "b", "b")
row_oneway_welch(x=x, g=g)
```
```
  obs.tot obs.groups df.between df.within  statistic    pvalue
1       4          2          1  1.440393 0.02349341 0.8968457
```

then the entire first column from the input matrix x corresponding to that group
will be removed. And the result will be equivalent to:

```r
row_oneway_welch(x=x[-1], g=g[-1])
```
```
  obs.tot obs.groups df.between df.within  statistic    pvalue
1       4          2          1  1.440393 0.02349341 0.8968457
```

Other parameters might allow or not allow `NA` values depending on context. For
example you cannot specify `NA` as wanted confidence level when doing a test
because not knowing your confidence level makes little sense.

## Notes ##

All the tests are implemented in R. So when running a test on a single row there
should be no increase in execution speed compared with the base R versions. In
most cases a slight decrease is expected due to the more detailed output.

For now the column-wise versions of the tests simply transposes the input
matrix and calls the equivalent row-wise test.

Candidates of tests that will be implemented next:

1. Shapiro-Wilks test for normality
2. Spearman and Kendall correlation tests
3. Test for proportions
4. Fisher's exact test

## See Also ##

1. **Computing thousands of test statistics simultaneously in R**,
*Holger Schwender, Tina Müller*. Statistical Computing & Graphics. Volume 18, No 1, June 2007.
2. `lmFit` in the [**limma**](https://bioconductor.org/packages/release/bioc/html/limma.html) package.
3. `rowttests()` in the [**genefilter**](https://bioconductor.org/packages/release/bioc/html/genefilter.html) package.
4. `mt.teststat()` in the [**multtest**](https://www.bioconductor.org/packages/release/bioc/html/multtest.html) package.
5. `row.T.test()` in the [**HybridMTest**](https://www.bioconductor.org/packages/release/bioc/html/HybridMTest.html) package.
6. `rowTtest()` in the [**viper**](https://bioconductor.org/packages/release/bioc/html/viper.html) package.
7. `ttests()` in the [**Rfast**](https://CRAN.R-project.org/package=Rfast) package.


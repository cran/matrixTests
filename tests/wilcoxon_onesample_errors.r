library(matrixTests)
source("utils/capture.r")

#--- x argument errors ---------------------------------------------------------

# cannot be missing
err <- 'argument "x" is missing, with no default'
res <- capture(row_wilcoxon_onesample())
stopifnot(all.equal(res$error, err))

# cannot be NULL
err <- '"x" must be a numeric matrix or vector'
res <- capture(row_wilcoxon_onesample(NULL))
stopifnot(all.equal(res$error, err))

# cannot be character
err <- '"x" must be a numeric matrix or vector'
res <- capture(row_wilcoxon_onesample(c("1", "2")))
stopifnot(all.equal(res$error, err))

# cannot be logical
err <- '"x" must be a numeric matrix or vector'
res <- capture(row_wilcoxon_onesample(c(TRUE, FALSE)))
stopifnot(all.equal(res$error, err))

# cannot be complex
err <- '"x" must be a numeric matrix or vector'
res <- capture(row_wilcoxon_onesample(complex(c(1,2), c(3,4))))
stopifnot(all.equal(res$error, err))

# cannot be data.frame containing some non numeric data
err <- '"x" must be a numeric matrix or vector'
res <- capture(row_wilcoxon_onesample(iris))
stopifnot(all.equal(res$error, err))

# cannot be a list
err <- '"x" must be a numeric matrix or vector'
res <- capture(row_wilcoxon_onesample(as.list(c(1:5))))
stopifnot(all.equal(res$error, err))

# cannot be in a list
err <- '"x" must be a numeric matrix or vector'
res <- capture(row_wilcoxon_onesample(list(1:5)))
stopifnot(all.equal(res$error, err))


#--- alternative argument errors -----------------------------------------------

err <- '"alternative" must be a character vector with length 1 or nrow(x)'

# cannot be NA
res <- capture(row_wilcoxon_onesample(x=1:3, alternative=NA))
stopifnot(all.equal(res$error, err))

# cannot be numeric
res <- capture(row_wilcoxon_onesample(x=1:3, alternative=1))
stopifnot(all.equal(res$error, err))

# cannot be complex
res <- capture(row_wilcoxon_onesample(x=1:3, alternative=complex(1)))
stopifnot(all.equal(res$error, err))

# cannot be in a list
res <- capture(row_wilcoxon_onesample(x=1:3, alternative=list("less")))
stopifnot(all.equal(res$error, err))

# cannot be a data frame
res <- capture(row_wilcoxon_onesample(x=1:3, alternative=data.frame("less")))
stopifnot(all.equal(res$error, err))


err <- 'all "alternative" values must be in: two.sided, less, greater'

# must be in correct set
res <- capture(row_wilcoxon_onesample(x=1:3, alternative="ga"))
stopifnot(all.equal(res$error, err))

# error produced even when some are correct
res <- capture(row_wilcoxon_onesample(x=matrix(1:10, nrow=2), alternative=c("g","c")))
stopifnot(all.equal(res$error, err))


#--- null argument errors ------------------------------------------------------

err <- '"null" must be a numeric vector with length 1 or nrow(x)'

# cannot be a character
res <- capture(row_wilcoxon_onesample(x=1:3, null="1"))
stopifnot(all.equal(res$error, err))

# cannot be complex
res <- capture(row_wilcoxon_onesample(x=1:3, null=complex(1)))
stopifnot(all.equal(res$error, err))

# cannot be in a list
res <- capture(row_wilcoxon_onesample(x=1:3, null=list(1)))
stopifnot(all.equal(res$error, err))

# cannot be a data frame
res <- capture(row_wilcoxon_onesample(x=1:3, null=data.frame(1)))
stopifnot(all.equal(res$error, err))


err <- 'all "null" values must be greater than -Inf and lower than Inf'

# cannot be NA
res <- capture(row_wilcoxon_onesample(x=1:3, null=NA_integer_))
stopifnot(all.equal(res$error, err))

# cannot be NaN
res <- capture(row_wilcoxon_onesample(x=1:3, null=NaN))
stopifnot(all.equal(res$error, err))

# TODO: check if can be made to work with Inf
# cannot be Inf
res <- capture(row_wilcoxon_onesample(x=1:3, null=Inf))
stopifnot(all.equal(res$error, err))

# cannot be -Inf
res <- capture(row_wilcoxon_onesample(x=1:3, null=-Inf))
stopifnot(all.equal(res$error, err))


#--- exact argument errors -----------------------------------------------------

err <- '"exact" must be a logical vector with length 1 or nrow(x)'

# cannot be non-logical NA
res <- capture(row_wilcoxon_onesample(x=1:3, exact=NA_integer_))
stopifnot(all.equal(res$error, err))

# cannot be numeric
res <- capture(row_wilcoxon_onesample(x=1:3, exact=1))
stopifnot(all.equal(res$error, err))

# cannot be character
res <- capture(row_wilcoxon_onesample(x=1:3, exact="TRUE"))
stopifnot(all.equal(res$error, err))

# cannot be complex
res <- capture(row_wilcoxon_onesample(x=1:3, exact=complex(1)))
stopifnot(all.equal(res$error, err))

# cannot be in a list
res <- capture(row_wilcoxon_onesample(x=1:3, exact=list(TRUE)))
stopifnot(all.equal(res$error, err))

# cannot be a data frame
res <- capture(row_wilcoxon_onesample(x=1:3, exact=data.frame(TRUE)))
stopifnot(all.equal(res$error, err))


#--- correct argument errors ---------------------------------------------------

err <- 'all "correct" values must be in: TRUE, FALSE'

# cannot be NA
res <- capture(row_wilcoxon_onesample(x=1:3, correct=NA))
stopifnot(all.equal(res$error, err))


err <- '"correct" must be a logical vector with length 1 or nrow(x)'

# cannot be numeric
res <- capture(row_wilcoxon_onesample(x=1:3, correct=0))
stopifnot(all.equal(res$error, err))

# cannot be character
res <- capture(row_wilcoxon_onesample(x=1:3, correct="FALSE"))
stopifnot(all.equal(res$error, err))

# cannot be complex
res <- capture(row_wilcoxon_onesample(x=1:3, correct=complex(1)))
stopifnot(all.equal(res$error, err))

# cannot be in a list
res <- capture(row_wilcoxon_onesample(x=1:3, correct=list(FALSE)))
stopifnot(all.equal(res$error, err))

# cannot be a data frame
res <- capture(row_wilcoxon_onesample(x=1:3, correct=data.frame(FALSE)))
stopifnot(all.equal(res$error, err))


#--- dimension mismatch errors -------------------------------------------------

# null must match x number of rows
err <- '"null" must be a numeric vector with length 1 or nrow(x)'
x <- matrix(1:12, nrow=4)
res <- capture(row_wilcoxon_onesample(x, null=c(1,2)))
stopifnot(all.equal(res$error, err))

# alternative must match x number of rows
err <- '"alternative" must be a character vector with length 1 or nrow(x)'
x <- matrix(1:12, nrow=4)
res <- capture(row_wilcoxon_onesample(x, alternative=c("g","l")))
stopifnot(all.equal(res$error, err))

# exact must match x number of rows
err <- '"exact" must be a logical vector with length 1 or nrow(x)'
x <- matrix(1:12, nrow=4)
res <- capture(row_wilcoxon_onesample(x, exact=c(TRUE, FALSE)))
stopifnot(all.equal(res$error, err))

# correct must match x number of rows
err <- '"correct" must be a logical vector with length 1 or nrow(x)'
x <- matrix(1:12, nrow=4)
res <- capture(row_wilcoxon_onesample(x, correct=c(TRUE, FALSE)))
stopifnot(all.equal(res$error, err))


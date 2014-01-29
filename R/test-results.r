# format results from ListReporter
summarize_results <- function(results_list) {
  rows <- lapply(results_list, .sumarize_one_test_results)
  do.call(rbind, rows)
}

.sumarize_one_test_results <- function(test) {
  test_results <- test$results
  nb_tests <- length(test_results)
  
  nb_failed <- 0L
  error <- FALSE
  
  if (nb_tests > 0) {
    # error reports should be handled differently. 
    # They may not correspond to an expect_that() test so remove them
    last_test <- test_results[[nb_tests]]
    error <- last_test$error
    if (error) {
      test_results <- test_results[- nb_tests]
      nb_tests <- length(test_results)
    }
    
    nb_failed <- sum(!vapply(test_results, '[[', TRUE, 'passed'))
  }
  
  context <- if (length(test$context)) test$context else ''
  res <- data.frame(file = test$file, context = context, test = test$test,
    nb = nb_tests, failed = nb_failed, error = error, user = test$user, 
    system = test$system, real = test$real, stringsAsFactors = FALSE)
  
  res
}

#' convert testthat_results to data frame
#' @param x   the testthat results
#' @param ... ignored
#' @return a data frame
#' @S3method as.data.frame testthat_results
as.data.frame.testthat_results <- function(x, ...) {
  summarize_results(x)
}


#' print testthat_results as a data frame
#' @param x   the testthat results
#' @param ... ignored
#' @S3method print testthat_results
print.testthat_results <- function(x, ...) {
  print(as.data.frame(x))
}


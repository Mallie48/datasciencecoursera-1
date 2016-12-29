## MY attempt at passing assignment for coursera

## caching the inverse of a matrix -  storing it in the cache
## and checking if it is calculated first

makeCacheMatrix <- function(x = matrix()) {

  # Looks tricky so follow the example in the course changing mean to inverse
  minv<NULL  # set inverse to null in existing directory
  set<-function(y) {# set inverse to null in cache
    x <<-y
    minv <<-null 
    
  }
  #store the calculation in cache
  get<-function() x
  setinv=function(inverse) minv <<-inverse
  getinv<-function() minv
  list(set=set,get=get, 
       setinv=setinv, getinv=getinv)
 
 
}


## creating the inverse of a matrix

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
  minv<-x$getinv() # follow the example in the question
  #check if it is already calculated and get from cache
  if(!is.null(minv)) {
    message("Getting Cache Data")
    return(minv) #if not calculate it
    
  }
  data <-x$get()# set data to the matrix
  minv<-solve(data,...)# calculate the inverse
  x$setinv(minv)
  minv
}

# Person-Centred Trust in Artificial Intelligence

## Getting Started

### System requirements

This software has been tested on Windows 11 Enterprise (version 24H2).

### Installation

To run this code, you will need to [install R](https://www.r-project.org/) and 
the following R packages:

```r
install.packages(c("tarchetypes", "targets", "tidyverse"))
```

The code was run using the package versions listed in `sessionInfo.txt`. If
issues arise, try installing the specific package versions listed there.

### Execute code

To run the pipeline:

1. Clone this repository to your local machine
2. Open the R Project file `person-trust-ai.Rproj`
3. In the console, run the full pipeline with `targets::tar_make()`

## Help

Any issues, please email scott.claessens@gmail.com.

## Authors

Scott Claessens, scott.claessens@gmail.com

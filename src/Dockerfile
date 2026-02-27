#using this base image allows CRAN installs from binaries, making this MUCH faster than building from source
FROM rocker/r2u:24.04
# install dependencies
RUN R -e 'if (!require("hdf5r")) install.packages("hdf5r")'
RUN R -e 'if (!require("Seurat")) install.packages("Seurat")'

# install platform specific source package
RUN R -e 'os <- sub("Darwin", "macOS", Sys.info()["sysname"]); \
url <- paste0("https://github.com/10XGenomics/loupeR/releases/latest/download/loupeR_", os, ".tar.gz"); \
install.packages(url, repos = NULL, type = "source");'
#for non-interactive set-up, set value to y after reviewing https://10xgen.com/EULA
#but trying building first and then make the change here to see how the layered caching works
ENV AUTO_ACCEPT_EULA=n
#installs the louper executable
RUN R -e 'loupeR::setup()'

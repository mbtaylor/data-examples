
KERRS_INFILE = kerr-transfer-functions.fits
KERRS_OUTFILE = kerr.fits

build: $(KERRS_OUTFILE)

$(KERRS_INFILE):
	curl -L https://github.com/fjebaker/lineprofiles/releases/download/v0.1.0/kerr-transfer-functions-v0.1.0.zip \
        | jar x

hdunames.lis:
	stilts tpipe in=:loop:600 \
             cmd='addcol name \"$(KERRS_INFILE)\#\"+(i+3)' \
             cmd='keepcols name' \
             ofmt='csv(header=false)' \
             out=$@

$(KERRS_OUTFILE): hdunames.lis $(KERRS_INFILE)
	stilts tcat in=@hdunames.lis \
            uloccol=uloc \
            icmd='addcol gstars param$$GSTARS' \
            icmd='addcol metric param$$METRIC' \
            icmd='addcol spin parseFloat(param$$SPIN)' \
            icmd='addcol incl parseFloat(param$$INCL)' \
            ocmd='addcol ihdu parseInt(uloc)' \
            ocmd='keepcols "ihdu spin incl r g_min g_max lower upper"' \
            ocmd=progress \
            out=$(KERRS_OUTFILE)

clean:
	rm -f $(KERRS_OUTFILE) hdunames.lis

veryclean: clean
	rm -f $(KERRS_INFILE)


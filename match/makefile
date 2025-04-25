# Creates two files that can be matched against each other.
# They are from the same region of sky, taken from the 2MASS and Gaia DR3
# catalogues.

# The stats target acquires the files, matches them against each other,
# and reports the number of rows in the input files and the match result.
# The plot target plots the result.

# If you want more/fewer rows, adjust the RADIUS value
# If you want a lot more rows, the tapquery commands might need adjusting
# a bit, e.g. making them run in async mode.

# If you prefer a different table format, just change the filenames
# e.g. s/.fits/.csv/g

STILTS = ./stilts
RA = 93.3816     # sky region center RA
DEC = -43.7047   # sky region center Declination
RADIUS = 0.8     # sky region radius in degrees
MATCH_TOL = 1.0  # match tolerance in arcsec

COLS_2MASS = mainid AS id_2mass, raj2000 AS ra_2mass, dej2000 AS dec_2mass
COLS_GAIA = source_id AS id_gaia, ra AS ra_gaia, dec AS dec_gaia
INPUT_FILES = 2mass.fits gaia.fits
MATCH_FILE = match.fits


run: stats

data: $(INPUT_FILES)

build: data $(MATCH_FILE)

stats: build
	for f in $(INPUT_FILES) $(MATCH_FILE); \
        do \
           echo -n "$$f:\t"; \
           $(STILTS) tpipe in=$$f omode=count; \
        done

clean:
	rm -f $(INPUT_FILES) $(MATCH_FILE) $(STILTS)

veryclean: clean
	rm -f stilts.jar

stilts.jar:
	curl -OL http://www.starlink.ac.uk/stilts/stilts.jar

$(STILTS): stilts.jar
	unzip stilts.jar stilts
	touch stilts
	chmod +x stilts

2mass.fits 2mass.csv: $(STILTS)
	$(STILTS) tapquery tapurl=http://dc.g-vo.org/tap sync=true \
                  adql="SELECT $(COLS_2MASS) FROM twomass.data \
                        WHERE DISTANCE(raj2000,dej2000,$(RA),$(DEC))<$(RADIUS)"\
                  out=$@

gaia.fits gaia.csv: $(STILTS)
	$(STILTS) tapquery tapurl=http://dc.g-vo.org/tap sync=true \
                  adql="SELECT $(COLS_GAIA) FROM gaia.dr3lite \
                        WHERE DISTANCE(ra,dec,$(RA),$(DEC))<$(RADIUS)" \
                  maxrec=100000 \
                  out=$@

match.fits match.csv: $(STILTS) 2mass.fits gaia.fits
	$(STILTS) tskymatch2 in1=2mass.fits ra1=ra_2mass dec1=dec_2mass \
                             in2=gaia.fits ra2=ra_gaia dec2=dec_gaia \
                             find=best1 error=$(MATCH_TOL) \
                             out=$@

plot: 2mass.fits gaia.fits match.fits
	$(STILTS) plot2sky \
                  layer_t=mark in_t=2mass.fits lon_t=ra_2mass lat_t=dec_2mass \
                               leglabel_t=2mass color_t=red size_t=4 \
                               shape_t=cross \
                  layer_g=mark in_g=gaia.fits lon_g=ra_gaia lat_g=dec_gaia \
                               leglabel_g=gaia color_g=blue size_g=4 \
                               shape_g=x \
                  in_m=match.fits lon1_m=ra_2mass lat1=dec_2mass \
                                  lon2_m=ra_gaia lat2=dec_gaia \
                                  color_m=grey \
                  layer_ma=mark2 shape_ma=open_circle size_ma=4 \
                  layer_mb=link2 \
                  seq=_ma,_mb,_t,_g legseq=_t,_g \



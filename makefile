
TAP_URL = https://gea.esac.esa.int/tap-server/tap

POLY_F = 54.40,-25.26, 49.89,-26.88, 51.42,-31.02, 56.26,-29.40
POLY_N = 272.72,70.19, 258.56,66.47, 266.62,61.93, 279.88,65.03
POLY_S = 68.69,-47.21, 64.08,-44.36, 53.65,-48.43, 59.13,-53.58

COLUMNS = source_id, ra, dec, parallax, pmra, pmdec, \
          ra_error, dec_error, parallax_error, pmra_error, pmdec_error, \
          random_index, phot_g_mean_mag, phot_bp_mean_mag, phot_rp_mean_mag, \
          in_qso_candidates, in_galaxy_candidates, \
          classprob_dsc_combmod_quasar, classprob_dsc_combmod_galaxy, \
          classprob_dsc_combmod_star

POST_FILTER = \
    ocmd='addcol parallax_over_error sqrt(square(parallax/parallax_error))' \
    ocmd='addcol pm_over_error hypot(pmra/pmra_error,pmdec/pmdec_error)' \
    ocmd='addcol tmz_star parallax_over_error>5||pm_over_error>5' \
    ocmd='addcol negative_parallax parallax<0' \

DATA_FILES = gaia-f.fits gaia-n.fits gaia-s.fits gaia-q1.fits
PLOTS = plot1.png

build: $(DATA_FILES) $(PLOTS)

plot: plot1

gaia-f.fits:
	stilts tapquery tapurl=$(TAP_URL) sync=true maxrec=1000000 \
               adql="select $(COLUMNS) from gaiadr3.gaia_source \
                     where 1=contains(point(ra,dec), polygon($(POLY_F)))" \
               ocmd='select inMoc(\"EDFF_moc_12.fits\",ra,dec)' \
               $(POST_FILTER) \
               out=$@

gaia-n.fits:
	stilts tapquery tapurl=$(TAP_URL) sync=true maxrec=1000000 \
               adql="select $(COLUMNS) from gaiadr3.gaia_source \
                     where 1=contains(point(ra,dec), polygon($(POLY_N)))" \
               ocmd='select inMoc(\"EDFN_moc_12.fits\",ra,dec)' \
               $(POST_FILTER) \
               out=$@

gaia-s.fits:
	stilts tapquery tapurl=$(TAP_URL) sync=true maxrec=1000000 \
               adql="select $(COLUMNS) from gaiadr3.gaia_source \
                     where 1=contains(point(ra,dec), polygon($(POLY_S)))" \
               ocmd='select inMoc(\"EDFS_moc_12.fits\",ra,dec)' \
               $(POST_FILTER) \
               out=$@

gaia-q1.fits: gaia-f.fits gaia-n.fits gaia-s.fits
	stilts tcat in=gaia-f.fits in=gaia-n.fits in=gaia-s.fits \
               out=$@

PLOT1_ARGS = \
    x=parallax_over_error y=pm_over_error shading=auto \
    xpix=800 ypix=800 \
    xlog=true ylog=true \
    legend=true legpos=0.05,0.95 \
    layer_1=Mark \
       icmd_1='select tmz_star' \
       shape_1=cross color_1=pink \
       leglabel_1='2: tmz_star' \
    layer_2=Mark \
       icmd_2='select !(tmz_star)' \
       shape_2=cross color_2=grey \
       leglabel_2='2: not_tmz_star' \
    layer_4=Mark \
       icmd_4='select classprob_dsc_combmod_quasar>0.5' \
       color_4=magenta \
       leglabel_4='2: dsc_qso' \
    layer_5=Mark \
       icmd_5='select classprob_dsc_combmod_galaxy>0.5' \
       color_5=cyan \
       leglabel_5='2: dsc_galaxy' \

plot1: gaia-q1.fits
	stilts plot2plane \
           in=gaia-q1.fits \
           $(PLOT1_ARGS) \

plot1.png: gaia-n.fits
	stilts plot2plane \
           in=gaia-q1.fits \
           $(PLOT1_ARGS) \
           out=$@

clean:
	rm -f $(PLOTS)

veryclean: clean
	rm -f $(DATA_FILES)

            

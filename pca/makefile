
UPLOAD_DIR = /mnt/webserver/astro_webserver/mbt/data/turci


build: m45.csv m45.fits pm.png hrd.png

upload: build
	rm -rf $(UPLOAD_DIR)
	mkdir -p $(UPLOAD_DIR)
	cp m45.csv pm.png hrd.png makefile $(UPLOAD_DIR)

STILTS = ./stilts

COLS = source_id ra dec l b \
       parallax pmra pmdec \
       phot_g_mean_mag phot_bp_mean_mag phot_rp_mean_mag \
       ra_error dec_error parallax_error pmra_error pmdec_error \
       radial_velocity radial_velocity_error \
       pseudocolour pseudocolour_error \
       grvs_mag grvs_mag_error grvs_mag_nb_transits \
       ruwe \
       astrometric_n_obs_al astrometric_n_obs_ac astrometric_n_good_obs_al \
       astrometric_n_bad_obs_al astrometric_gof_al astrometric_chi2_al \
       astrometric_excess_noise astrometric_excess_noise_sig \
       astrometric_params_solved astrometric_primary_flag \
       nu_eff_used_in_astrometry \
       teff_gspphot logg_gspphot mh_gspphot distance_gspphot \
       azero_gspphot ag_gspphot ebpminrp_gspphot \

CLUSTER = hypot((pmra-19.9)/2.6,(pmdec+45.4)/3.4)<1

stilts.jar:
	curl -OL http://www.starlink.ac.uk/stilts/stilts.jar

$(STILTS): stilts.jar
	unzip stilts.jar stilts
	touch stilts
	chmod +x stilts

m45-full.fits m45-full.csv: stilts
	$(STILTS) cone lon=56.6 lat=24.4 radius=2 verb=3 \
                  serviceurl=https://gaia.ari.uni-heidelberg.de/cone/gaiadr3 \
                  out=$@

m45.fits m45.csv: stilts m45-full.fits
	$(STILTS) tpipe in=m45-full.fits cmd='keepcols "$(COLS)"' \
                  cmd='colmeta -name g phot_g_mean_mag' \
                  cmd='colmeta -name bp phot_bp_mean_mag' \
                  cmd='colmeta -name rp phot_rp_mean_mag' \
                  out=$@

pm.png: stilts m45.fits
	$(STILTS) plot2plane in=m45.fits icmd2='select $(CLUSTER)' \
                             leglabel1=all leglabel2=cluster legpos=.9,.9 \
                             x=pmra y=pmdec \
                             xmin=-19 xmax=39 ymin=-55 ymax=25 \
                             layer1=mark color1=red \
                             layer2=mark color2=blue \
                             out=$@

hrd.png: stilts m45.fits
	$(STILTS) plot2plane in=m45.fits icmd2='select $(CLUSTER)' \
                             leglabel1=all leglabel2=cluster legpos=.9,.9 \
                             x=bp-rp y=g yflip=true \
                             layer1=mark color1=red \
                             layer2=mark color2=blue \
                             out=$@

clean:
	rm -f m45.csv m45.fits pm.png hrd.png

veryclean: clean
	rm -f stilts.jar stilts
	rm -f m45-full.fits m45-full.csv



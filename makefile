
TAP_URL = https://gea.esac.esa.int/tap-server/tap

POLY_F = 54.40,-25.26, 49.89,-26.88, 51.42,-31.02, 56.26,-29.40
POLY_N = 272.72,70.19, 258.56,66.47, 266.62,61.93, 279.88,65.03
POLY_S = 68.69,-47.21, 64.08,-44.36, 53.65,-48.43, 59.13,-53.58

COLUMNS = *
DATA_FILES = gaia-f.fits gaia-n.fits gaia-s.fits

build: $(DATA_FILES)

gaia-f.fits:
	stilts tapquery tapurl=$(TAP_URL) sync=true maxrec=1000000 \
               adql="select $(COLUMNS) from gaiadr3.gaia_source \
                     where 1=contains(point(ra,dec), polygon($(POLY_F)))" \
               ocmd='select inMoc(\"EDFF_moc_12.fits\",ra,dec)' \
               out=$@

gaia-n.fits:
	stilts tapquery tapurl=$(TAP_URL) sync=true maxrec=1000000 \
               adql="select $(COLUMNS) from gaiadr3.gaia_source \
                     where 1=contains(point(ra,dec), polygon($(POLY_N)))" \
               ocmd='select inMoc(\"EDFN_moc_12.fits\",ra,dec)' \
               out=$@

gaia-s.fits:
	stilts tapquery tapurl=$(TAP_URL) sync=true maxrec=1000000 \
               adql="select $(COLUMNS) from gaiadr3.gaia_source \
                     where 1=contains(point(ra,dec), polygon($(POLY_S)))" \
               ocmd='select inMoc(\"EDFS_moc_12.fits\",ra,dec)' \
               out=$@

clean:
	rm -f $(DATA_FILES)
            

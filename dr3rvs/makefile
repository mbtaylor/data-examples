
# Makefile for acquiring all the rvs_mean_spectra and storing them
# in a single STILTS/TOPCAT-friendly file.  Options also exist
# for doing the same thing with a subsample of the data.
# Running this will require about 40 Gb of free space in the
# current directory.  Download and processing maybe a couple of hours.

# Comment out one of the two SPECTRA_FILE definitions below,
# depending on whether you want all the 999,645 spectra or
# just a few.  You can adjust the sample size too.
# It might be a good idea to start with a subsample before working
# with the big file (18Gb).

# SPECTRA_FILE = dr3rvs_all.fits
SPECTRA_FILE = dr3rvs_sample.fits
SAMPLE_SIZE = 2000

ECSV_DIR = rvs_mean_spectrum
STILTS = ./stilts

build: $(SPECTRA_FILE) \
       plot.pdf

clean:
	rm -f plot.pdf plot.svg plot.png
	rm -f plot_basic.pdf plot_quartiles.pdf plot_linear.pdf

veryclean: clean
	rm -f stilts.jar stilts
	rm -f $(SPECTRA_FILE)

stilts.jar:
	curl -OL http://www.starlink.ac.uk/stilts/stilts.jar

stilts: stilts.jar
	jar xf stilts.jar stilts
	touch stilts
	chmod +x stilts

# If this times out, try sync=false instead.
dr3rvs_sample.fits: stilts
	$(STILTS) \
           tapquery tapurl=https://gaia.ari.uni-heidelberg.de/tap \
           adql='SELECT TOP $(SAMPLE_SIZE) * FROM gaiadr3.rvs_mean_spectrum' \
           sync=true \
           out=$@

# This worked once, but effective limits at the ARI-Gaia service
# mean that that it probably will fail now.

#dr3rvs_all.fits:
#	$(STILTS) \
#           tapquery tapurl=https://gaia.ari.uni-heidelberg.de/tap \
#           maxrec=1000000 \
#           adql='SELECT * FROM gaiadr3.rvs_mean_spectrum' \
#           out=$@

dr3rvs_all.fits: stilts $(ECSV_DIR)/all-downloaded
	( cd $(ECSV_DIR); \
          ../stilts tcat ifmt=ecsv in=@../ecsv-names.lis \
                         countrows=true lazy=true \
                         ocmd=progress \
                         out=../$@ )

$(ECSV_DIR)/all-downloaded: ecsv-names.lis
	sh download-ecsvs.sh && touch $@

PLOT_CMD=$(STILTS) -Xmx24G \
                   plot2plane \
                   xpix=1200 ypix=500 \
                   in=$(SPECTRA_FILE) icmd=progress \
                   xs='sequence(2401,846,0.01)' ys=flux \
                   layer_1=lines \
                           shading_1=density densemap_1=inferno \
                   layer_2=arrayquantile \
                           color_2=green transparency_2=0.35 \
                           quantiles_2=0.25,0.75 \
                   axis_L=Vertical \
                   color_L=grey \
                   layer_L1=Function fexpr_L1=850.035 \
		   layer_L2=Function fexpr_L2=854.444 \
                   layer_L3=Function fexpr_L3=866.452 \
                   xmin=846 xmax=870 ymax=4 \
                   fontsize=12 \
                   minor=false \
                   xcrowd=0.5 \
                   xlabel='Rest wavelength (nm)' \
                   ylabel='Normalised flux' \

plot: $(SPECTRA_FILE) stilts
	$(PLOT_CMD)

plot.pdf plot.png plot.svg: $(SPECTRA_FILE) stilts
	$(PLOT_CMD) \
        out=$@


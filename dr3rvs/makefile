
SPECTRA_FILE = dr3rvs_all.fits
# SPECTRA_FILE = dr3rvs_sample.fits
SAMPLE_SIZE = 2000
STILTS = ./stilts

build: $(SPECTRA_FILE) \
       plot_basic.pdf plot_quartiles.pdf plot_linear.pdf

clean:
	rm -f plot.pdf plot.svg plot.png
	rm -f plot_basic.pdf plot_quantiles.pdf plot_linear.pdf

veryclean: clean
	rm -f stilts.jar stilts
	rm -f $(SPECTRA_FILE)

stilts.jar:
	curl -OL http://www.starlink.ac.uk/stilts/stilts.jar

stilts: stilts.jar
	jar xf stilts.jar stilts
	touch stilts
	chmod +x stilts

dr3rvs_sample.fits: stilts
	$(STILTS) \
           tapquery tapurl=https://gaia.ari.uni-heidelberg.de/tap \
           adql='SELECT TOP $(SAMPLE_SIZE) * FROM gaiadr3.rvs_mean_spectrum' \
           out=$@

dr3rvs_all.fits:
	$(STILTS) \
           tapquery tapurl=https://gaia.ari.uni-heidelberg.de/tap \
           maxrec=1000000 \
           adql='SELECT * FROM gaiadr3.rvs_mean_spectrum' \
           out=$@

PLOT_CMD=$(STILTS) plot2plane \
                   xpix=1200 ypix=500 \
                   in=$(SPECTRA_FILE) icmd=progress \
                   xs='sequence(2401,840,0.01)' ys=flux \
                   layer1=lines \
                          shading1=density densemap1=inferno \
                   layer2=arrayquantile \
                          color2=green transparency2=0.35 \
                          quantiles2=0.25,0.75 \
                   xmin=840 xmax=864 ymax=2.01 \
                   minor=false \
                   xcrowd=0.5 \
                   xlabel='Wavelength (nm)' \
                   ylabel='Normalised flux' \

plot: $(SPECTRA_FILE) stilts
	$(PLOT_CMD)

plot_basic.pdf plot_basic.png plot_basic.svg: $(SPECTRA_FILE) stilts
	$(PLOT_CMD) \
        seq=1 out=$@

plot_quantiles.pdf plot_quantiles.png plot_quantiles.svg: $(SPECTRA_FILE) stilts
	$(PLOT_CMD) \
        seq=1,2 out=$@

plot_linear.pdf plot_linear.png plot_linear.svg: $(SPECTRA_FILE) stilts
	$(PLOT_CMD) \
        seq=1 densefunc1=linear out=$@


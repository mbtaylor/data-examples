
datadir=rvs_mean_spectrum
tmpfile=
mkdir -p $datadir
rm $datadir/part-*
while read f
do
   if [ -r $datadir/$f ]
   then
      echo -n .
   else
      echo $f
      curl -s https://cdn.gea.esac.esa.int/Gaia/gdr3/Spectroscopy/rvs_mean_spectrum/$f > $datadir/part-$f && \
      mv $datadir/part-$f $datadir/$f
   fi
done < ecsv-names.txt

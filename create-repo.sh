# Create users MultiGWAS directory for upload to github copying dirs/files from MultiGWAS-dev

OUTDIR=$1
MGDIR=$OUTDIR/MultiGWAS

if [ -d "$MGDIR" ]; then
	mv $MGDIR $OUTDIR/old-MultiGWAS
fi

mkdir $MGDIR

cp INSTALL_Rlibs.R INSTALL.sh README.md UNINSTALL.sh $MGDIR
cp -r sources docs tools  $MGDIR

mkdir $MGDIR/opt/
cp opt/* $MGDIR/opt


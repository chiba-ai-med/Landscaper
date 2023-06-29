# Expect Error
function catch {
  echo Catch
}
trap catch ERR

# Perform landscaper
docker run --rm -v $(pwd):/work ghcr.io/chiba-ai-med/landscaper:main \
-i /work/data/testdata_13.tsv -o /work/output_13 --memgb=10

# Error when no error
if [ $? = 0 ]; then
	echo "No error"
	exit 1
fi

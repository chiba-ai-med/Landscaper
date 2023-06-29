# Perform landscaper
docker run --rm -v $(pwd):/work ghcr.io/chiba-ai-med/landscaper:main \
-i /work/data/testdata.tsv -o /work/output --memgb=10

docker run --rm -v $(pwd):/work ghcr.io/chiba-ai-med/landscaper:main \
-i /work/data/testdata_01.tsv -o /work/output_01 --memgb=10

docker run --rm -v $(pwd):/work ghcr.io/chiba-ai-med/landscaper:main \
-i /work/data/testdata_continuous.tsv -o /work/output_cont --memgb=10

# Test Outputs
docker run --rm -v $(pwd):/work koki/landscaper_component:latest Rscript /work/src/test.R output

docker run --rm -v $(pwd):/work koki/landscaper_component:latest Rscript /work/src/test_01.R output_01

docker run --rm -v $(pwd):/work koki/landscaper_component:latest Rscript /work/src/test_cont.R output_cont

# Expect Error
# function catch {
#   echo Catch
# }
# trap catch ERR

# docker run --rm -v $(pwd):/work ghcr.io/chiba-ai-med/landscaper:main \
# # -i /work/data/testdata_13.tsv -o /work/output_13 --memgb=10
# if [ $? = 0 ]; then
# 	echo "No error"
# 	exit 1
# fi

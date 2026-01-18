# run this from the the top-level directory
# it creates there a notebooks/ and _solved/solutions/ dir
# that get automatically copied to the correct places

if [ "$#" -ne 1 ]; then
    echo "You must enter exactly one command line argument for the course edition"
    exit 1
fi

export COURSE_DIR="DS-python-data-analysis-$1"

echo "Preparing course materials for $COURSE_DIR"
echo ""
echo "-- Creating temporary directory to generate course materials"
mkdir temp_course_setup
pushd temp_course_setup

# cloning repositories to make sure we start with a clean state
echo ""
echo "-- Cloning repositories"
git clone --depth 1 https://github.com/plovercode/DS-python-data-analysis.git $COURSE_DIR
git clone --depth 1 https://github.com/plovercode/course-python-data.git course-python-data-clean

# copying all necessary files to the course directory
echo ""
echo "-- Copying files to $COURSE_DIR"
cp course-python-data-clean/notebooks/*.ipynb $COURSE_DIR/_solved/
cp course-python-data-clean/notebooks/python_intro/*.ipynb $COURSE_DIR/_solved/python_intro/
cp course-python-data-clean/notebooks/data/ $COURSE_DIR/notebooks/ -r
cp course-python-data-clean/img/ $COURSE_DIR/ -r
cp course-python-data-clean/environment.yml $COURSE_DIR/
cp course-python-data-clean/check_environment.py $COURSE_DIR/

# converting notebooks with solutions to student notebooks
echo ""
echo "-- Converting notebooks"
pushd $COURSE_DIR/

declare -a arr=(
   #"00-jupyter_introduction.ipynb"
   #"01-basic.ipynb"
   #"02-control_flow.ipynb"
   #"03-functions.ipynb"
   #"04-reusing_code.ipynb"
   #"05-numpy.ipynb"
   #"python_rehearsal"
   "00-jupyter_introduction.ipynb"
   "pandas_01_data_structures.ipynb"
   "pandas_02_basic_operations.ipynb"
   "pandas_03a_selecting_data.ipynb"
   "pandas_03b_indexing.ipynb"
   "pandas_04_time_series_data.ipynb"
   "pandas_05_groupby_operations.ipynb"
   "pandas_06_data_cleaning.ipynb"
   "pandas_07_missing_values.ipynb"
   "pandas_08_reshaping_data.ipynb"
   "pandas_09_combining_datasets.ipynb"
   "visualization_01_matplotlib.ipynb"
   "visualization_02_seaborn.ipynb"
   "visualization_03_landscape.ipynb"
   "case1_bike_count.ipynb"
   "case2_observations.ipynb"
   "case3_bacterial_resistance_lab_experiment"
   "case4_air_quality_processing.ipynb"
   "case4_air_quality_analysis.ipynb"
   )

cd _solved
mkdir ./notebooks

for i in "${arr[@]}"
do
   echo "---- Converting " "$i"
   jupyter nbconvert --to=notebook --config ../../../nbconvert_config.py --output "notebooks/$i" "$i"
done

echo ""
echo "-- Copying converted notebooks and solutions"
cp -r notebooks/. ../notebooks
cp -r _solutions/. ../notebooks/_solutions

rm -r notebooks/
rm -r _solutions/

cd ..

# clear output from solved notebooks
jupyter nbconvert --clear-output _solved/*.ipynb

popd
popd

echo ""
echo "-- Moving $COURSE_DIR to top-level directory and cleaning up temporary files"
mv ./temp_course_setup/$COURSE_DIR/ ../../$COURSE_DIR
rm -rf temp_course_setup/

echo ""
echo "-- Committing changes"
cd ../../$COURSE_DIR
git checkout -b update-$1
git commit -am "$1 edition - update materials"

echo ""
echo "-- Course materials are ready in:"
echo ""
echo "   cd $(pwd)"
echo ""
echo "   Remember to push the changes to GitHub:"
echo ""
echo "   git push origin HEAD:update-$1"

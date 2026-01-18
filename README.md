# Data manipulation, analysis and visualisation in Python

This repo contains the source code for the workshop (the notebooks with full
content) as it is being developed. For the actual course repo, see for
example [DS-python-data-analysis](https://github.com/plovercode/DS-python-data-analysis)
or [FLAMES-python-data-wrangling](https://github.com/plovercode/FLAMES-python-data-wrangling).

## Introduction

This course is intended for researchers that have at least basic programming skills in Python. It targets researchers that want to enhance their general data manipulation and analysis skills in Python. 

The course does not aim to provide a course in statistics or machine learning. It aims to provide researchers the means to effectively tackle commonly encountered data handling tasks in order to increase the overall efficiency of the research. 

The course has been developed as a specialist course for the Doctoral schools of Ghent University, but can be taught to others upon request (and the material is freely available to re-use).


## Getting started

The course uses Python 3 and some data analysis packages such as Pandas, Numpy and Matplotlib. To install the required libraries, we highly recommend Anaconda or miniconda (<https://www.anaconda.com/download/>) or another Python distribution that includes the scientific libraries (this recommendation applies to all platforms, so for both Window, Linux and Mac).

For detailed instructions to get started on your local machine , see the [setup instructions](./setup.md).

In case you do not want to install everything and just want to try out the course material, use the environment setup by Binder [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/plovercode/DS-python-data-analysis/master) and open de notebooks rightaway.


## Contributing

Found any typo or have a suggestion, see [how to contribute](./CONTRIBUTING.md).


## Development

In addition to the environment.yml, install the following packages:

```
conda install jupytext jlab-enhanced-cell-toolbar nbdime
```

Creating the student version materials from this repo:

```
export COURSE_DIR="DS-python-2021"
git clone --depth 1 https://github.com/jorisvandenbossche/DS-python-data-analysis.git $COURSE_DIR
git clone --depth 1 https://github.com/jorisvandenbossche/course-python-data.git course-python-data-clean
cp course-python-data-clean/notebooks/*.ipynb $COURSE_DIR/_solved/
cp course-python-data-clean/notebooks/data/ $COURSE_DIR/notebooks/ -r
cp course-python-data-clean/img/ $COURSE_DIR/ -r
cp course-python-data-clean/environment.yml $COURSE_DIR/
cp course-python-data-clean/check_environment.py $COURSE_DIR/
cd $COURSE_DIR/
jupyter nbconvert --clear-output _solved/*.ipynb
./convert_notebooks.sh
```




```
export COURSE_DIR="ICES-2022"
git clone --depth 1 https://github.com/jorisvandenbossche/ICES-python-data.git $COURSE_DIR
git clone --depth 1 https://github.com/jorisvandenbossche/course-python-data.git course-python-data-clean
mkdir $COURSE_DIR/_solved/
cp course-python-data-clean/notebooks/*.ipynb $COURSE_DIR/_solved/
cp course-python-data-clean/notebooks/data/ $COURSE_DIR/notebooks/ -r
cp course-python-data-clean/img/ $COURSE_DIR/ -r
#cp course-python-data-clean/environment.yml $COURSE_DIR/
cp course-python-data-clean/check_environment.py $COURSE_DIR/
cd $COURSE_DIR/
jupyter nbconvert --clear-output _solved/*.ipynb
./convert_notebooks.sh
```



	modified:   check_environment.py
	modified:   img/JakeVdP-ecosystem2.svg
	modified:   img/JakeVdP-ecosystem3.svg
	modified:   img/JakeVdP-ecosystem4.svg
	modified:   img/JakeVdP-ecosystem5.svg
	modified:   img/issuetracker.png
	modified:   img/navigator_notebook.png
	modified:   img/startup.png
	modified:   img/work_joris_1.png
	modified:   img/work_stijn_1.png





## Meta 
Authors: Joris Van den Bossche, Stijn Van Hoey

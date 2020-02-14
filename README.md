# Purpose

This repository will be used for team collaboration and consolidation on
analysis/deliverables.

# Team

### Members

- Toni Hanrahan
- Jason Kang
- Thomas Bahng
- Mike Man

### Term

- Winter 2020

# Final Project

All files related to the project reside under `final_project` directory.

### Data

Data sources come from
[Airbnb listings in New York City](https://www.kaggle.com/dgomonov/new-york-city-airbnb-open-data#AB_NYC_2019.csv)
(Kaggle) and [Inside Airbnb](http://insideairbnb.com/get-the-data.html).

- listings.csv.gz (Detailed Listings data for New York City) Date compiled: 04
  December, 2019
- calendar.csv.gz (Detailed Calendar Data for listings in New York City) Date
  compiled: 04 December, 2019
- reviews.csv.gz (Detailed Review Data for listings in New York City) Date
  compiled: 04 December, 2019
- listings.csv (Summary information and metrics for listings in New York City
  (good for visualisations)) Date compiled: 04 December, 2019
- reviews.csv (Summary Review data and Listing ID (to facilitate time based
  analytics and visualisations linked to a listing)) Date compiled: 04 December,
  2019
- neighbourhoods.csv (Neighbourhood list for geo filter. Sourced from city or
  open source GIS files)
- neighbourhoods.geojson (GeoJSON file of neighbourhoods of the city)

# Homework 2

All files related to homework 2 reside under `homework2` directory.

# To Clone/Download This Repo

You need to have Large file storage (lfs) installed on your computer in order
to properly download all data (large files). Large file storage (lfs) allows
checking-in/uploading large files on github so that code (i.e. notebook) and
data can reside in the same repository. The lfs software and installation
instructions can be found on
[Git LFS download page](https://git-lfs.github.com/).

# To Use This Repo

To use this repository, you can simply login to
[colab](https://colab.research.google.com/) and point it to this repository (as
despited in figure below). Once colab gains access to this repository, it will
scan for all notebooks (i.e. *.ipynb files) in this repository. You can click on
the notebook that you want to edit.

![Colab Login](/images/colab_login.png)

If you want to save your edits back to this github repository, you have to click
File --> Save a copy in GitHub (as depited in figure below).

![Colab Save](/images/colab_save.png)

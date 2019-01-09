DSCI 532 Project Proposal
================

Overview
--------

Recent decades have seen violent crime in the U.S. decrease nationwide, but not all jurisdictions have experienced this decrease. In fact, there is considerable heterogeneity in violent crime rates among American cities, and violent crime continues to be major problem for many of them. For this reason, it is useful to look at more granular data about violent crime. To do so, we propose building a visualization app that will allow users to compare the violent crime rates and patterns in violent crime between multiple cities. Our app will allow users to specify a time period, a set of cities, and a type of crime to compare. Users will be able to see the long term trends in crime rates for the cities they specify, as well as look at the composition of violent crime for a specific year across those cities.

Data Description
----------------

Our dataset comes from the Marhsall Project, which compiled crime data for major American cities from the FBI's Uniform Crime Reporting (UCR) Program. The dataset covers the period from 1975 - 2015, and contains information on sixty-eight cities, as well as national averages. For this project, we will be looking only at crime rates that are normalized by population (i.e. crime per 100,000 people). For each city, we have five annual crime rates: total violent crime rate and crime rates for four specific types of violent crime (assault, homicide, rape, and robbery).

Usage Scenario and Tasks
------------------------

### example 1

A crime analyst uses our app to compare the total violent crime rates accross three cities in Ohio: Cincinnati, Cleveland, and Columbus. Suppose she notices that there were notable decreases in violent crime in Cincinnati throughout the 1990s, while crime rates in Cleveland and Columbus increased over the same period. This could lead her to look at the different policies implemented by those cities to see which policies appear to lead to reductions in violent crime and which do not.

### example 2

Suppose a "hot-spot policing" policy was implemented in Chicago during the 1990s, while it was not implemented in any other Midwestern cities. A crime analyst decides to use our app to compare the violent crime rates of Chicago, Minneapolis, Milwaukee, and St. Louis between 1990 and 2005. She notices that Chicago's crime rates dramatically decreased over this period, while the crime rates in other cities increased. This could lead her to do more research into "hot-spot policing" to see if the policy should be implemented in other cities to help reduce violent crime.

Description of App and Sketch
-----------------------------

Our app's landing page will have two panels. The first panel will have time series plots that can be used to look at trends in crime rates for up to four cities. Users will be able to select the cities and type of crime (aggravated assault, homicide, rape, robbery, and total violent crime) they want to visualize using a dropdown menu, and the range of dates using a slider.

The second panel will be a bar plot for comparing the proportions of different types of crime committed in a specific year among the cities selected. The height of each bar will represent the total violent crime rate for a particular city and a particular year. Each bar will be coloured according to the proportion of each type of crime committed. The cities represented here will be the same as the cities selected for the time series plots. Users will be able to select which year they want to view from a dropdown menu. The choice of year will be limited to the range specified for panel one. Similarly, the choice of cities will be limited to those selected for the first panel.

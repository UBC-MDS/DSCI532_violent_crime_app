Milestone 2 Writeup
================

Rationale
---------

We wanted users of our app to see differences in crime rates and crime patterns accross cities. To give users a general sense of the long-run trends accross cities, we used a line plot to show trends over time. To make the line plot more engaging, we included the actual data points on top of the lines and implemented a hover effect using plotly. Users can easily see the actual crime rates for a specific year and city by hovering over a data point. As a result, users get both a general sense of the patterns from the lines and precise information from the hover effect.

We also included a bar chart to allow users to look at specific years in more detail, giving them a different perspective. Users can get a sense of how the composition of violent crime for a specific year differs accross cities. Like the line plot, we also implmented a hover effect to provide more detail and make the plot more interactive.

Tasks
-----

-   Data wrangling
    -   Wrote a script to clean and reshape data to be used in the app
-   Built main panel of Plot tab
    -   Created a line plot and bar plot using ggplot
    -   Added interactivity using plotly
        -   Feedback from peers will help us confirm which designs are most effective
-   Built side panel of Plot tab
    -   Created side panel for user inputs
    -   Used drop-down menus, sliders, and radio buttons to get user inputs and then update data, plots, and tables
-   Built a data tab
    -   Added a tab to display the data that updates as the user changes the inputs

Next Steps
----------

Our goal for the next milestone is to refine some of the interactive elements of our app. In particular, for the user inputs, we would like have the chocie of years for the bar plot limited to the same range of years used in the line plot. Also, it would nice to have linked filtering, where if a user clicks a point on the line plot, it automatically filters the bar plot to that year. Adding linked filtering could be tehcnically challenging, but we may implement this feature if time permits.

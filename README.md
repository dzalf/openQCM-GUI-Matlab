# openQCM-GUI-Matlab

This is my contribution to the [openQCM](https://openqcm.com/openqcm) project for which I developed a visual interfase for data acquisition and visualization. It is a Matlab code based on the stock application written in Java by the one and only  [Marco Mauro](https://www.researchgate.net/profile/Marco_Mauro) :raised_hands:

**USAGE** 

In order to use this code for data acquisition you will need Matlab 2017a or superior. Then, open the file *OpenDaqQCM.fig* using GUIDE from Matlab. 

Run:
    > GUIDE
    
from the Matlab console

Another route is to run the script *OpenDAQCM.m* that will open the GUI interfase


**FEATURES**

1. The code can handle 6 MHz and 10 MHz crystals, where the latter are the most common ones. You can get crystals from either the openQCM [shop](https://store.openqcm.com/) or from [QuartzPro](http://www.quartzpro.com/category.html/qcm-sensors-2)

2. Baseline calibration for a desired time is possible. This allows to obtain frequency shifts in terms of DeltaF for the sake of readability. This routine computes the Student's T-distribution with a 95% of confidence to extract the best baseline possible. During this stage the crystal should be under continuous and stable liquid flow.

3. A big data matrix is saved once the data aquisition finishes and the user can select whether to save data as a txt file or xlsx file. Both files contain appropriate headers. 
    
    3.1 If the baseline calibration routine is selected also a column with raw data values is generated

4. Temperature is appended once the real capture begins.

5. The front panel shows relevant statistical data of the current capture.

**UPDATE:** Currently working on a MASSIVE upgrade

At this point, the GUI looks like :eyes:

![alt txt](https://github.com/dzalf/openQCM-GUI-Matlab/blob/master/gui.png)


**#TODO**

1. Implement error control routines --> e.g. upon USB disconnection, when a data point is a NaN (which NEVER happens but anyway), etc

2. Correct the visualization problems when switching from continuous to accumulative data display.

3. Cleanup the visual interface 

dzalf :smiley:



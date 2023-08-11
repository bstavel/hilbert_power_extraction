# hilbert_power_extraction

extracts power from preprocessed iEEG electrode time series data across the frequency spectrum. optimized for cluster jobs


### Meeting Log with Ludo: July 2 2020

*Questions*

* Subbands: how do you set them across all frequencies when doing the hilbert extraction
  - 5hz subbands at first -> increase in performance, but turned out to be artifical due to temporal info that can be pulled
  - 20hz subbands can give you 10Hz information
  - Julie did 10Hz for HFA
  - Eddie Chang logarthimically increasing with pseuodlog bandwidth 
  - Eddie Chang does PCA over all the bands, say 8 bands in the HFA, and take the 1 pc.
  - above 30hz use multi-taper 
  - caution using connectivity or something with different with methods to calculate the band
  - Ludo uses a 5Hz step
* What is `cfg.bpfiltord` and why is it uncommented in your script? 
  - order of the filter, experessed as a decibal / octave . Some higher orders do not work. 
  - having steeper cut off frequencies results iin more distortion
  - see code at the bottom
* Why do you use robustScaler?
  - less susepctible to outliers
* Can I shrink the data down to our TOI before using robustScaler?
  - no
* Do you do an additional zscore step by trial after robustScaler?
  - no
  - julia as an example for bootstrapping to get the z score: ref here: 
  
  *Flinker, A. et al. Redefining the role of Broca’s area in speech. Proc. Natl Acad. Sci. USA 112, 2871–2875 (2015).*
  - see text below 
* How do you reduce the time resolution of the hilber transform? At what step do you change it?
  - see third code chunk below
  - after standardizing
  - resample takes into account the information around it
* Suggestions for parrallelization?
  - use both subbands and subjects

```
1_4 - 3_3_3_1_1
4_8 - 4_4_4_1_1
8_13 - 5_5_4_1_1
13_30 - 17_17_4_1_1
30_70 - 20_5_4_1_1
70_150 - 20_5_4_1_1
sbParams!

two first are frequency band boundaries
then the 5 params are bandwidth, step, filter order, bounded flag, Z scoring flag

```

```
The log transform of the γHigh power time
series was smoothed using a Hanning window (100 samples) and changed to
units of z-score compared with a pooled baseline (−250 ms → 0 ms) distribution of all trials within that block

```

```
cfg = [];
cfg.resamplefs = fsOut;
data = ft_resampledata(cfg, data);

```

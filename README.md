# hilbert_power_extraction

extracts power from preprocessed iEEG electrode time series data across the frequency spectrum. optimized for cluster jobs


### Meeting Log with Ludo: July 2 2020

*Questions*

* Subbands: how do you set them across all frequencies when doing the hilbert extraction
* What is `cfg.bpfiltord` and why is it uncommented in your script? 
* How do you handle trials with bad data? Currently have the flags, but that seems like a hack?
* Why do you use robustScaler?
* Can I shrink the data down to our TOI before using robustScaler?
* Do you do an additional zscore step by trial after robustScaler?
* How do you reduce the time resolution of the hilber transform? At what step do you change it?
* Suggestions for parrallelization?

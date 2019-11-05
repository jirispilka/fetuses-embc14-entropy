# Nearest-neighbor based wavelet entropy rate measures for intrapartum fetal heart rate variability (EMBC 2014)

The paper aims to illustrate that a k-nearest neighbor procedure yields estimates for entropy rates that are robust and well-suited to FHR variability (compared to the more commonly used correlation-integral algorithm). Second, it investigates how entropy rates measured on multiresolution wavelet and approximation coefficients permit to improve classification performance.

> J. Spilka, S.G. Roux, N.B. Garnier, P. Abry, P. Goncalves, and M. Doret 
> Nearest-neighbor based wavelet entropy rate measures for intrapartum fetal heart rate variability
> In Engineering in Medicine and Biology Society (EMBC), 2014 36th Annual International Conference of the IEEE, 2813–2816, IEEE, 2014.

[EMBC 2014, IEEE](https://ieeexplore.ieee.org/document/6944208)

## Dependencies

**Data:**

The fetal heart rate database created at ENS Lyon, 2014

**Toolbox:** 

Carlos Granero-Belinchon, Stéphane G. Roux, Patrice Abry, Muriel Doret, Nicolas B. Garnier:
Information Theory to Probe Intrapartum Fetal Heart Rate Dynamics. Entropy 19(12): 640 (2017)

Matlab files:

* entropy_RR_140310.mat
* entropy_RR_vary_r_knn_140310.mat
* entropy_RR_wavecoeff_140218.mat
* entropy_synthetic_140309.mat
* entropy_synthetic_vary_r_knn_140310.mat
* entropy_synthetic_wavecoeff_140310.mat

### Citation
If you use this code for your research, please cite our paper:

```
@InProceedings{spilka2014nearest,
  Title        = {Nearest-neighbor based wavelet entropy rate measures for intrapartum fetal heart rate variability},
  Author       = {Spilka, J and Roux, SG and Garnier, NB and Abry, P and Goncalves, P and Doret, M},
  Booktitle    = {Engineering in Medicine and Biology Society (EMBC), 2014 36th Annual International Conference of the IEEE},
  Year         = {2014},
  Organization = {IEEE},
  Pages        = {2813--2816}}
```

# Medical Image Analysis and Processing
In this repo the homeworks and project of the course "medical image analysis & processing", instructed by Dr. Emad Fatemi Zadeh, are added.
Here is a brief discription for each forlder:

## [HW01](./HW01/)
Introduuction to image analizing (histogram equalization, noise adding and removing, image lightening level).


## [HW02](./HW02/)
Introduuction to image analizing (fiters).


## [HW03](./HW03/)
Implimentation of non-local mean (NLM), bilateral and total variation (TV) filter and  edge preserving index calculation.

## [HW04](./HW03/)
 Applying and comparion of different segmentation algorithms like K-means, fuzzy c-means (FCM), adaptive regularized kernel-based FCM (ARKFCM), Gaussian mixture model (GMM), basic snake and gradient vector flow (GVF) on the MRI image of a patient suffering from a tumor.

 ## [Project](./Project/)
 Registration of segmented CT scan of spines (L1 to L5) of different patients to an atlas CT scan (a healthy spine). Non-rigid coherent point drift (CPD) registration algorithm is applied to the point clouds. Finally, the result are compared using Dice, average surface distance (ASD), Hausdorff and Jacobian determinant criteria.


 # Explanation
All folders contain an english report in .pdf format and a main matlab code named "HWxx.mat" or "fullproject.mat" to run. The rest .mat files are the written and used funtions.
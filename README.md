# Graph Moving Object Segmentation
Authors: [Jhony H Giraldo](https://sites.google.com/view/jhonygiraldo), [Sajid Javed](https://sites.google.com/view/sajidjaved/home), [Thierry Bouwmans](https://sites.google.com/site/thierrybouwmans/)
- - - -
![Pipeline](https://github.com/jhonygiraldo/GraphMOS/blob/master/doc/pipeline_vs_03.png)
- - - -
**Abstract**: Moving Object Segmentation (MOS) is a fundamental task in computer vision. Due to undesirable variations in the background scene, MOS becomes very challenging for static and moving camera sequences. Several deep learning methods have been proposed for MOS with impressive performance. However, these methods show performance degradation in the presence of unseen videos; and usually, deep learning models require large amounts of data to avoid overfitting. Recently, graph learning has attracted significant attention in many computer vision applications since they provide tools to exploit the geometrical structure of data. In this work, concepts of graph signal processing are introduced for MOS. First, we propose a new algorithm that is composed of segmentation, background initialization, graph construction, unseen sampling, and a semi-supervised learning method inspired by the theory of recovery of graph signals. Secondly, theoretical developments are introduced, showing one bound for the sample complexity in semi-supervised learning, and two bounds for the condition number of the Sobolev norm. Our algorithm has the advantage of requiring less labeled data than deep learning methods while having competitive results on both static and moving camera videos. Our algorithm is also adapted for Video Object Segmentation (VOS) tasks and is evaluated on six publicly available datasets outperforming several state-of-the-art methods in challenging conditions.
- - - -
## Getting started

This repository is the code released for our paper Graph Moving Object Segmentation. [Journal Paper](https://doi.org/10.1109/tpami.2020.3042093), [Preprint](https://drive.google.com/file/d/1Pk7y6tp5fO2qUTISJyHlqVD67NxXrU3h/view).

#### Installation

Clone this repository
```bash
git clone https://github.com/jhonygiraldo/GraphMOS  
```
Inside the repository, initialize and clone the submodules
```bash
git submodule init
git submodule update
```
Install all toolboxes, i.e., gspboox, unlocbox, and detectron2.
- - - -
## Citation

If you use our code, please cite

        @article{giraldo2020graph,
          title={Graph Moving Object Segmentation},
          author={Giraldo, Jhony H and Javed, Sajid and Bouwmans, Thierry},
          journal={IEEE Transactions on Pattern Analysis and Machine Intelligence},
          year={2020}
        }
        
        @inproceedings{giraldo2020graphbgs,
          title={{GraphBGS}: Background Subtraction via Recovery of Graph Signals},
          author={Giraldo, Jhony H and Bouwmans, Thierry},
          journal={International Conference on Pattern Recognition (ICPR)},
          year={2020}
        }
        
        @inproceedings{giraldo2020semi,
          title={Semi-Supervised Background Subtraction Of Unseen Videos: Minimization Of The Total Variation Of Graph Signals},
          author={Giraldo, Jhony H and Bouwmans, Thierry},
          booktitle={IEEE International Conference on Image Processing (ICIP)},
          year={2020}
        }
- - - -
## References

- This repository builds upon, thus borrows code from [gspbox](https://github.com/epfl-lts2/gspbox), [unlocbox](https://github.com/epfl-lts2/unlocbox) and [detectron2](https://github.com/facebookresearch/detectron2).
- [Please see the conference version of our code here for additional datasets.](https://github.com/jhonygiraldo/GraphBGS)

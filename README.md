# Graph Moving Object Segmentation
By [Jhony H Giraldo](https://sites.google.com/view/jhonygiraldo), [Sajid Javed](https://sites.google.com/view/sajidjaved/home), [Thierry Bouwmans](https://sites.google.com/site/thierrybouwmans/)

![Pipeline](https://github.com/jhonygiraldo/GraphMOS/blob/master/doc/pipeline_vs_03.png)

**Abstract**: Moving Object Segmentation (MOS) is a fundamental task in computer vision. Due to undesirable variations in the background scene, MOS becomes very challenging for static and moving camera sequences. Several deep learning methods have been proposed for MOS with impressive performance. However, these methods show performance degradation in the presence of unseen videos; and usually, deep learning models require large amounts of data to avoid overfitting. Recently, graph learning has attracted significant attention in many computer vision applications since they provide tools to exploit the geometrical structure of data. In this work, concepts of graph signal processing are introduced for MOS. First, we propose a new algorithm that is composed of segmentation, background initialization, graph construction, unseen sampling, and a semi-supervised learning method inspired by the theory of recovery of graph signals. Secondly, theoretical developments are introduced, showing one bound for the sample complexity in semi-supervised learning, and two bounds for the condition number of the Sobolev norm. Our algorithm has the advantage of requiring less labeled data than deep learning methods while having competitive results on both static and moving camera videos. Our algorithm is also adapted for Video Object Segmentation (VOS) tasks and is evaluated on six publicly available datasets outperforming several state-of-the-art methods in challenging conditions.

## Introduction

This repository is code release for our paper Graph Moving Object Segmentation.

## Citation

If you use our code, please cite

        @article{giraldo2020graph,
          title={Graph Moving Object Segmentation},
          author={Giraldo, Jhony H and Javed, Sajid and Bouwmans, Thierry},
          journal={IEEE Transactions on Pattern Analysis and Machine Intelligence},
          year={2020}
        }
        
## References

- This repository builds upon, thus borrows code from [gspbox](https://github.com/epfl-lts2/gspbox), [unlocbox](https://github.com/epfl-lts2/unlocbox) and [ECO](https://github.com/martin-danelljan/ECO).

import torch, torchvision
import detectron2
from detectron2.utils.logger import setup_logger
setup_logger()

import numpy as np
import cv2

from detectron2.engine import DefaultPredictor
from detectron2.config import get_cfg

import os
import scipy.io as sio

cfg = get_cfg()
cfg.merge_from_file("/home/jgiral01/instance_segmentation_resnest/detectron2_repo/configs/COCO-InstanceSegmentation/mask_cascade_rcnn_ResNeSt_200_FPN_dcn_syncBN_all_tricks_3x.yaml")
cfg.MODEL.ROI_HEADS.SCORE_THRESH_TEST = 0.5  # set threshold for this model
# Find a model from detectron2's model zoo. You can either use the https://dl.fbaipublicfiles.... url, or use the following shorthand
cfg.MODEL.WEIGHTS = "https://hangzh.s3.amazonaws.com/detectron/mask_cascade_rcnn_ResNeSt_200_FPN_dcn_syncBN_all_tricks_3x-e1901134.pth"
predictor = DefaultPredictor(cfg)

challenge_folder_path = "/home/jgiral01/instance_segmentation/intermittentObjectMotion/"
instances_path = "/home/jgiral01/instance_segmentation_resnest/results_instances_intermittentObjectMotion/"
os.mkdir(instances_path)
for root, dirs, files in os.walk(challenge_folder_path, topdown=False):
  for name_img in files:
    path_file = os.path.join(root,name_img)
    im = cv2.imread(path_file)
    outputs = predictor(im)
    print("Computing instances "+path_file)
    path_file = path_file.replace("/","_")
    path_file = path_file.replace(".jpg",".mat")
    sio.savemat(instances_path+path_file, {'masks':outputs["instances"].pred_masks.cpu().numpy(),'classes':outputs["instances"].pred_classes.cpu().numpy(),'boundig_boxes':outputs["instances"].pred_boxes.to("cpu").tensor.numpy()})

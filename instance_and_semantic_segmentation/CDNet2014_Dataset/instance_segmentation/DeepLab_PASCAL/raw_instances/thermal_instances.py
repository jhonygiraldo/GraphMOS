import torch
from torchvision import transforms
from PIL import Image

import numpy as np

import os
import scipy.io as sio

model = torch.hub.load('pytorch/vision:v0.6.0', 'deeplabv3_resnet101', pretrained=True)
model.eval()

challenge_folder_path = "/home/jgiral01/instance_segmentation/thermal/"
instances_path = "/home/jgiral01/semantic_segmentation_deepLab/results_instances_thermal/"
os.mkdir(instances_path)
for root, dirs, files in os.walk(challenge_folder_path, topdown=False):
	for name_img in files:
		path_file = os.path.join(root,name_img)
		input_image = Image.open(path_file)
		preprocess = transforms.Compose([
			transforms.ToTensor(),
			transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
		])
		input_tensor = preprocess(input_image)
		input_batch = input_tensor.unsqueeze(0) # create a mini-batch as expected by the model
		# move the input and model to GPU for speed if available
		if torch.cuda.is_available():
			input_batch = input_batch.to('cuda')
			model.to('cuda')
		with torch.no_grad():
			output = model(input_batch)['out'][0]
		output_predictions = output.argmax(0)
		outputs = output_predictions.byte().cpu().numpy()
		print("Computing instances "+path_file)
		path_file = path_file.replace("/","_")
		path_file = path_file.replace(".jpg",".mat")
		sio.savemat(instances_path+path_file,{'output_seg_image': outputs})

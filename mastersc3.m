function mastersc3 (imgfile, outputfilename,num)

DataPath=imgfile;
%mask=matrixofchanges(DataPath,50,1)
[mask, masked_fluorescence_image_matrix , number_of_pixels_in_mask] = makeResponderCellMask(DataPath);
uint16_binary_mask_of_responding_cell = mask; %To save
stim=stimFrame(DataPath);
first_responding_frame_number = stim; %To save

img=imread(DataPath,stim); %stimulationg frame is saved in img
figure;
colormap(gray);
imagesc(img); %img is displayed in a new figure in grayscale
title('Please select a region of background:');
h=imfreehand(gca); %background ROI is assigned to h
binarybgimg=h.createMask(); %mask is created 

[ind,avgintbgsub,avgint,numimages]=epochs(imgfile,mask,binarybgimg,num)
[sia,arr]=clusterdxl(ind,num);
protocol=arr;

[f,sbF,int,delf,delfof,rsq,SNR]=edgestxt2(DataPath,num,protocol,avgintbgsub,avgint,numimages);

rsquared_value=rsq;
signoise=SNR;

Average_intensity_of_responses_F = f; %To save
average_baseline_intensity = sbF; %To save
timesteps_of_response = int; %To save
DeltaF=delf;%save
DeltaF_over_F=delfof;%save

%%%%%%%%%%%%%%%%%%%%SAVING VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%%%
save(outputfilename , 'uint16_binary_mask_of_responding_cell');
save(outputfilename , 'masked_fluorescence_image_matrix' , '-append');
save(outputfilename , 'number_of_pixels_in_mask' , '-append');
save(outputfilename , 'first_responding_frame_number' , '-append');
save(outputfilename , 'Average_intensity_of_responses_F' , '-append');
save(outputfilename , 'average_baseline_intensity' , '-append');
save(outputfilename , 'timesteps_of_response' , '-append');
save(outputfilename , 'DeltaF' , '-append');
save(outputfilename , 'DeltaF_over_F' , '-append');
save(outputfilename , 'binarybgimg' , '-append');
save(outputfilename , 'rsquared_value' , '-append');
save(outputfilename , 'signoise' , '-append');

end
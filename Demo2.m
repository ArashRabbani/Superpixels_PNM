% Demo 2
clear; close all; 
% Setting spatial resolution which simply says how large is one pixel in 
% the image
Res=5; %micron/pixel

% Reading data from image sequence
% unzipping the folder
unzip('Image Seq.zip');
% reading the image sequence
A=spnm.seq2mat('Image Seq/*.png');
% binarizing the image
A=imbinarize(A); 

% And then doing the rest of your analysis such as 
% Extracting the pore network via superpixels method
[NW,NM]=spnm.netext2(A,Res,'super');

% Printing results
disp(['Porosity: ' num2str(NW.Poro) ])
disp(['Average pore size: ' num2str(mean(NW.R)) ' Micron'])



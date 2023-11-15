# Superpixels_PNM
Superpixels pore network extraction for geological tomography images

## Demo 1
```matlab
% Demo 1
clear; close all; 
% Setting spatial resolution which simply says how large is one pixel in 
% the image
Res=5; %micron/pixel

% Making a random gaussain geometry to play with, 0 is void sapce and 1 is 
% solid space
A=imgaussfilt3(rand([100,100,100]),2); A=A>quantile(A,.22);

% Extracting the pore network via superpixels method
[NW,NM]=spnm.netext2(A,Res,'super');

% Correcting the effective area in the transmiscibility term to compensate 
% for possible over-segmentation
[NW]=spnm.ThroatAreaCorrection(NW,Res);

% Calculating the directional absolute permeability and formation factors
NW=spnm.absperm(NW);
NW=spnm.formfact(NW); 

% Exporting the network and its information in text, csv and vtk formats
spnm.net2txt(NW,2,1,'Network');
spnm.net2csv(NW,'Network');
spnm.net2vtk(NW,'Network',...
    NW.Pres(1).Pore,'Pore_Pressure_Pa_X',...
    NW.Pres(2).Pore,'Pore_Pressure_Pa_Y',...
    NW.Pres(3).Pore,'Pore_Pressure_Pa_Z',...
    NW.Flow(1).Throat,'Flow_rate_mic3/s',...
    NW.Flow(2).Throat,'Flow_rate_mic3/s',...
    NW.Flow(3).Throat,'Flow_rate_mic3/s');

% Printing results
disp(['Porosity: ' num2str(NW.Poro) ])
disp(['Average pore size: ' num2str(mean(NW.R)) ' Micron'])
disp(['Average absolute permeability: ' num2str(mean(NW.perm)) ' Darcy'])
disp(['Average formation factor: ' num2str(mean(NW.formfact))])

spnm.section(A); title('Original geometry'); saveas(gcf, 'Original geometry.png');
if numel(NW.R)<4000
spnm.netview(NW,'Pore size'); title('Pore Network structure'); saveas(gcf, 'Pore Network structure.png');
spnm.netview(NW,'Pore pressure',0,NW.Pres(1).Pore); title('Pore pressure'); saveas(gcf, 'Pore pressure.png');
end
```
And as a result the code will visulize and save cross-section of the 1) original geometry, 2) pore network structure color labeled for different pore sizes and 3) Pore pressure distribution in steady state incompressible flow in X direction. 
![Original geometry](https://github.com/ArashRabbani/Superpixels_PNM/blob/main/Original%20geometry.png)

![Pore Network structure](https://github.com/ArashRabbani/Superpixels_PNM/blob/main/Pore%20Network%20structure.png)

![Pore pressure](https://github.com/ArashRabbani/Superpixels_PNM/blob/main/Pore%20pressure.png)

## Demo 2
This demo shows how to use a sequence of images as input to form the 3D structure as a matlab binary variable and run the pore network extraction. 

```matlab
% Demo 2
clear; close all; 
% Setting spatial resolution which simply says how large is one pixel in 
% the image
Res=5; %micron/pixel

% Reading data from image sequence
% unzipping the folder
try; unzip('Image Seq.zip'); catch; end
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
```
Note: An example image sequence is provided that is being unzipped in the code. If you have yours ready, just remove the 'unzip' line. 

## Demo 3
In this code, 
```matlab
% Demo 3
clear; close all; 
% Setting spatial resolution which simply says how large is one pixel in 
% the image
Res=5; %micron/pixel
% assuming a list of porosity 
PoroList=[0.1,0.15,0.2,0.25,0.3,0.4];
% initializing some arrays
Permeability=[];FormationFactor=[];
for Poro=PoroList

% Making a random gaussain geometry with specific porosity
A=imgaussfilt3(rand([100,100,100]),2); A=A>quantile(A,Poro);

% Extracting the pore network via superpixels method
[NW,NM]=spnm.netext2(A,Res,'super');

% Correcting the effective area in the transmiscibility term to compensate 
% for possible over-segmentation
[NW]=spnm.ThroatAreaCorrection(NW,Res);

% Calculating the directional absolute permeability and formation factors
NW=spnm.absperm(NW);
NW=spnm.formfact(NW); 

Permeability(end+1)=mean(NW.perm);
FormationFactor(end+1)=mean(NW.formfact);
end
% plotting 
figure; subplot(1,2,1); plot(PoroList,Permeability,'o-'); xlabel('Porosity'); ylabel('Permeability (D)'); axis square; 
subplot(1,2,2); plot(PoroList,FormationFactor,'o-'); xlabel('Porosity'); ylabel('Formation factor'); axis square; 
saveas(gcf, 'Sensitivity analysis.png');
```

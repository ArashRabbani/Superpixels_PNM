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





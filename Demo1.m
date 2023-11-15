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





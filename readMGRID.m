function mgridData=readMGRID(filename)
% reads BioImage MGRID file

% Tal Golan @ Malach Lab, 2017
mgridData=struct;

headerRG='#vtkpxElectrodeMultiGridSource\s+([^#]*)\s+#Description\s+([^#]*)\s+\#Comment\s+([^#]*)\s+#Number of Grids\s+([^#]*)';

fid=fopen('gridRG.txt','rt');
gridRG=char(fread(fid,'uint8'))'; %#ok<*FREAD>
fclose(fid);

fid=fopen('elecRG.txt','rt');
elecRG=char(fread(fid,'uint8'))';
fclose(fid);

fid=fopen(filename,'rt');
txt=char(fread(fid,'uint8'))';
fclose(fid);

tokens=regexp(txt,headerRG,'tokens');
mgridData.headerTable=cell2table(cat(1,tokens{:}),'VariableNames',{'vtkpxElectrodeMultiGridSource','Description','Comment','Number_of_Grids'});

tokens=regexp(txt,gridRG,'tokens');
mgridData.gridTable=cell2table(cat(1,tokens{:}),'VariableNames',{'Electrode_Grid','vtkpxElectrodeGridSource','Description','Dimensions','Electrode_Spacing','Electrode_Type','Radius','Thickeness','Color'});
gridStarts=regexp(txt,gridRG,'start');

tokens=regexp(txt,elecRG,'tokens');
mgridData.elecTable=cell2table(cat(1,tokens{:}),'VariableNames',{'Electrode_i','Electrode_j','vtkpxElectrodeSource2','Position','Normal','Motor_Function','Sensory_Function','Visual_Function','Language_Function','Auditory_Function','User1_Function','User2_Function','Seizure_Onset','Spikes_Present','Electrode_Present','Electrode_Type','Radius','Thickeness','Values'});
elecStarts=regexp(txt,elecRG,'start');
t=table;
t.elecGrid=nan(numel(elecStarts),1);
for iElec=1:numel(elecStarts)
    t.elecGrid(iElec)=find(gridStarts<elecStarts(iElec),1,'last')-1;
end

mgridData.elecTable=cat(2,t,mgridData.elecTable);
mgridData.elecTable.Electrode_i=str2double(mgridData.elecTable.Electrode_i);
mgridData.elecTable.Electrode_j=str2double(mgridData.elecTable.Electrode_j);

mgridData=convertEOLFromWinToUnixFormat(mgridData);
end

function writeMGRID(filename,mgridData)
% writes BioImage MGRID file from struct mgridData produced by readMGRID.m

% Tal Golan @ Malach Lab, 2017

mgridData=convertEOLFromWinToUnixFormat(mgridData);

fid=fopen(filename,'wb'); % using binary mode enables unix end-of-line
fieldWriter(fid,mgridData.headerTable);
% grid loop
nGrids=str2double(mgridData.headerTable.Number_of_Grids);
for iGrid=1:nGrids
    fprintf(fid,'#- - - - - - - - - - - - - - - - - - -\n# Electrode Grid %d\n- - - - - - - - - - - - - - - - - - -\n',iGrid-1);
    fieldWriter(fid,mgridData.gridTable(iGrid,:));
    curGridElectrodeTable=mgridData.elecTable(mgridData.elecTable.elecGrid==iGrid-1,:);
    
    % ensure order fits BioImage convention
    curGridElectrodeTable=sortrows(curGridElectrodeTable,{'Electrode_j','Electrode_i'});
    
    % electrode loop
    for iElectrode=1:height(curGridElectrodeTable)        
        fprintf(fid,'#- - - - - - - - - - - - - - - - - - -\n# Electrode %d %d\n- - - - - - - - - - - - - - - - - - -\n',curGridElectrodeTable.Electrode_i(iElectrode),curGridElectrodeTable.Electrode_j(iElectrode));
        fieldWriter(fid,curGridElectrodeTable(iElectrode,:));        
    end
end

fclose(fid);

end

function fieldWriter(fid,tableRow)
    varNames=tableRow.Properties.VariableNames;
    % remove special variables
    varNames=varNames(~ismember(varNames,{'elecGrid','Electrode_Grid','Electrode_i','Electrode_j'}));
    
    varNamesWithSpaces=strrep(varNames,'_',' ');
    for iVar=1:numel(varNames)
        if strncmp(varNames{iVar},'vtkpx',5)
            delimiter=' ';
        else
            delimiter=sprintf('\n');
        end
        fprintf(fid,'%s%s%s\n',['#' varNamesWithSpaces{iVar}],delimiter,strtrim(tableRow.(varNames{iVar}){1}));
    end
end

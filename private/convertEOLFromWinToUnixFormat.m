function s=convertEOLFromWinToUnixFormat(s)
% convert all strings to unix format EOL
if istable(s)
    s=varfun(@convertEOLFromWinToUnixFormat,s);    
    s.Properties.VariableNames=strrep(s.Properties.VariableNames,'convertEOLFromWinToUnixFormat_','');
elseif isstruct(s) 
    s=structfun(@convertEOLFromWinToUnixFormat,s,'UniformOutput',false);
    return
elseif iscell(s)
    s=cellfun(@convertEOLFromWinToUnixFormat,s,'UniformOutput',false);
elseif ischar(s)
    s=strrep(s,sprintf('\r\n'),sprintf('\n'));
    s(s==13)=[]; % remove isolated CR characters    
end

end

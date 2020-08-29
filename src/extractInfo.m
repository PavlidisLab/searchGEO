function y = extractInfo(experiment,strToLookfor, joinstring)
strToLookfor = string(strToLookfor);
y = experiment{1,2}(contains(experiment{1,1},strToLookfor,'IgnoreCase',true),:);
if joinstring == 1 y = strjoin(y);, end 
end

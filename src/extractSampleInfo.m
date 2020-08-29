function y = extractSampleInfo(samV,varargin)

% gets particular fields from sampleVector object from all samples in that object

varargin = string(varargin)'; %now lookfor matrix is column rather than row
[a,b] = size(varargin);
for i = 1:size(samV,1)
y(i,1:a) = helperExtract(samV{i,1},samV{i,2},varargin);
end
end

function y = helperExtract(string1,string2, lookforStrings)
t ="";
for i = 1:size(lookforStrings,1)
t(1,i) = string(strjoin(string2( contains(string1, lookforStrings(i,1) ,'IgnoreCase', true),1), " "));
end
y = t;
end

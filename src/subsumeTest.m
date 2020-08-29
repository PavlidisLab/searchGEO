function [y ,rnowToDisp] = subsumeTest(varargin)
% checks 'BRAIN_PARTS.mat' or whatever file name (mat file ) you pass it for subsumtion
% for variables BRAIN_PARTS, ACC_PARTS, GoodBrainParts, OtherParts
% or you can supply 4 variables from an active ws

if length(varargin) == 1
load(varargin{1,1})
elseif length(varargin) == 4
y = helper(varargin{1,1} , varargin{1,2} , varargin{1,3} , varargin{1,4});
if size(y,1) > 10 rnowToDisp = 10; else rnowToDisp = size(y,1); end
writeStringArrayToCsv(y , 'subsumeTestResult.csv')
return
else load('BRAIN_PARTS.mat')
end
y = helper( BRAIN_PARTS, ACC_PARTS, GoodBrainParts, OtherParts);
if size(y,1) > 10 rnowToDisp = 10; else rnowToDisp = size(y,1); end
writeStringArrayToCsv(y, 'subsumeTestResult.csv')
end % function


function y = helper(v1,v2,v3,v4)
gL = [v1;v2;v3;v4];


if isempty(char(gL)) y = []; return ;end
szgL = size(gL);
if szgL(1,2) > 1 y = ["Error checking subsumption test", "make sure your input search lists only have 1 column and separate terms should appear on a new line"]; return, end
gL = gL(gL ~= "");
temp = {[]};
for i = 1:length(gL)
temp{i,1} = gL(i,1);
temp{i,2} = gL(contains(gL , gL(i,1) , 'IgnoreCase', true));
end % for 
for i = 1:size(temp,1)
temp{i,2} = strjoin(temp{i,2}( lower(temp{i,2}) ~= lower(temp{i,1})) , '|');
%temp{i,3} = strjoin(temp{i,2}( lower(temp{i,2}) == lower(temp{i,1})) , '|');
end % for
temp = string(temp);
y = temp(temp(:,2) ~= "",:);
end % helperFunction 

function status = setAnyVars(varargin)
%GENERALSETVARS adds variable name and type to "BRAIN_PARTS.mat" file 
status = 0;
try load("BRAIN_PARTS.mat")
catch ME 
    warning("BRAIN_PARTS.mat not found in working directory, will create a new mat file named BRAIN_PARTS.mat")
end
i = 1;
varargin = varargin';
while i <= size(varargin,1)
    helper(char(varargin{i,1}), varargin{i+1,1});
    i = i + 2;
end
clear i ME status varargin
save BRAIN_PARTS
status = 1;
end

function helper(name, value)
assignin('caller',name, value)
end




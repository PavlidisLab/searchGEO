function is = myIsStringArrayEmpty(s)
%MYISSTRINGARRAYEMPTY gives 1 if string array is blank 0 otherwise 
is = 1;

if max(size(s)) > 1
    is = 1;
elseif isempty(char(s))
    is = 0;
else 
    
end

is = ~is;

end


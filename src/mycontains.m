function y = mycontains(txt,array)
%checks which array elements gave a hit in contains(txt,array), i.e. want to keep track of associations 
y = 0;
numerals = [1:size(array,1)]';
for i = 1:size(array,1)
    if contains(txt, array(i,1),'ignorecase',true)
        y(i,1) = 1;
    else y(i,1) = 0;
    end
end
y = numerals(logical(y));
if isempty(y) || isempty(array) y=0;, end
end


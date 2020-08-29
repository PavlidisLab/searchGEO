ssLooper = 0;
while ssLooper == 0
disp("Enter sample size of experiments to filter in. i.e. Enter the min/max sample size of desired GEO exps.")
minSStoFilter = input('Min sample size to include : ','s');
maxSStoFilter = input('Max sample size to include (Enter 0 for an unrestricted max threshold): ','s');
if string(maxSStoFilter)  == "0" toPrint = "";, else toPrint = strcat("<=  ", string(maxSStoFilter)); ,end
disp(sprintf('Experiments with sample size %s <= SS %s will be kept. Confirm\n ' , string(minSStoFilter), toPrint))
ssLooper = input('Enter 1 to confirm , 0 to re-enter sample size filtering information : ');

minSStoFilter = str2num(minSStoFilter);
maxSStoFilter = str2num(maxSStoFilter);
status = 0; 
if isempty(minSStoFilter) || isempty(maxSStoFilter)
disp("Atleast one input not numerical, try again... ")
ssLooper = 0;
status = 1;
end
if status == 0 && maxSStoFilter < minSStoFilter && maxSStoFilter ~= 0 
    disp("Max threshold specified is less than min threshold. Try again ... ")
    disp(" ")
    ssLooper = 0;
end

end
 

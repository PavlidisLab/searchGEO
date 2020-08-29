function v = myValidHit_cancer(array, goodLookfor,badLookfor, margin)
%MYVALIDHIT_CANCER gives 1 if no "brain cancer" is hit, otherwise 0 ...
%i.e. by default 1, but exits loop if "brain cancer" is found
g = mystrfind(array,goodLookfor);
b = mystrfind(array,badLookfor);
v =1;
for i = 1:length(g)
  if min( abs( b - g(i,1))) < margin
      v = 0;
      break
  end
end
if length(b) == 0 v=1;, end
if length(g) == 0 v=0;, end

end


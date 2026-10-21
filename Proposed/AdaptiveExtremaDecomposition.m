function [Details,Base] = AdaptiveExtremaDecomposition(I,mode,nLevels)

current = im2double(I);

Details = cell(1,nLevels);

for k=1:nLevels

    filtered = AdaptiveExtremaFilter(current,mode);

    Details{k} = current-filtered;

    current = filtered;

end

Base = current;

end
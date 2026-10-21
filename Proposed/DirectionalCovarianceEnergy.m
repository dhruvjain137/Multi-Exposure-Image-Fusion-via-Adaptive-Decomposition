function energy = DirectionalCovarianceEnergy(patch)

angles = 0:22.5:157.5;

energy = 0;

for k = 1:length(angles)

    rot = imrotate(patch,angles(k),'bilinear','crop');

    C = cov(rot);

    energy = energy + trace(C);

end

end
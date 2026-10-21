function e = WLE(matrix)

    w = (1/16)*[1 2 1;
                2 4 2;
                1 2 1];

    if ndims(matrix)==2
        % Grayscale image
        e = conv2(matrix.^2, w, 'same');

    elseif ndims(matrix)==3
        % RGB image
        e = zeros(size(matrix));

        for c = 1:3
            e(:,:,c) = conv2(matrix(:,:,c).^2, w, 'same');
        end

    else
        error('Unsupported image dimensions.');
    end

end
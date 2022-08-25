function IM = my_rgb2gray(image)
    im = double(image);
    IM = 0.2989 * im(:,:,1) + 0.5870 * im(:,:,2) + 0.1140 * im(:,:,3);
    IM = cast (IM , class(image));
end
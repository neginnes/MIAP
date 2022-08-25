function snr =SNR(x,y)
    x = double(x);
    y = double(y);
    snr = 10*log10(sum(sum(x.^2))/(sum(sum((x-y).^2))));

end
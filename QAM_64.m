function x_qam = QAM_64(x_encoded)
    mod_symbols = [];
    i = 1;
    for k=-7:2:7
        for j=-7:2:7
            mod_symbols(i) = k + 1i*j;
            i = i + 1;
        end
    end
    if mod(length(x_encoded),6) ~= 0
        addZeros = 6*ceil(length(x_encoded)/6) - length(x_encoded);
        x_encoded = [x_encoded zeros(1,addZeros)];
    end
    x_qam = zeros(1,length(x_encoded)/6);
    k = 1;

    for i = 1:6:length(x_encoded)
        index_symbol = bi2de(flip(x_encoded(i:i+5)));
        x_qam(k) = mod_symbols(index_symbol+1);
        k = k+1;
    end
end
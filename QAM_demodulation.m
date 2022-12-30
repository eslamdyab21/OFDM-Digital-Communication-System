function x_QAM_demodeulated = QAM_demodulation(x_QAM_modeulated, M)
    M=log2(M);
    
   greycode = generate_grey_code(M/2);

    
    x_QAM_demodeulated = strings(1,length(x_QAM_modeulated));

    AMi_vector = zeros(1, length(greycode));

    for m = 1 : length(greycode)
        AMi_vector(m) = 2*m - 1 - length(greycode);
    end        
    
    for i = 1:length(x_QAM_demodeulated)
        qam_element = x_QAM_modeulated(i);
        inphase_value = real(qam_element);
        quadrature_value = imag(qam_element);
        
        % get minmum error
        minimm_vector_even = abs(inphase_value - AMi_vector);
        index_even = find(minimm_vector_even == min(minimm_vector_even));
        if length(index_even) >1
            index_even = index_even(1);
        end
        
        minimm_vector_odd = abs(quadrature_value - AMi_vector);
        index_odd = find(minimm_vector_odd == min(minimm_vector_odd));
        if length(index_odd) >1
            index_odd = index_odd(1);
        end
        sequence = strjoin(greycode(index_even) + greycode(index_odd));
        x_QAM_demodeulated(i) = sequence;

    end
    x_QAM_demodeulated = strjoin(x_QAM_demodeulated,"");
    x_QAM_demodeulated = str2num(strjoin(split(x_QAM_demodeulated,""),","));
    
    
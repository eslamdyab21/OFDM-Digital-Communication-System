function x_QAM_demodeulated = QAM_demodulation(x_QAM_modeulated, M)
    M=sqrt(M);

    if mod(length(x_QAM_modeulated),2) ~= 0
       x_QAM_modeulated = [x_QAM_modeulated 0];  
    end
    
    x_QAM_demodeulated = strings(1,length(x_QAM_modeulated));

    AMi_vector = zeros(1, M);

    for m = 1 : M
        AMi_vector(m) = 2*m - 1 - M;
    end    

    greycode = generate_grey_code(sqrt(M));
    
    
    for i = 1:length(x_QAM_demodeulated)
        qam_element = x_QAM_modeulated(i);
        inphase_value = real(qam_element);
        quadrature_value = imag(qam_element);
        
        % get minmum error
        minimm_vector = abs(inphase_value - AMi_vector);
        index_even = find(minimm_vector == min(minimm_vector));
        
        minimm_vector = abs(quadrature_value - AMi_vector);
        index_odd = find(minimm_vector == min(minimm_vector));
        
        sequence = strjoin(greycode(index_even) + greycode(index_odd));
        x_QAM_demodeulated(i) = sequence;
        
    end
    x_QAM_demodeulated = strjoin(x_QAM_demodeulated,'');
    x_QAM_demodeulated = str2num(strjoin(split(x_QAM_demodeulated(1),''),','));
    
    
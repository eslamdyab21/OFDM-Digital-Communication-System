function grey_code = generate_grey_code(n)
    arr = strings(1,2);
    
    arr(1) = '0';
    arr(2) = '1';
    
    i=2;
    j=0;
    
   
    while(i < 2^n)
        start = i-1;
        step = -1;
        N= length(arr);
        start+step*(0:N-1);
        for j = start+step*(0:N-1)
            arr = [arr arr(j+1)];
        end    
        
        for j = linspace(1,i,i)
            arr(j) = "0" + arr(j);
        end
        
        for j = linspace(i,(2*i)-1,i)
            arr(j+1) = "1" + arr(j+1);
        end
        
        i = bitshift(i,1);
    end      
  
    grey_code = arr;
 

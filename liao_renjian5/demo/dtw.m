function d=dtw(sp,si)
% DTW algoritmo Dynamic Time Warping
%   D=DTW(SP,SI) calcula una distancia D entre dos se?ales tras la
%   aplicaci車n del algoritmo DTW sobre una se?al inc車gnita SI con respecto
%   a una se?al patron SP.
%
%   Antonio J. Moya D赤az
%   19 de Noviembre de 2012
%   Tecnolog赤as del Habla, Universidad de Granada

    % Pre-enfasis
    b=[1 -0.97];% Coeficientes del filtro de pre-enfasis
    spe=filter(b,1,sp);
    %spe=sp;
    sie=filter(b,1,si);
    %sie=si;
    
    % Segmentado en tramas
    step=40;
    wdw=80;
    
    c=floor((length(sie)-wdw)/step);
    f=floor((length(spe)-wdw)/step);
    
    dstmat=zeros(f,c);
    
    % Ventana de hamming
    hamwdw=hamming(80);

    %% Matriz de distancias
    
    % Calculando las distancias eucl赤deas del valor absoluto de la
    % transformada de Fourier generamos una matriz que contiene las
    % distancias de cada trama inc車gnita con cada trama del patr車n.
    
    for i=0:1:f-1
    % Iteraci車n sobre la se?al patr車n
        
        % Indice inicial de la trama
        ini=step*i+1;
        
        % Extraemos la trama de la se?al inc車gnita
        framep=spe(ini:ini+wdw-1);
        
        % Enventanado Hamming
        framep=framep.*hamwdw;
        
        % C芍lculo de la FFT
        auxp=fft(framep,wdw);
        fftp=abs(auxp(1:step+1)); %c_mues=abs(ff_mues(1:floor(length(ff_mues)/2)+1));
        
        for j=0:1:c-1
        % Iteraci車n sobre la se?al inc車gnita    
            
            % Indice inicial de trama 
            jni=step*j+1;
            
            % Segmentaci車n de trama
            framei=sie(jni:jni+wdw-1);
            
            % Enventanado Hamming
            framei=framei.*hamwdw;
            
            % C芍lculo de la FFT
            auxi=fft(framei,wdw);
            ffti=abs(auxi(1:step+1));
            
            % Distancia eucl赤dea entre las tramas.
            dst=fftp-ffti;
            dstmat(i+1,j+1)=sqrt(dst'*dst);
        end

    end

    
    %% Matriz de distancias acumuladas
    
    % Una vez creada la matriz de distancias anteriores, generamos la
    % matriz de distancias acumuladas. En contraposici車n al algoritmo
    % planteado en clase, la matriz se genera hacia 'abajo'. Es decir,
    % comenzando en i=0 y j=0 y avanzando hasta i=filas y j=columnas.
    
    % Reserva de espacio para la matriz. Esta tendr芍 las mismas dimensiones
    % que la matriz de distancias anterior.
    dstac=zeros(size(dstmat));
    
    for i=1:1:f
        for j=1:1:c
            
            if i==1 && j==1
                % Valor inicial. Si estamos en 1,1; copiamos la distancia.
                dstac(i,j)=dstmat(i,j);
            elseif i==1
                % Si estamos en la primera fila comparamos solo con el
                % elemento de la misma fila y columna anterior.
                dstac(i,j)=dstmat(i,j)+dstac(i,j-1);
            elseif j==1
                % Si estamos en la primera columna, comparamos solo con el
                % elemento de la misma columna y fila anterior.
                dstac(i,j)=dstmat(i,j)+dstac(i-1,j);
            else
                % En cualquier otro caso consideramos las 3 posibles
                % distancias.
                dv=dstmat(i,j)+dstac(i-1,j);
                dh=dstmat(i,j)+dstac(i,j-1);
                dd=2*(dstmat(i,j)+dstac(i-1,j-1));
                
                % Nos quedamos con la menor de ellas.
                dstac(i,j)=min([dv dh dd]);
            end
        end
    end
    
    % Dividimos por el n迆mero total de tramas.
    d=dstac(f,c)/(f+c);
end
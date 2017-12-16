function  FaseC = automaticPhaseExtraction(nom,tomas,PP,CP,mask)
%%
% Funcion para la extracción de fase continua de proyeccion de franjas
% nom : Nombre base de las imagenes con su direccion de explorador
% tomas: Es un vector donde se especifican las tomas que se desean
%       recuperar.

    kk=1;
    while kk<=numel(tomas)
        toma=tomas(kk);
        I = imread([nom,'_2_1_toma_',num2str(toma),'.bmp']);
        if (nargin>3), if(~isempty(CP)),I = undistortImage(I,CP);end,end
        Mask = mask(:,:,kk);
        PI =PP(:,:,kk);
        if(~isempty(strfind(nom,'_h_')))
            I=I'; phased=AutoFiltre(I,800,0)';
        else
            phased=AutoFiltre(I,800,0);
        end
        
        PhaseC=unwrap2DClasico(PI,phased,Mask);
        FaseC(:,:,kk)=PhaseC;
        kk=kk+1;
    end
end
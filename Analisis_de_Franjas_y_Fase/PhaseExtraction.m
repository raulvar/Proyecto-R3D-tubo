function  [FaseC,Mascara,P1] = PhaseExtraction(nom,tomas,method,FILTRE,nMask)
%%
% Funcion para la extracción de fase continua de proyeccion de franjas
% nom : Nombre base de las imagenes con su direccion de explorador
% tomas: Es un vector donde se especifican las tomas que se desean
%       recuperar.
% method: Metodo por el cual se va a realizar la extraccion de fase
%         'Clasic': Corrimiento de fase a 4 imagenes y unwrapping 2D
%                   clasico.
%         'Temporal': Extraccion de fase a 4 imagenes y unwrapping temporal
%         'FTP' : Recuperacion de fase por filtrado en frecuencia 
% FILTRE: Ventana de filtrado en frecuencia.


if(strcmp(method,'FTP'))
    kk=1;
    while kk<=numel(tomas)
        toma=tomas(kk);
        opc=1;
        %I_centralo=double(imread([nom,'_obj_toma_',num2str(toma),'.bmp']));
        %I_centralv=double(imread([nom,'_cl_toma_',num2str(toma),'.bmp']));
        %Mask=createMask(imfreehand);
        I = imread([nom,'_1_1_toma_',num2str(toma),'.bmp']);
        if (nargin>3)
            if(~isempty(FILTRE))
            I = undistortImage(I,FILTRE);
            end
        end
        
        figure(6), imagesc(I), title(['Recorte el área de interés. Toma:',num2str(toma)])
        
        if(nargin<5)
            figure(6), imagesc(I), title(['Recorte el área de interés. Toma:',num2str(toma)])
            Mask = roipoly;
        else
            Mask = nMask(:,:,kk);
        end
        
        PI =round(size(I)/2);
        if (kk==1)
            [PhaseC,phased,Mask,PI,XF,CE,mod]=analisis_TF(I,Mask,[PI(2),PI(1)]);
        else
            [PhaseC,phased,Mask,PI,XF,CE,mod]=analisis_TF(I,Mask,[PI(2),PI(1)],XF,CE);
        end
        
        Mascara(:,:,kk)=Mask;
        FaseC(:,:,kk)=PhaseC;
        P1(:,:,kk)=PI;
        kk=kk+1;
    end
    close(figure(6))
    
end







if(strcmp(method,'Clasic'))
    kk=1;
    while (kk<=numel(tomas))
        toma=tomas(kk);
        com=[1 2 3 4];
        tt=1;
        for i=1:1
            I1=0;I2=0;I3=0;I4=0;
            for ni=1:1
                I1=I1+double(imread([nom,'_',num2str(com(i,tt)),'_',num2str(ni),'_toma_',num2str(toma),'.bmp']));
                I2=I2+double(imread([nom,'_',num2str(com(i,tt+1)),'_',num2str(ni),'_toma_',num2str(toma),'.bmp']));
                I3=I3+double(imread([nom,'_',num2str(com(i,tt+2)),'_',num2str(ni),'_toma_',num2str(toma),'.bmp']));
                I4=I4+double(imread([nom,'_',num2str(com(i,tt+3)),'_',num2str(ni),'_toma_',num2str(toma),'.bmp']));
            end
            I1=I1/4;I2=I2/4;I3=I3/4;I4=I4/4;
            
            [H,W] =size(I1);
            FaseDt=-atan2(I4-I2,I1-I3);
            
            
            if (i==1)
                mod=sqrt((I4-I2).^2 +(I1-I3).^2);
                mod= (mod-min(mod(:)));
                mod= mod/max(mod(:));
                mask=im2bw(mod,0.05);
                
                
                figure(4), imagesc(FaseDt.*mask), colormap gray;
                choice = questdlg('Desea recortar con roipoly ?','Dessert Menu','Yes','No','No');
                if strcmp(choice,'Yes')
                    mask1=roipoly;
                    choice = questdlg('Desea recortar de nuevo ?','Dessert Menu','Yes','No','No');
                    while strcmp(choice,'Yes')
                        figure(6),imagesc((I1).*mask), colormap gray
                        mask1=roipoly;
                        choice = questdlg('Desea recortar de nuevo ?','Dessert Menu','Yes','No','No');
                    end
                    mask=mask.*mask1;
                end
                DFaseC = unwrap2DClasico(round([H/2 W/2]),FaseDt,mask);
                %[m,ind]=max((I_centralv(:)-I_centralo(:)).*mask(:));    
                %[x0,y0] = ind2sub(size(mask),ind);
                %x0=x0(1);y0=y0(1);
                figure(4), imagesc(DFaseC), colormap gray;
            end
            Mascara(:,:,kk)=mask;
            FaseC(:,:,kk)=DFaseC;
        end
        
        kk=kk+1;
    end
end


if(strcmp(method,'Temp2'))
    com=[1 3 5 7 1 3 5 7;2 4 6 8 2 4 6 8];
   kk=1;
   for toma=tomas
       for i=1:2
           tt=1;
           for v=0:7
               t=2^v;
               choice='Yes';
               while strcmp(choice,'Yes');
                   I1=0;I2=0;I3=0;I4=0;
                   for ni=1:4
                       I1=I1+double(imread([nom,num2str(t),'_',num2str(com(i,tt)),'_',num2str(ni),'_toma_',num2str(toma),'.bmp']));
                       I2=I2+double(imread([nom,num2str(t),'_',num2str(com(i,tt+1)),'_',num2str(ni),'_toma_',num2str(toma),'.bmp']));
                       I3=I3+double(imread([nom,num2str(t),'_',num2str(com(i,tt+2)),'_',num2str(ni),'_toma_',num2str(toma),'.bmp']));
                       I4=I4+double(imread([nom,num2str(t),'_',num2str(com(i,tt+3)),'_',num2str(ni),'_toma_',num2str(toma),'.bmp']));
                   end
                   I1=I1/4;I2=I2/4;I3=I3/4;I4=I4/4;
                   if(nargin>3)
                       I1=abs(ifft2(fft2(I1).*FILTRE));
                       I2=abs(ifft2(fft2(I2).*FILTRE));
                       I3=abs(ifft2(fft2(I3).*FILTRE));
                       I4=abs(ifft2(fft2(I4).*FILTRE));
                       str='_FILTRE';
                   else
                       str='_NO_FILTRE';
                   end
                   %FaseD
                   FaseDt=-atan2(I4-I2,I1-I3);
                   
                   %DifFaseD
                   figure(6), imagesc(FaseDt),title(['Toma : ',num2str(toma)]), colormap gray
                   %figure(50), imagesc(FaseDt),colormap gray
                   if v==0
                       choice = questdlg('modificar configuracion de imagenes?','Dessert Menu','Yes','No','No');
                       if strcmp(choice,'Yes')
                           tt=tt+1;
                           if tt==5
                               hp=warndlg('Ya se corrierron todas las imagenes');
                               waitfor(hp);tt=1;
                           end
                       end
                   else
                       choice='No';
                   end
               end
               %pause
               
               if t==1
                   DFaseC=FaseDt;
               else
                   DFaseD=FaseDt-FaseDt_1;
                   Val=DFaseD-2*pi*round((DFaseD-DFaseC)/2/pi);
                   DFaseC=DFaseC+Val;
                   %suma las diferencias de fase discont pero se ajusta a módulo 2pi
               end
               FaseDt_1=FaseDt;
               
               if (v==0 && i==1)
                   mod=sqrt((I4-I2).^2 +(I1-I3).^2);
                   mod= (mod-min(mod(:)));
                   mod= mod/max(mod(:));
                   mask=im2bw(mod,0.005);
               end
           end
           if i==1
               opc=1;
               prompt={'VALOR UMBRAL :'};
               name='Umbralizacion Mascara';
               numlines=1;
               MAX=0.02;
               defaultanswer={num2str(MAX)};
               while opc
                   figure(6),imagesc(mask.*DFaseC), colormap gray
                   answer=inputdlg(prompt,name,numlines,defaultanswer);
                   if isempty(answer)
                       opc=0;
                   else
                       mask=im2bw(mod,str2double(answer));
                       defaultanswer=answer;
                   end
               end
               choice = questdlg('Desea recortar con roipoly ?','Dessert Menu','Yes','No','No');
               if strcmp(choice,'Yes')
                   mask1=roipoly;
                   choice = questdlg('Desea recortar de nuevo ?','Dessert Menu','Yes','No','No');
                   while strcmp(choice,'Yes')
                       figure(6),imagesc(mask.*DFaseC), colormap gray
                       mask1=roipoly;
                       choice = questdlg('Desea recortar de nuevo ?','Dessert Menu','Yes','No','No');
                   end
                   mask=mask.*mask1;
               end
           end
           Mascara(:,:,kk)=mask;
           FaseC(:,:,i,kk)=DFaseC;
       end
       kk=kk+1;
   end
end








end
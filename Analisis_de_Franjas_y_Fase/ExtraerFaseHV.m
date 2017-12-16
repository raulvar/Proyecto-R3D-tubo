function [ Fasesx,Fasesy,PI] = ExtraerFaseHV(nom_base,tomas,mask,CP)


PI = zeros([1,2,numel(tomas)]);
k=1;
while k<=numel(tomas)
    toma=tomas(k);
    if(~isempty(CP))
     Io=undistortImage(double(imread([nom_base,'_Fr_v_paso_12_obj_toma_',num2str(toma),'.bmp'])),CP);
     Iv=undistortImage(double(imread([nom_base,'_Fr_v_paso_12_cl_toma_',num2str(toma),'.bmp'])) ,CP);
     Ih=undistortImage(double(imread([nom_base,'_Fr_h_paso_12_cl_toma_',num2str(toma),'.bmp'])) ,CP);
    else
    Io=double(imread([nom_base,'_Fr_v_paso_12_obj_toma_',num2str(toma),'.bmp']));
    Iv=double(imread([nom_base,'_Fr_v_paso_12_cl_toma_',num2str(toma) ,'.bmp']));
    Ih=double(imread([nom_base,'_Fr_h_paso_12_cl_toma_',num2str(toma) ,'.bmp']));
    end
    regiones = (((Iv-Io).*(Ih-Io))).*mask(:,:,k);
    %figure(700+k), imagesc(regiones);
    %propi = regionprops(regiones,'Area','Centroid');
    %propi=cell2mat(struct2cell(propi)');
     %[m,pos]=max(propi(:,1));
     [m,pos]=max(regiones(:));
    %[m,pos]=max((Iv(:)-Io(:)).*(Ih(:)-Io(:)));
    [uy,ux] = ind2sub(size(Iv),pos);
    PI(1,:,k) = [ux,uy];
    %figure(620), imagesc(((Iv-Io)+(Ih-Io)).*Maskx(:,:,k))
    %PI(1,:,k)=ginput(1);
    %pause();
    figure(600+k), imagesc((Iv).*(Ih)), hold on, plot(PI(1,1,k),PI(1,2,k),'*r','MarkerSize',12), drawnow
    %figure(600+k), imagesc(regiones)
    k=k+1;
end

nom=[nom_base,'_Fr_v_paso_12'];
Fasesx = automaticPhaseExtraction(nom,tomas,PI,CP,mask);
nom=[nom_base,'_Fr_h_paso_12'];
Fasesy = automaticPhaseExtraction(nom,tomas,PI,CP,mask);


end


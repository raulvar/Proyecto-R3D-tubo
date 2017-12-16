function centroides = Centroides_malla(Im,mask) 
 
props_reg = regionprops(Im,'Area','Centroid');
propi=cell2mat(struct2cell(props_reg)');

Ind = propi(:,1)<9;
propi(Ind,:)=[];

Ind = mask(sub2ind(size(Im),round(propi(:,3)),round(propi(:,2))));
propi(~Ind,:)=[];

centroides = propi(:,2:3);
%figure, imagesc(Im)
%hold on, plot(propi(:,2),propi(:,3),'+r')

end
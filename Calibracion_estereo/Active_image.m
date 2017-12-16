function I = Active_image(nomb,format,n_image)

 for i=1:n_image
% I{i}=imread([dir_principal,nomb,num2str(i),'.bmp']);
I{i,1}=[nomb,num2str(i),format];
% [cPoints,boardSize]  = detectCheckerboardPoints(I{i});
% Xc{i} =cPoints; 
% wPoints = generateCheckerboardPoints(boardSize, squareSize);
% Xw{i} = wPoints;
end

end
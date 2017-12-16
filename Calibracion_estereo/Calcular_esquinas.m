function [cPoints,wPoints] = Calcular_esquinas(nomb,format,n_image,squareSize)
I = cell([n_image,1]);
cPoints=I;
wPoints=I;
for i=1:n_image
    I{i}=imread([nomb,num2str(i),format]);
    %I{i,1}=[nomb,num2str(i),format];
    [cP,boardSize]  = detectCheckerboardPoints(I{i});
    cPoints{i}   =  cP;
    %boardSize{i} =  bS;
    % Xc{i} =cPoints;
    wP = generateCheckerboardPoints(boardSize, squareSize);
    wPoints{i} = wP;
end

end
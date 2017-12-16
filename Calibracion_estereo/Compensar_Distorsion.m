function cPoints = Compensar_Distorsion(Puntos,calib)
if(~isempty(calib))
if iscell(Puntos)
    n = numel(Puntos);
    cPoints = cell([1 n]);
    for i=1:n
        cPoints{i} = undistortPoints(Puntos{i},calib);
    end
elseif size(Puntos,3)>=1
    cPoints=zeros(size(Puntos));
    for i=1:size(Puntos,3)
        cPoints(:,:,i) = undistortPoints(Puntos(:,:,i),calib);
    end
end
else
    cPoints=Puntos;
end

 

end
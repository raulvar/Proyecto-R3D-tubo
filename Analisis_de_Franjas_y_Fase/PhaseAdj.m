function [PhaseCT,PhaseCR,Mask] = PhaseAdj(Fases,Mask,np,a,puntos,t)

Ancho = size(Fases,2);
Alto  = size(Fases,1);
a1=1:a:Ancho;
a2=1:a:Alto;
if nargin<5;
    bb =1;
else
    if isempty(puntos)
        bb =1;
    else
        bb = 0;
    end
end
if(bb)
    PhaseCT = zeros(size(Fases));
else
    PhaseCT = zeros([size(puntos,1),1,size(Fases,3)]);
end


se = strel('disk', t);

for i=1:size(Fases,3)
    Mask(:,:,i) = imerode(Mask(:,:,i),se);
    TT=Polyfit2D_1(Fases(a2,a1,i),Mask(a2,a1,i),a1,a2,np);
    if(bb)
        PhaseCT(:,:,i)=PolyVal2D_1(TT,a1,a2,np);
    else
        PhaseCT(:,:,i)=PolyVal2D_2(TT,puntos(:,1,i),puntos(:,2,i),np);
    end
end
if(bb)
%     ind = ones(size(Mask));
    ind = double(Mask);
    ind(~Mask)=NaN;
    PhaseCR = ind.*(Fases-PhaseCT);
end
end
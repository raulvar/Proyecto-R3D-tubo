function  [Fasesxa,Fasesya,Maskx2,Masky2] = CleanPhase(Fasesx,Fasesy,Mask,op)

[Fasesxa,FX] =  PhaseAdj(Fasesx,Mask,3,1,[],1);
[Fasesya,FY] =  PhaseAdj(Fasesy,Mask,3,1,[],1);
Maskx2 = Mask.*(FX>-0.05 & FX<0.05);
Masky2 = Mask.*(FY>-0.05 & FY<0.05);
[Fasesxa,FX] =  PhaseAdj(Fasesx,Maskx2,3,1,[],1);
[Fasesya,FY] =  PhaseAdj(Fasesy,Masky2,3,1,[],1);
%Maskx2=0; Masky2=0;
if(op)
    for i=1:size(FX,3)
        figure(700+2*i)  , imagesc(FX(:,:,i)), title(['Error Ajuste3 imagen ',num2str(i),' Franjas V']), colorbar, colormap gray
        figure(700+2*i+1), imagesc(FY(:,:,i)), title(['Error Ajuste3 imagen ',num2str(i),' Franjas H']), colorbar, colormap gray
    end
end
end
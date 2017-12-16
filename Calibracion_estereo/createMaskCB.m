function Mask = createMaskCB(I,tomas,MP,a)

Ip = double(imread(I{tomas(1)}));
Mask = zeros([size(Ip),numel(tomas)]);
[X,Y] = meshgrid(1:size(Ip,2),1:size(Ip,1));
if(nargin<4)
    a=15;
end
for i=1:numel(tomas)
    mask1 = zeros(size(Ip)); mask2 = mask1; mask3 = mask1; mask4 = mask1;
    A = MP(1,1,:,i); B = MP(1,end,:,i); C = MP(end,1,:,i);D = MP(end,end,:,i);
    Ip = double(imread(I{tomas(i)}));
    ac = polyfit([A(1) C(1)],[A(2) C(2)],1);
    ab = polyfit([A(1) B(1)],[A(2) B(2)],1);
    bd = polyfit([B(1) D(1)],[B(2) D(2)],1);
    cd = polyfit([C(1) D(1)],[C(2) D(2)],1);
    
    mask1((Y-00-ac(2))/(-ac(1))+(X+a)>0)=1; %ok
    mask2(((Y+a)-ab(1)*(X+00)-ab(2))>0)=1; %ok
    mask3((Y-00-bd(2))/(-bd(1))+(X-a)<0)=1; %ok
    mask4(((Y-a)-cd(1)*(X+00)-cd(2))<0)=1; %ok
    mask = mask1.*mask2.*mask3.*mask4;
    
    %figure, imagesc(mask.*Ip)
    
    Mask(:,:,i)=mask;
end


end
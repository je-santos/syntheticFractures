%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Javier E. Santos 2016
% UT-PGE
% This script creates a fracture with circular patterns 
% according to the input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



dom.size_x = 250;         %domain size in X
dom.size_y = dom.size_x;  %domain size in Y
dom.size_z = 20 +2;       %fracture aperture (void space + solid surfaces)
dom.circle_spacing = 10;  %spacing between circles


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%End of inputs

dom.circle_diam = 50;     %circle diameter
dom.name=[num2str(dom.size_x),'_',num2str(dom.size_z),...
    '_circles_',num2str(dom.circle_diam)];

fid_domain1=fopen(['output/' dom.name '.dat'],'w');
B=zeros(dom.size_x,dom.size_y,dom.size_z); %3D matrix
C=ones(dom.size_x,dom.size_y);  %fracture walls

center=1;
i=0;
while center<dom.size_x-dom.circle_diam
    center=dom.circle_spacing*(i+1)+i*dom.circle_diam+dom.circle_diam/2;
    dom.xcenters(i+1)=center;
    i=i+1;
end

dom.circlesbyside=numel(dom.xcenters);
dom.xcenters=repmat(dom.xcenters,1,dom.circlesbyside);
dom.ycenters=repelem(dom.xcenters,dom.circlesbyside);

dom.radius=dom.circle_diam/2;
dom.value=3;

for i=1:numel(dom.xcenters)
    
    xc = int16(dom.xcenters(i));
    yc = int16(dom.ycenters(i));
    
    x = int16(0);
    y = int16(dom.radius);
    d = int16(1 - dom.radius);
    
    C(xc, yc+y) = dom.value;
    C(xc, yc-y) = dom.value;
    C(xc+y, yc) = dom.value;
    C(xc-y, yc) = dom.value;
    
    while ( x < y - 1 )
        x = x + 1;
        if ( d < 0 )
            d = d + x + x + 1;
        else
            y = y - 1;
            a = x - y + 1;
            d = d + a + a;
        end
        C( x+xc,  y+yc) = dom.value;
        C( y+xc,  x+yc) = dom.value;
        C( y+xc, -x+yc) = dom.value;
        C( x+xc, -y+yc) = dom.value;
        C(-x+xc, -y+yc) = dom.value;
        C(-y+xc, -x+yc) = dom.value;
        C(-y+xc,  x+yc) = dom.value;
        C(-x+xc,  y+yc) = dom.value;
    end
    for ii = xc-int16(dom.radius):xc+(int16(dom.radius))
        for jj = yc-int16(dom.radius):yc+(int16(dom.radius))
            tempR = sqrt((double(ii) - double(xc)).^2 + (double(jj) - double(yc)).^2);
            if(tempR <= double(int16(dom.radius)))
                C(ii,jj)=dom.value;
            end
        end
    end
end

image(C*30);
B(:,:,1)=C(1:dom.size_x,1:dom.size_y);
B(:,:,end)=B(:,:,1);%copy surface to the last

ratio_wnw=sum(sum(B(:,:,1)==3))/sum(sum(B(:,:,1)==1))
isosurface(B)

for i=1:dom.size_z  %prints in Palabos depth
%for i=1:1 %for digital rock portal
    fprintf(fid_domain1,'%i\n',B(:,:,i));
    image(squeeze(B(:,:,i))*30);
    %pause(.1)
end

fclose(fid_domain1);
%csvwrite([dom.name '.txt'], B);
disp('2. Surface Created')
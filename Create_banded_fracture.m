%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Javier E. Santos 2016
% UT-PGE
% This script creates a banded fracture
% according to the input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stripes = [6,12,24]; %number of stripes
z = 1; %fracture aperture

for k=1:numel(stripes)
    s=stripes(k);
    s_char=num2str(s);
    fid_domain1=fopen([s_char '_stripes.dat'],'w');
    A=ones(250,250); %y,x (real life)
    B(:,[1,2,203,204])=4;
    frac_sizey=size(A);
    frac_sizey=frac_sizey(1);
    strip_lenght=round((frac_sizey)/s);
    ss=1:s;
    strip_i=(ss-1)*strip_lenght+1;
    odd=strip_i(2:2:end); %odd matrix
    even=strip_i(1:2:end); %odd matrix
    
    for i=1:numel(odd)
        A(:,even(i):odd(i)-1)=3;
    end
   
    
    for i=1:z  %prints in Palabos depth
        if i==1 || i==z
            figure();imagesc(A)
            fprintf(fid_domain1,'%i\n',A);
        else
            fprintf(fid_domain1,'%i\n',A*0);
        end
    end
    fclose(fid_domain1);
end
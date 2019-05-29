%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Javier E. Santos and Honggeun Jo %%%%%%%%%%%%%%%%%%%%%%%%
%  UT-PGE                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  11-1-2018                                               %
%  Fetch and adjust aperture with Df=2.5~2.9               %
%  The data file used Brown method and used default values %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file_num=[29:-1:25];
num_in_z=30;        %Number of Grid in z-dir.. default 30!

for i=1:size(file_num,2)
    file_name=sprintf('Df_%u.fre',file_num(i));
    
    fid=fopen(file_name,'r');
    data=fscanf(fid,'%f',[5 inf]); data=data';
    fclose(fid);
    
    S_Fetch_needed_info
    S_Get_3D_Matrix_outcome
    
    % save total outcome in one 4D matrix
    Total_Outcome(:,:,:,i)=Outcome; clear Outcome
    
end

%% Will draw the result and calc Df reversely...

% 1. Show the discretized surfaces in z direction
figure()
for z=1:30
    for j=1:5
        
        subplot(3,2,j)
        imagesc(squeeze(Total_Outcome(:,:,z,j))); axis equal
        pause(0.1)
    end
end


% 2. Show the discretized surfaces in y direction

%% Export to file
mkdir('discretized')
for i=1:size(file_num,2)
    fid_domain=fopen(['discretized/fracture_Df_' num2str(file_num(i)) '.dat'],'w');
    for j=1:num_in_z
        fprintf(fid_domain,'%i\n',squeeze(Total_Outcome(:,:,j,i)));
    end
    fclose(fid_domain);
end
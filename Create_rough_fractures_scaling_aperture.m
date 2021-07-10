%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Javier E. Santos and Honggeun Jo                        %
%  UT-PGE                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  11-1-2016                                               %
%  Fetch and adjust aperture with Df=2.5~2.9               %
%  The data file used Brown method and used default values %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file_num=[29:-1:25];
num_in_z=30;        %Number of Grid in z-dir

for i=1:size(file_num,2)
    file_name=sprintf('Df_%u.fre',file_num(i));
    
    fid=fopen([ 'data/' file_name],'r'); %reads the fractures created w/Synfrac
    data=fscanf(fid,'%f',[5 inf]); data=data';
    fclose(fid);
    
    if i==1
        % to get a size of data
        total_grid_num=size(data,1);
        grid_num=double(int16(sqrt(total_grid_num)));
        Outcome=ones(grid_num,grid_num,num_in_z);
        
        % this is to save each colume individually
        x=data(:,1); y=data(:,2);
        top=data(:,3); bottom=data(:,4);
        difference=data(:,5); clear data;
        
        % find the bottom and top... Based on the most hetero result
        % Bottom_ and Top_ will be used in the rest of cases
        Bottom_=min(bottom);
        Top_=max(top);
        ind=(Top_-Bottom_)/(num_in_z-1); % interval of each grid
        
        % mean distance from Top and Bottom
        Mean_=mean(difference);
        
        % This is variable where we save all the outcomes
        Total_Outcome=ones(grid_num,grid_num,num_in_z,size(file_num,2));
    else
        Outcome=ones(grid_num,grid_num,num_in_z);
        
        % this is to save each colume individually
        x=data(:,1); y=data(:,2);
        top=data(:,3); bottom=data(:,4);
        difference=data(:,5); clear data;
        
        % mean distance from Top and Bottom
        mean_=mean(difference);
        adjust_=abs(Mean_-mean_);
        top=top+1.5*adjust_;
        bottom=bottom+0.5*adjust_;
    end
    
    
    
    top_Q = double(int16(top/ind))+1;
    top_Q=reshape(top_Q,grid_num,grid_num);
    bottom_Q = double(int16(bottom/ind))+1;
    bottom_Q=reshape(bottom_Q,grid_num,grid_num);
    
    for ii=1:grid_num; for jj=1:grid_num
            Outcome(ii,jj,bottom_Q(ii,jj):top_Q(ii,jj))=0;
            
        end;   end
    if size(Outcome,3)~=num_in_z
        Outcome(:,:,30)=ones(grid_num,grid_num,1);
    end
    
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




Total_Outcome = permute(Total_Outcome, [4, 1, 2, 3] ) ;
for i=1:5
    frac = squeeze( Total_Outcome(i,:,:,:) );
    frac1 = imresize3(frac, [256,256,128], 'nearest');
    frac2 = imresize3(frac, [256,256,64],  'nearest');
    frac3 = imresize3(frac, [256,256,32],  'nearest');
    frac4 = imresize3(frac, [256,256,16],  'nearest');
    
    tmp1 = ones([256,256,256]);
    tmp1(:,:,128-64:128+63)=frac1;
    
    tmp2 = ones([256,256,256]);
    tmp2(:,:,128-32:128+31)=frac2;
    
    tmp3 = ones([256,256,256]);
    tmp3(:,:,128-16:128+15)=frac3;
    
    tmp4 = ones([256,256,256]);
    tmp4(:,:,128-8:128+7)=frac4;
    
    
    tmp1 = permute(tmp1, [3,1,2]);
    tmp2 = permute(tmp2, [3,1,2]);
    tmp3 = permute(tmp3, [3,1,2]);
    tmp4 = permute(tmp4, [3,1,2]);
    
    %domain =tmp1;
    %save(['D:\SPLBM_output\finney\solid_full_' num2str(i+59) ],'domain')
    %domain =tmp2;
    %save(['D:\SPLBM_output\finney\solid_full_' num2str(i+69) ],'domain')
    %domain =tmp3;
    %save(['D:\SPLBM_output\finney\solid_full_' num2str(i+79) ],'domain')
    
    %domain =tmp4;
    %save(['D:\SPLBM_output\finney\solid_full_' num2str(i+89) ],'domain')
    %figure;imagesc(squeeze(domain(:,:,100)))
  
    
end

% 2. Show the discretized surfaces in y direction

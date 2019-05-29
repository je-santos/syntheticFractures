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

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
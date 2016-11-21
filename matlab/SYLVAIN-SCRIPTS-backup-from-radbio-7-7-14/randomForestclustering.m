%%  How to use Random Forest Clustering with help from Ben Brown
% Runs Random Forest clustering in an unsupervised mode

% First read in data: test located at
% /data/Collaborations/Karpen/Master_Joel/full_norm_data_endcolnamed.tab.txt
file_name = '/data/Collaborations/Karpen/Master_Joel/culled_norm_data_endcolnamed.tab.txt';
num_col = 12; % that does not include the final column, which is assumed to be a string
textformat = [repmat('%f',1,num_col) '%q'];
fid = fopen(file_name,'rt');
data = textscan(fid,textformat,'headerlines',1);
fclose(fid);
gene_names = data{num_col+1}; % Text from last column
mydata=cell2mat(data(1:num_col)); %data above except w/o last column
nrows = size(mydata,1); %Number of rows in data

% Scramble data
scrambled=zeros(size(mydata));
for i=1:num_col
    scrambled(:,i) = mydata(randsample(nrows,nrows),i);
end
labels = [repmat(1,nrows,1);repmat(0,nrows,1)]; % A '1' for the length of mydata and a '0' for the length of scrambled
train = [mydata;scrambled];
% Ben's recommendation for when I have 35 imaging features is to use 12
b=TreeBagger(50,train,labels,'NVarToSample',5);
b=fillProximities(b);
% Need to finish below code if I want to use mdsProx
%mdsProx(b,'keep',%%array of indices corresponding to nonscrambled data,'colors','rb')

    




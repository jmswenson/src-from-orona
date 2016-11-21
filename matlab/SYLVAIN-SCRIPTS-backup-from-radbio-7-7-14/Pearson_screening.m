% This script looks into the target_dir and assumes all subdirectories have
% images and must be analyzed. Search only .dv files and compute the
% correlation between the nuclear channel and any other channels within
% each nucleus. Nuclear segmentation is automatic. nuc_rad is the expected
% radius of the nucleus, if set too low, it will results in fragmented
% nuclei in the segmentation. 
% S. Costes, January 2011, LBNL
%
%Main directory
target_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/4_27_10_malc_ph2av648/test/';
search_str = '*';
list_dir = dir([target_dir search_str]);
nuc_chan = 4;
chan1 = 1;
chan2 = 3;
nuc_rad = 20;
ofp = fopen([target_dir 'pearson_summary_' date '.txt'],'w');
fprintf(ofp,'Image\tnuc#\tnuc size\tPearson with chan1\tPearson with chan2\n');

cnt=1;
for i=1:length(list_dir)
    if and(list_dir(i).isdir,~strcmp(list_dir(i).name(1),'.'))
        list_name{cnt} = list_dir(i).name;
        cnt = cnt+1;
    end
end

num_t = length(list_name);

for i_t=1:num_t % Open directory for time point i_t
    list_img = dir([target_dir list_name{i_t} '/*.dv']);
    num_img = length(list_img);
    for i_img = 1:num_img % Read image i_img for time point i_t
        temp = bfopen3([target_dir list_name{i_t} '/' list_img(i_img).name]);
        nuc_mask = nuc_segmentor_lite3(temp{nuc_chan},nuc_rad,2);
        num_nuc = max(nuc_mask);
        for i_nuc = 1:num_nuc
            nuc = crop_from_mask(temp{nuc_chan},nuc_mask==i_nuc);
            tmp_mask = crop_from_mask(nuc_mask==i_nuc,nuc_mask==i_nuc);
            tmp1 = crop_from_mask(temp{chan1},nuc_mask==i_nuc);
            tmp2 = crop_from_mask(temp{chan2},nuc_mask==i_nuc);
            p1 = corrcoef(double(nuc(tmp_mask>0)),double(tmp1(tmp_mask>0)));
            p2 = corrcoef(double(nuc(tmp_mask>0)),double(tmp2(tmp_mask>0)));
            fprintf(ofp,'%s\t%d\t%d\t%5.3f\t%5.3f\n',list_img(i_img).name,i_nuc,sum(tmp_mask>0),p1(1,2),p2(1,2));
        end
    end
end

fclose('all')
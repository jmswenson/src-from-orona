%target_dir ='\\radbio\data\Collaborations\Karpen\Master_Joel\Joel\movies_4D_for_Sylvain/'; %Path on PC
target_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/6_10_images_new_hp1a_expansion_analysis/data_for_sylvain_quant/'; %Path in linux
list = dir([target_dir '6*.dv']);
ofp = fopen([target_dir 'size_summary.xls'],'w');
fprintf(ofp,'\tTime Step:\t');
bgd = 150; % Background used to correct for bleaching
num_img = length(list);
col_ar = jet(num_img);
h1=figure;hold
h2=figure;hold
for i_img = 1:num_img
    img = bfopen3([target_dir list(i_img).name]);
    hp1 = img{1};
    nuc = img{1}; %%%%%%%%%%%  Comment by JS....cheated and called nuc same as hp1 because I didn't have hp1 in some images
    dim_i = size(hp1);
    z_size = dim_i(3);
    t_length  = dim_i(4);
    if i_img == 1
        fprintf(ofp,'%d\t',1:t_length);
        fprintf(ofp,'\n');
    end
    nuc_mask = newim(dim_i);
    mask = newim(dim_i);
    % Sizes for HP1
    size_mask = zeros(1,t_length);
    size_mask2D = zeros(1,t_length);
    stain_in_hp1 = zeros(1,t_length);
    % Sizes for nuc
    size_nuc_mask = zeros(1,t_length);
    size__nuc_mask2D = zeros(1,t_length);
    for i =1:t_length
%         hp1(:,:,:,i-1) = (hp1(:,:,:,i-1)-bgd)/(mean(hp1(:,:,:,i-1))-bgd);
%         nuc(:,:,:,i-1) = (nuc(:,:,:,i-1)-bgd)/(mean(nuc(:,:,:,i-1))-bgd);
        hp1(:,:,:,i-1) = (hp1(:,:,:,i-1))/(max(hp1(:,:,:,i-1)));
        nuc(:,:,:,i-1) = (nuc(:,:,:,i-1))/(max(nuc(:,:,:,i-1)));
%        nuc_mask(:,:,:,i-1) = berosion(squeeze(label(threshold(nuc(:,:,:,i-1)),2,100,10000000)>0),2);
%        mask(:,:,:,i-1) = hp1(:,:,:,i-1)>(max(hp1(:,:,:,i-1))/2);
    end
    mask = hp1>0.4;
    nuc_mask = nuc>0.5;
    nuc_mask = label(nuc_mask,3,1000,10000000);
    ms = measure(nuc_mask,[],'size');
    [ma,indd]=max(ms.size); % locate largest object
    nuc_mask = (nuc_mask == ms.ID(indd)); % Make largest object cell of interest
    mask = and(nuc_mask,mask); % Make sure hp1 is only the one within the nucleus of interest
    for i=1:t_length
        size_mask(i) = sum(mask(:,:,:,i-1));
        size_mask2D(i) = sum(max(mask(:,:,:,i-1),[],3));
        size_nuc_mask(i) = sum(nuc_mask(:,:,:,i-1));
        size_nuc_mask2D(i) = sum(max(nuc_mask(:,:,:,i-1),[],3));
        stain_in_hp1(i) = sum(nuc(mask(:,:,:,i-1)==1))/sum(nuc(nuc_mask(:,:,:,i-1)==1));
    end
    writeim(mask,[target_dir list(i_img).name(1:end-3) '_hp1_mask.ics'],'ICSv1',0);
    writeim(nuc_mask,[target_dir list(i_img).name(1:end-3) '_nuc_mask.ics'],'ICSv1',0);
    figure(h1);
    plot(size_mask/mean(size_mask(1:4)),'o','color',col_ar(i_img,:));
    figure(h2);
    plot(stain_in_hp1,'o','color',col_ar(i_img,:));
    fprintf(ofp,'%s\tSize HP1\t',list(i_img).name);
    fprintf(ofp,'%5.2f\t',size_mask);
    fprintf(ofp,'\n');
    fprintf(ofp,'\tSize nuc\t');
    fprintf(ofp,'%5.2f\t',size_nuc_mask);
    fprintf(ofp,'\n');
    fprintf(ofp,'\tNuc in HP1\t');
    fprintf(ofp,'%5.2f\t',stain_in_hp1);
    fprintf(ofp,'\n');
end
fclose(ofp);
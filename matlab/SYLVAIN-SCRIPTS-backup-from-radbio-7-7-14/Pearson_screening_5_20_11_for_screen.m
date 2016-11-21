% This script looks into the target_dir and assumes all subdirectories have
% images and must be analyzed. Search only .dv files and compute the
% correlation between the nuclear channel and any other channels within
% each nucleus. Nuclear segmentation is automatic. nuc_rad is the expected
% radius of the nucleus, if set too low, it will results in fragmented
% nuclei in the segmentation.
% S. Costes, January 2011, LBNL
%
%Main directory
target_dir = '/mnt/orona/jswenson/Cellomics_images/40X_kc_2_fields/data/';
output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/Screen/';
%%%%%%%%%%%%%%%%%%%%
file_ext = 'tif'; % CHANGE HERE FOR DIFFERENT EXTENSION (e.g 'dv' = .dv, 'tif' = .tif).   If for screening don't forget to change line 40 to list_img = dir([target_dir list_name{i_t} '/*_w1_*.' file_ext]);
% 7changes way down below if using cellomics
%%%%%%%%% MANUAL SEGMENTING MODE: 1 = true, 0 = false
manual_threshold = 0;
font_size = 6;
line_thickness = 1; %minimum is 1, below, big PROBLEMS
background_correction = 1; % Set to 1 if want to correct nuclei background. Set to 0 if you dont want it
blurr_rad = 30; % the larger, the milder the background correction 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seg_save_dir = [output_dir 'pearson_nuc_seg_saved_7_07_Cellomics_kc/'];
mkdir(seg_save_dir);
search_str = '*';
list_dir = dir([target_dir search_str]);
nuc_chan = 1;
th_val = []; % IF set to [], then system does isodata to segment nucleus. If not, then uses constant threshold
chan1 = 3;
chan2 = 2;
nuc_rad = 8; 
ofp = fopen([output_dir 'pearson_summary_' date '.txt'],'w');
fprintf(ofp,'Image\tnuc#\tnuc size\tPearson with chan1\tPearson with chan2\tPearson chan1 & chan2\tchan1 mean intensity\tchan2 mean intensity\tnuc mean intensity\n');

cnt=1;
for i=1:length(list_dir)
    if and(list_dir(i).isdir,~strcmp(list_dir(i).name(1),'.'))
        list_name{cnt} = list_dir(i).name;
        cnt = cnt+1;
    end
end

num_t = length(list_name);

for i_t=1:num_t % Open directory for time point i_t
    list_img = dir([target_dir list_name{i_t} '/*d0.' file_ext]);  % This (with '/*_w1_*.' will only work on images from the screening center or if I have '_w1_' in the name: noted by Joel
    if isempty(list_img)
        list_img = dir([target_dir list_name{i_t} '/*d0.' upper(file_ext)]);  % This (with '/*_w1_*.' will only work on images from the screening center or if I have '_w1_' in the name: noted by Joel
    end
    num_img = length(list_img);
    for i_img = 1:num_img % Read image i_img for time point i_t
        if strcmp(file_ext, 'tif')
            %first_part_file = regexp(list_img(i_img).name, '[', 'split');            % for format '*_w1_*'
            first_part_file = regexp(list_img(i_img).name, 'd', 'split');             % for format '*d0*'
            first_part_file = first_part_file{1};                                     % for format '*d0'
            %first_part_file = first_part_file{1}(1:end-4);                           % uncomment if using format '*_w1_*'
            temp = read_meta([target_dir list_name{i_t} '/'], first_part_file, '*d*');  % two formats: (1) '*_w*', (2) '*d*'
            name = [first_part_file '.tif']; % setup the naming first
        else
            temp = bfopen3([target_dir list_name{i_t} '/' list_img(i_img).name]);
            name = list_img(i_img).name;
        end
        % Add background correction
        nuc = temp{nuc_chan};
        if background_correction>0
            nuc = nuc - gaussf(nuc,blurr_rad);
        end
        if manual_threshold
            uiwait(dipshow(max(nuc,[],3),'lin'));
            th_val = str2double(inputdlg('Please input the manual defined threshold'));
        end
        nuc_mask = nuc_segmentor_lite3(nuc,nuc_rad,2,th_val,1,0);
        num_nuc = max(nuc_mask);
        % add for mean intensity output
        ms1 = measure(nuc_mask,temp{chan1},'mean');
        ms2 = measure(nuc_mask,temp{chan2},'mean');
        msNuc = measure(nuc_mask, temp{nuc_chan},{'mean','size'});
        %         for i_nuc = 1:num_nuc
        %             nuc = crop_from_mask(temp{nuc_chan},nuc_mask==i_nuc);
        %             tmp_mask = crop_from_mask(nuc_mask==i_nuc,nuc_mask==i_nuc);
        %             tmp1 = crop_from_mask(temp{chan1},nuc_mask==i_nuc);
        %             tmp2 = crop_from_mask(temp{chan2},nuc_mask==i_nuc);
        %             p1 = corrcoef(double(nuc(tmp_mask>0)),double(tmp1(tmp_mask>0)));
        %             p2 = corrcoef(double(nuc(tmp_mask>0)),double(tmp2(tmp_mask>0)));
        %             p1_2 = corrcoef(double(tmp1(tmp_mask>0)),double(tmp2(tmp_mask>0)));
        %             ms1_mean = ms1.Mean(ms1.ID==i_nuc);
        %             ms2_mean = ms2.Mean(ms2.ID==i_nuc);
        %             msNuc_mean = msNuc.Mean(msNuc.ID==i_nuc);
        %             fprintf(ofp,'%s\t%d\t%d\t%5.3f\t%5.3f\t%5.3f\t%5.3f\t%5.3f\t%5.3f\n',list_img(i_img).name,i_nuc,sum(tmp_mask>0),p1(1,2),p2(1,2),p1_2(1,2),ms1_mean,ms2_mean,msNuc_mean);
        %         end
        p1 =label_pearson_coef(temp{nuc_chan},temp{chan1},nuc_mask);
        p2 =label_pearson_coef(temp{nuc_chan},temp{chan2},nuc_mask);  %noted by Joel: changed chan1 to chan2
        p1_2 =label_pearson_coef(temp{chan1},temp{chan2},nuc_mask);
        for i_nuc = 1:num_nuc
            ms1_mean = ms1.Mean(ms1.ID==i_nuc);
            ms2_mean = ms2.Mean(ms2.ID==i_nuc);
            msNuc_mean = msNuc.Mean(msNuc.ID==i_nuc);
            msNuc_size = msNuc.size(msNuc.ID==i_nuc);
            fprintf(ofp,'%s\t%d\t%d\t%5.3f\t%5.3f\t%5.3f\t%5.3f\t%5.3f\t%5.3f\n',name,i_nuc,msNuc_size,p1(i_nuc),p2(i_nuc),p1_2(i_nuc),ms1_mean,ms2_mean,msNuc_mean);
        end
        % Save nucleus segmentation for checking later
        % check if it's 3D
        if (size(nuc_mask,3) > 1)
            mask2D = squeeze(max(nuc_mask,[],3));
            nuc2D = squeeze(max(temp{nuc_chan},[],3));
        else
            mask2D = nuc_mask;
            nuc2D = temp{nuc_chan};
        end
        % Look up coordinates of nuc
        msn = measure(mask2D,[],{'Minimum'});
        mask2D = mask2D>0;
        overlay(stretch(nuc2D),mask2D-berosion(mask2D,line_thickness))
        % Label nuclei with their numbers
        for i_label=1:size(msn,1)
            text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',font_size)
        end
        diptruesize(gcf,50)
        saveas(gcf,[seg_save_dir name(1:end-4) '_nuc_check.tif'],'tif');
        delete(gcf);
    end
end

fclose('all')
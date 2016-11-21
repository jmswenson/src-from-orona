% This script looks into the target_dir and assumes all subdirectories have
% images and must be analyzed. Search only "file_ext" files.
% It segments the cells and output images showing DAPI, H2Av and HP1a with
% nuclear segmentation contours.
%
% S. Costes, February 2012, LBNL
%
%THIS SCRIPT WAS USED FOR THE GENOME-WIDE RNAi SCREEN ON SYLVAIN'S
%MICROSCOPE
%Main directory
target_dir = '/mnt/orona/jswenson/screen_images_from_Sylvain_40X/cluster_images/hp1_clstrs_ordering-01only/'; % Make sure images are two directories down from here
output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/Screen/plates_imaged_on_sylvains_scope/cluster_images/hp1_clstrs_ordering-01only/';

%target_dir = '/mnt/orona/jswenson/screen_images_from_Sylvain_40X/images_of_autocutoff_HP1aclustering/'; % Make sure images are two directories down from here
%output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/Screen/plates_imaged_on_sylvains_scope/';
%output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/Screen/plates_imaged_on_sylvains_scope/01-12-12-V1-4/images_of_autocutoff_HP1a/';

%target_dir = '/mnt/orona/jswenson/screen_images_from_Sylvain_40X/cluster_images/All_cs_corr/'; % Make sure images are two directories down from here
%output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/Screen/plates_imaged_on_sylvains_scope/cluster_images/A_corr/';

% target_dir = '/mnt/orona/jswenson/screen_images_from_Sylvain_40X/cluster_images/All_cs_euclid/'; % Make sure images are two directories down from here
% output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/Screen/plates_imaged_on_sylvains_scope/cluster_images/A_euc/';
% 
% target_dir = '/mnt/orona/jswenson/screen_images_from_Sylvain_40X/cluster_images/All_cs_mahal/'; % Make sure images are two directories down from here
% output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/Screen/plates_imaged_on_sylvains_scope/cluster_images/A_mahal/';
% 
% target_dir = '/mnt/orona/jswenson/screen_images_from_Sylvain_40X/cluster_images/All_cs_spearman/'; % Make sure images are two directories down from here
% output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/Screen/plates_imaged_on_sylvains_scope/cluster_images/A_spear/';
% 
% target_dir = '/mnt/orona/jswenson/screen_images_from_Sylvain_40X/cluster_images/HP_corr/'; % Make sure images are two directories down from here
% output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/Screen/plates_imaged_on_sylvains_scope/cluster_images/A_corr/';
% 
% target_dir = '/mnt/orona/jswenson/screen_images_from_Sylvain_40X/cluster_images/HP_euclid/'; % Make sure images are two directories down from here
% output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/Screen/plates_imaged_on_sylvains_scope/cluster_images/HP_euclid/';
% 
% target_dir = '/mnt/orona/jswenson/screen_images_from_Sylvain_40X/cluster_images/HP_mahal/'; % Make sure images are two directories down from here
% output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/Screen/plates_imaged_on_sylvains_scope/cluster_images/HP_mahal/';
% 
% target_dir = '/mnt/orona/jswenson/screen_images_from_Sylvain_40X/cluster_images/HP_spearman/'; % Make sure images are two directories down from here
% output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/Screen/plates_imaged_on_sylvains_scope/cluster_images/HP_spear/';




% Add columns for plate name, well name, site name, date imaged
% perl -ane '($d, $p, $w, $s)=$F[0]=~/Joel-S-([0-9]+)-.*?kc-([^_]+)_([A-Z][0-9]+)_[a-z]([0-9])/;
% print join "\t", (@F, $p, $w, $s, $d);
% print "\n" 'pearson_summary_27-Jun-2011.txt > pearson_summary_27-Jun-2011_with_well_and_sites.txt

%%%%%%%%%%%%%%%%%%%%
file_ext = 'zvi'; % CHANGE HERE FOR DIFFERENT EXTENSION (e.g 'dv' = .dv, 'tif' = .tif).   If for screening don't forget to change line 40 to list_img = dir([target_dir list_name{i_t} '/*_w1_*.' file_ext]);
% 7changes way down below if using cellomics
%%%%%%%%% MANUAL SEGMENTING MODE: 1 = true, 0 = false
max_int = 2500  %This set the maximum intensity to white in the image. Display is then absolute for ch2 in non stretched version
manual_threshold = 0;
font_size = 6;
line_thickness = 1; % originally 2 %minimum is 1, below, big PROBLEMS
background_correction = 1; % Set to 1 if want to correct nuclei background. Set to 0 if you dont want it: 1 for the screen
blurr_rad = 30; % the larger, the milder the background correction: 30 for the screen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
search_str = '*';
list_dir = dir([target_dir search_str]);
nuc_chan = 1; %for screen nuc_chan =1
th_val = []; % IF set to [], then system does isodata to segment nucleus. If not, then uses constant threshold
chan1 = 2; %for campus 3 is ph2av, 2 is hp1a....for Sylvain's scope it is the opposite: screen chan1=2, chan2=3
chan2 = 3;  % To make sure R analysis is labelled properly set chan1 to be pH2Av and chan2 to be HP1a
nuc_rad = 8; %use 8 for the screen

cnt=1;
for i=1:length(list_dir)
    if and(list_dir(i).isdir,~strcmp(list_dir(i).name(1),'.'))
        list_name{cnt} = list_dir(i).name;
        cnt = cnt+1;
    end
end
list_name = list_name(end:-1:1);

num_t = length(list_name);

for i_t=1:num_t % Open directory number i_t
    if strcmp(file_ext, 'tif')
        list_img = dir([target_dir list_name{i_t} '/*_w1_*.' file_ext]);  % This (with '/*_w1_*.' will only work on images from the screening center or if I have '_w1_' in the name: noted by Joel
        if isempty(list_img)
            list_img = dir([target_dir list_name{i_t} '/*_w1_*.' upper(file_ext)]);  % This (with '/*_w1_*.' will only work on images from the screening center or if I have '_w1_' in the name: noted by Joel
        end
    else
        list_img = dir([target_dir list_name{i_t} '/*.' file_ext]);
    end
    num_img = length(list_img);
    for i_img = 1:num_img % Read image i_img for time point i_t 
        if strcmp(file_ext, 'tif')
            first_part_file = regexp(list_img(i_img).name, '[', 'split');            % for format '*_w1_*'
            %first_part_file = regexp(list_img(i_img).name, 'd', 'split');             % for format '*d0*'
            %first_part_file = first_part_file{1};                                     % for format '*d0'
            first_part_file = first_part_file{1}(1:end-4);                           % uncomment if using format '*_w1_*'
            temp = read_meta([target_dir list_name{i_t} '/'], first_part_file, '*_w*');  % two formats: (1) '*_w*', (2) '*d*'
            name = [first_part_file '.tif']; % setup the naming first
        else
            temp = bfopen3([target_dir list_name{i_t} '/' list_img(i_img).name]);
            name = list_img(i_img).name;
        end
        % Define plate and image info to save
        date_str = name(8:13);
        und_i = findstr(name,'_');
        plate_i = findstr(name,'40XSylvain-')+11;
        plate_str = name(plate_i:und_i(1)-1);
        well_str = name(und_i(1)+1:und_i(2)-1);
        site_str = name(und_i(2)+2);
        % Check name of output file. If entered a new plate, change output
        % file automatically
        if i_img == 1
            file_namej = [plate_str '_' date_str '_pearson_summary_sylvain_40X']; %plate_name, date, pearson_summary_campus_40X
            seg_save_dir = [output_dir plate_str '_segmented_channels/'];
            mkdir(seg_save_dir);
        end
        try % some images are not with the same # of channels... Escape and print out there was a Pb with it
            % Add background correction
            nuc = temp{nuc_chan};
            if background_correction>0
                nuc = nuc - gaussf(nuc,blurr_rad);
            end
            if manual_threshold
                uiwait(dipshow(max(nuc,[],3),'lin'));
                th_val = str2double(inputdlg('Please input the manual defined threshold'));
            end
            % Do nuclear segmentation
            nuc_mask = nuc_segmentor_lite3(nuc,nuc_rad,2,th_val,1,0);
            
            % Save nucleus segmentation for checking later
            % check if it's 3D
            if (size(nuc_mask,3) > 1)
                mask2D = squeeze(max(nuc_mask,[],3));
                nuc2D = squeeze(max(temp{nuc_chan},[],3));
                ch1_2D = squeeze(max(temp{chan1},[],3));
                ch2_2D = squeeze(max(temp{chan2},[],3));
            else
                mask2D = nuc_mask;
                nuc2D = temp{nuc_chan};
                ch1_2D = temp{chan1};
                ch2_2D = temp{chan2};
           end
            % Look up coordinates of nuc
            msn = measure(mask2D,[],{'Minimum'});
            mask2D = mask2D>0;
            % DAPI output
            overlay(stretch(nuc2D),mask2D-berosion(mask2D,line_thickness))
            % Label nuclei with their numbers
            for i_label=1:size(msn,1)
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',font_size)
            end
            diptruesize(gcf,50)
            saveas(gcf,[seg_save_dir name(1:end-4) '_nuc_check.tif'],'tif');
            delete(gcf);
            % Chan1 output
            overlay(stretch(ch1_2D),mask2D-berosion(mask2D,line_thickness))
            % Label nuclei with their numbers
            for i_label=1:size(msn,1)
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',font_size)
            end
            diptruesize(gcf,50)
            saveas(gcf,[seg_save_dir name(1:end-4) '_chan1_check.tif'],'tif');
            delete(gcf);
            % Chan2 output
            overlay(stretch(ch2_2D),mask2D-berosion(mask2D,line_thickness))
            % Label nuclei with their numbers
            for i_label=1:size(msn,1)
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',font_size)
            end
            diptruesize(gcf,50)
            saveas(gcf,[seg_save_dir name(1:end-4) '_chan2_check.tif'],'tif');
            delete(gcf);
            % Chan2 output
            ch2_2D(0,0) = max_int;
            overlay(stretch(clip(ch2_2D,max_int,50)),mask2D-berosion(mask2D,line_thickness))
            % Label nuclei with their numbers
            for i_label=1:size(msn,1)
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',font_size)
            end
            diptruesize(gcf,50)
            saveas(gcf,[seg_save_dir name(1:end-4) '_chan2_not_stretched_check.tif'],'tif');
            delete(gcf);
        catch
            fprintf(ofp,'%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%s\t%s\t%s\n',name,repmat(-1e6,8,1),plate_str,well_str,site_str,date_str);
            fprintf('Problem with image #%d: %s\n',i_img,name);
        end
    end
    fclose('all');
end
% This script looks into the target_dir and assumes all subdirectories have
% images and must be analyzed. Search only .dv files and compute the
% correlation between the nuclear channel and any other channels within
% each nucleus. Nuclear segmentation is automatic. nuc_rad is the expected
% radius of the nucleus, if set too low, it will results in fragmented
% nuclei in the segmentation.
% S. Costes, January 2011, LBNL
% Version 2: compute 4 rings of equal bin, regardless of the nuclear size
%
%THIS SCRIPT WAS USED FOR THE GENOME-WIDE RNAi SCREEN ON SYLVAIN'S
%MICROSCOPE

%dipsetpref('NumberOfThreads',1); % Comment out if using 2D images
%Main directory
%target_dir = '/mnt/orona/jswenson/6-4-12_glass_bottom_test/';
%output_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/glass_bottom_test1/';
%target_dir = '/mnt/orona/jswenson/temp-for-matlab/2-1-14-LIVE-temp/';
%output_dir = '/mnt/orona/jswenson/temp-for-matlab/2-1-14-LIVE-temp/';
target_dir = '/mnt/orona/jswenson/InCell6000/FIRST_PLATE_Joel-and-Amy20x_20x_2014.06.20.23.20.16/';
output_dir = '/mnt/orona/jswenson/InCell6000/FIRST_PLATE_Joel-and-Amy20x_20x_2014.06.20.23.20.16/';
% Add columns for plate name, well name, site name, date imaged
% perl -ane '($d, $p, $w, $s)=$F[0]=~/Joel-S-([0-9]+)-.*?kc-([^_]+)_([A-Z][0-9]+)_[a-z]([0-9])/;
% print join "\t", (@F, $p, $w, $s, $d);
% print "\n" 'pearson_summary_27-Jun-2011.txt > pearson_summary_27-Jun-2011_with_well_and_sites.txt

%%%%%%%%%%%%%%%%%%%%
file_ext = 'tif'; % CHANGE HERE FOR DIFFERENT EXTENSION (e.g 'dv' = .dv, 'tif' = .tif).   If for screening don't forget to change line 40 to list_img = dir([target_dir list_name{i_t} '/*_w1_*.' file_ext]);
% 7changes way down below if using cellomics
%%%%%%%%% MANUAL SEGMENTING MODE: 1 = true, 0 = false
manual_threshold = 0;
font_size = 6;
line_thickness = 2; %minimum is 1, below, big PROBLEMS
background_correction = 1; % Set to 1 if want to correct nuclei background. Set to 0 if you dont want it
blurr_rad = 30; % the larger, the milder the background correction: 30 for the screen, 60 (or 30) for the 60X DV, for cytopsin 90, for live HP1a 150
% for live CG8108 60X use 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
search_str = '*first_plate_E-H*';
%search_str = '*';
%list_dir = dir([search_str]);  % 7-7-14 modified to read files in the target directory - Joel
list_dir = dir([target_dir search_str]);
nuc_chan = 2; %for screen nuc_chan =1....for InCell6000 nuc_chan=2 and chan2 is mCherry-HP1a, chan1 is GFP-ORF
chan1 = 1; %for campus 3 is ph2av, 2 is hp1a....for Sylvain's scope it is the opposite: screen chan1=2, chan2=3
chan2 = 2;  % To make sure R analysis is labelled properly set chan1 to be pH2Av and chan2 to be HP1a
nuc_rad = 10; %use 8 for the screen  %use 20 when using the DV 60X with Kc cells, 25 for S2, for live HP1a 40X use 10, for live HP1a 60X use 20, for live HP1a mCherry 20x InCell use 10

cnt=1;
for i=1:length(list_dir)
    if and(list_dir(i).isdir,~strcmp(list_dir(i).name(1),'.'))
        list_name{cnt} = list_dir(i).name;
        cnt = cnt+1;
        bob = 55;
    end
end
list_name = list_name(end:-1:1);

num_t = length(list_name);

for i_t=1:num_t % Open directory number i_t
    if strcmp(file_ext, 'tif')
        list_img = dir([target_dir list_name{i_t} '/*wv*.' file_ext]);  % This (with '/*_w1_*.' will only work on images from the screening center or if I have '_w1_' in the name: noted by Joel
        if isempty(list_img)
            list_img = dir([target_dir list_name{i_t} '/*wv*.' upper(file_ext)]);  % This (with '/*_w1_*.' will only work on images from the screening center or if I have '_w1_' in the name: noted by Joel
        end
    else
        list_img = dir([target_dir list_name{i_t} '/*.' file_ext]);
    end
    num_img = length(list_img);
    for i_img = 1:num_img % Read image i_img for time point i_t 
        if strcmp(lower(file_ext), 'tif')
            first_part_file = regexp(list_img(i_img).name, 'wv', 'split');   % for new format from screening center - SVC 7/17/2012 '_w'
            %first_part_file = regexp(list_img(i_img).name, '_w', 'split');   % for new format from screening center - SVC 7/17/2012 '_w'
            %first_part_file = regexp(list_img(i_img).name, '[', 'split');   % for format '*_w1_*'
            %first_part_file = regexp(list_img(i_img).name, 'd', 'split');   % for format '*d0*'
            %first_part_file = first_part_file{1};                           % for format '*d0'
            %first_part_file = first_part_file{1}(1:end-4);                  % uncomment if using format '*_w1_*'
            first_part_file = first_part_file{1};                            % for new format - SVC 7/17/2012
            temp = read_meta([target_dir list_name{i_t} '/'], first_part_file, '*wv*');  % two formats: (1) '*_w*', (2) '*d*'
            name = [first_part_file '.tif']; % setup the naming first
        else
            temp = bfopen3([target_dir list_name{i_t} '/' list_img(i_img).name]);
            name = list_img(i_img).name;
        end
        % Define plate and image info to save
        date_str = name(1:8);
        %und_i = findstr(name,'_');
        %plate_i = findstr(name,'_');
        und_i = findstr(name,'-');
        plate_i = findstr(name,'-');
        %plate_str = name(plate_i:und_i(2)-1);
        %well_str = name(und_i(1)+1:und_i(2)-1);
        plate_str = name(plate_i:und_i(1)-1);
        well_str = name(und_i(1)+1:und_i(1)-1);
        site_str = name(und_i(1)+2);
        % Check name of output file. If entered a new plate, change output
        % file automatically
        if i_img == 1
            file_namej = [date '_' name(1:4) '_pearson_summary']; %plate_name, date, pearson_summary_campus_40X
            seg_save_dir = [output_dir date '_' plate_str '_pearson_nuc_seg_saved/'];
            mkdir(seg_save_dir);
            ofp = fopen([output_dir file_namej '.txt'],'w');
            fprintf(ofp,'Image\tplate_name\twell_name\tnuc_num\tnuc_size\tPearson_with_chan1\tPearson_with_chan2\tPearson_chan1_&_chan2\t');
            fprintf(ofp,'Shape_factor\tsize_ring1\tsize_ring2\tsize_ring3\tsize_ring4\t');
            fprintf(ofp,'chan1_mean_intensity\tchan1_std_intensity\tchan1_Min_intensity\tchan1_Max_intensity\tchan1_Skew_intensity\tchan1_Kurtosis_intensity\t');
        %    fprintf(ofp,'chan1_mean_ring1\tchan1_mean_ring2\tchan1_mean_ring3\tchan1_mean_ring4\t');
            fprintf(ofp,'chan2_mean_intensity\tchan2_std_intensity\tchan2_Min_intensity\tchan2_Max_intensity\tchan2_Skew_intensity\tchan2_Kurtosis_intensity\t');
         %   fprintf(ofp,'chan2_mean_ring1\tchan2_mean_ring2\tchan2_mean_ring3\tchan2_mean_ring4\t');
            fprintf(ofp,'nuc_mean_intensity\tnuc_std_intensity\tnuc_Min_intensity\tnuc_Max_intensity\tnuc_Skew_intensity\tnuc_Kurtosis_intensity\t');
          %  fprintf(ofp,'nuc_mean_ring1\tnuc_mean_ring2\tnuc_mean_ring3\tnuc_mean_ring4\t');
            fprintf(ofp,'site_name\tdate_imaged\n');
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
            % nuc_mask = nuc_segmentor_local(nuc,nuc_rad,2,5.0,1,0); %
            % Defaults from Sylvain for nuc_segmentor_local are above
            nuc_mask = nuc_segmentor_local(nuc,nuc_rad,2,3,1,0);%...Joel can adjust this
            nuc_mask = dilation(nuc_mask,2); % smooth nuclei a bit for better p2a...Joel can adjust this
            ms = measure(nuc_mask,[],{'p2a','size'});
            nuc_size = msr2obj(nuc_mask,ms,'size');
            nuc_p2a = msr2obj(nuc_mask,ms,'p2a');
            nuc_mask = and(nuc_p2a<1.5,and(nuc_size>150,nuc_size<900))*nuc_mask; %1.3, 150,400 ...Joel can adjust this
            nuc_mask = relabel_v2(nuc_mask);
            % Put blank pixel between touching nuclei (need this to have
            % ring computation not messed up between nuclei. 7/16/2012, SVC
            nuc_edge = dilation(nuc_mask,2)-nuc_mask;
            nuc_mask(nuc_edge>0) = 0;
            % create about 4 concentric rings around each nucleus
%             nuc_ring = dt(nuc_mask>0); 
%             ms_ring = measure(nuc_mask,nuc_ring,'MaxVal');
%             ring_max = msr2obj(nuc_mask,ms_ring,'MaxVal');
%             nuc_ring = round(nuc_ring*4./ring_max);
%             nucr1 = nuc_ring==1;
%             nucr2 = nuc_ring==2;
%             nucr3 = nuc_ring==3;
%             nucr4 = nuc_ring==4;
            num_nuc = max(nuc_mask);
 
            % add for mean intensity output
            ms1 = measure(nuc_mask,temp{chan1},{'mean','StdDev','Skewness','MaxVal','MinVal','ExcessKurtosis'});
            ms2 = measure(nuc_mask,temp{chan2},{'mean','StdDev','Skewness','MaxVal','MinVal','ExcessKurtosis'});
            msNuc = measure(nuc_mask, temp{nuc_chan},{'mean','StdDev','Skewness','MaxVal','MinVal','ExcessKurtosis','size','P2A'});
            ms1_mean = ms1.Mean; ms1_std = ms1.StdDev; ms1_sk = ms1.Skewness; ms1_min = ms1.MinVal; ms1_max = ms1.MaxVal; ms1_ex = ms1.ExcessKurtosis;
            ms2_mean = ms2.Mean; ms2_std = ms2.StdDev; ms2_sk = ms2.Skewness; ms2_min = ms2.MinVal; ms2_max = ms2.MaxVal; ms2_ex = ms2.ExcessKurtosis;
            n_mean = msNuc.Mean; n_size = msNuc.size; n_shape = msNuc.p2a; n_std = msNuc.StdDev; n_sk = msNuc.Skewness; n_min = msNuc.MinVal; n_max = msNuc.MaxVal; n_ex = msNuc.ExcessKurtosis;
%             % measure concentric rings properties
%             msr1 = measure(nuc_mask,nucr1*1.0,'sum');sizer1 = msr1.sum;
%             msr2 = measure(nuc_mask,nucr2*1.0,'sum');sizer2 = msr2.sum;
%             msr3 = measure(nuc_mask,nucr3*1.0,'sum');sizer3 = msr3.sum;
%             msr4 = measure(nuc_mask,nucr4*1.0,'sum');sizer4 = msr4.sum;
%                % measurement of Channel 1
%             msr1 = measure(nuc_mask,nucr1*temp{chan1},'sum');sumr1_1=msr1.sum;meanr1_1=sumr1_1./sizer1;
%             msr2 = measure(nuc_mask,nucr2*temp{chan1},'sum');sumr2_1=msr2.sum;meanr2_1=sumr2_1./sizer2;
%             msr3 = measure(nuc_mask,nucr3*temp{chan1},'sum');sumr3_1=msr3.sum;meanr3_1=sumr3_1./sizer3;
%             msr4 = measure(nuc_mask,nucr4*temp{chan1},'sum');sumr4_1=msr4.sum;meanr4_1=sumr4_1./sizer4;
%                % measurement of Channel 2
%             msr1 = measure(nuc_mask,nucr1*temp{chan2},'sum');sumr1_2=msr1.sum;meanr1_2=sumr1_2./sizer1;
%             msr2 = measure(nuc_mask,nucr2*temp{chan2},'sum');sumr2_2=msr2.sum;meanr2_2=sumr2_2./sizer2;
%             msr3 = measure(nuc_mask,nucr3*temp{chan2},'sum');sumr3_2=msr3.sum;meanr3_2=sumr3_2./sizer3;
%             msr4 = measure(nuc_mask,nucr4*temp{chan2},'sum');sumr4_2=msr4.sum;meanr4_2=sumr4_2./sizer4;
%                % measurement of nuclear channel
%             msr1 = measure(nuc_mask,nucr1*temp{nuc_chan},'sum');sumr1_n=msr1.sum;meanr1_n=sumr1_n./sizer1;
%             msr2 = measure(nuc_mask,nucr2*temp{nuc_chan},'sum');sumr2_n=msr2.sum;meanr2_n=sumr2_n./sizer2;
%             msr3 = measure(nuc_mask,nucr3*temp{nuc_chan},'sum');sumr3_n=msr3.sum;meanr3_n=sumr3_n./sizer3;
%             msr4 = measure(nuc_mask,nucr4*temp{nuc_chan},'sum');sumr4_n=msr4.sum;meanr4_n=sumr4_n./sizer4;
            % Measure pearson on per nucleus basis
            p1 =label_pearson_coef(temp{nuc_chan},temp{chan1},nuc_mask);
            % Uncomment if you have multiple channels and comment the 0
            % values
            %       p2 =label_pearson_coef(temp{nuc_chan},temp{chan2},nuc_mask);  %noted by Joel: changed chan1 to chan2
            %       p1_2 =label_pearson_coef(temp{chan1},temp{chan2},nuc_mask);
            p2 = p1;
            p1_2 = p1;

            for i_nuc = 1:num_nuc
              fprintf(ofp,'%s\t%s\t%s\t%d\t%d\t%5.3f\t%5.3f\t%5.3f\t',name,plate_str,well_str,i_nuc,n_size(i_nuc),p1(i_nuc),p2(i_nuc),p1_2(i_nuc));
              fprintf(ofp,'%5.3f\t%d\t%d\t%d\t%d\t',n_shape(i_nuc),0,0,0,0);
              fprintf(ofp,'%5.3f\t%5.3f\t%d\t%d\t%5.3f\t%5.3f\t',ms1_mean(i_nuc),ms1_std(i_nuc),ms1_min(i_nuc),ms1_max(i_nuc),ms1_sk(i_nuc),ms1_ex(i_nuc));
              %fprintf(ofp,'%5.3f\t%5.3f\t%5.3f\t%5.3f\t',meanr1_1(i_nuc),meanr2_1(i_nuc),meanr3_1(i_nuc),meanr4_1(i_nuc));
              fprintf(ofp,'%5.3f\t%5.3f\t%d\t%d\t%5.3f\t%5.3f\t',ms2_mean(i_nuc),ms2_std(i_nuc),ms2_min(i_nuc),ms2_max(i_nuc),ms2_sk(i_nuc),ms2_ex(i_nuc));
              %fprintf(ofp,'%5.3f\t%5.3f\t%5.3f\t%5.3f\t',meanr1_2(i_nuc),meanr2_2(i_nuc),meanr3_2(i_nuc),meanr4_2(i_nuc));
              fprintf(ofp,'%5.3f\t%5.3f\t%d\t%d\t%5.3f\t%5.3f\t',n_mean(i_nuc),n_std(i_nuc),n_min(i_nuc),n_max(i_nuc),n_sk(i_nuc),n_ex(i_nuc));
              %fprintf(ofp,'%5.3f\t%5.3f\t%5.3f\t%5.3f\t',meanr1_n(i_nuc),meanr2_n(i_nuc),meanr3_n(i_nuc),meanr4_n(i_nuc));
              fprintf(ofp,'%s\t%s\n',site_str,date_str);
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
            %overlay(stretch(nuc2D)*2,mask2D-berosion(mask2D,line_thickness
            %))
            % overlay above is what Sylvain had by default
            overlay(stretch(nuc2D,0,100,0,2000),mask2D-berosion(mask2D,line_thickness))
            % Label nuclei with their numbers
            for i_label=1:size(msn,1)
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',font_size)
            end
            diptruesize(gcf,50)
            saveas(gcf,[seg_save_dir name(1:end-4) '_nuc_check.tif'],'tif');
            delete(gcf);
        catch
            fprintf(ofp,'%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%s\t%s\t%s\n',name,repmat(-1e6,8,1),plate_str,well_str,site_str,date_str);
            fprintf('Problem with image #%d: %s\n',i_img,name);
        end
    end
    fclose('all');
end
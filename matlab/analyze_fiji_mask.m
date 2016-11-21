% script reads all tif file in same directory as script, look for
% sub-directory with probability plot for pattern recognition algorithm in
% FIJI for heterochromatic features. By using two levels threshold, hope is
% to extract nuclei and heterochromatin
%
% S. Costes, October 2013, LBNL

%%% Need to have this script in the directory you want to run it on, also fiji
%%% generated masks need to be in a folder in that directory called
%%% 'fiji_output'.  ALSO, make sure permissions are correct

% Parameters
nuc_rad = 20; % size of nucleus
proba_th = 0.95; % cutoff used on proba for heterochromatin mask...90 used for test-complex2. 98 used for test1?
disp_size = 75; % percent display for image saving
min_hp1_size = 10; % cutoff to compute number of separate hp1 domain in each cell. Object smaller than this will not be counted

% Take care of file creation, directory creation
file_list = dir('*.tif');
current_dir = pwd;
if isunix
    slash_ind = findstr('/',current_dir);
    slash_str = '/';
else
    slash_ind = findstr('\',current_dir);
    slash_str = '\';
end
current_dir = current_dir((slash_ind(end)+1):end);
output_dir = ['process_' current_dir '_' datestr(date) ];
mkdir(output_dir);
num_file = length(file_list);

% start looping
for i_img =1:num_file
    % Read tif file, segment nuclei, threshold probability image
    [img,metadata] = bfopen3(file_list(i_img).name);
    mask = nuc_segmentor_local((img),nuc_rad,2,[],1,0);
    mask = dilation(erosion(mask,2*nuc_rad),2*nuc_rad);
    % Relabel nucleus
    mask = relabel_v2(mask);
    proba_mask = bfopen3(['fiji_output/' file_list(i_img).name 'HP1a_masks.tif']);
    num_nuc = max(mask);
    proba_mask = proba_mask>proba_th;
    proba_mask = proba_mask*mask;
    proba_label = label(proba_mask>0,2,min_hp1_size,1000000);
    if max(proba_mask)>0 % ONly compute if at least one heterochromatic domain. If not, it would crash
        % measure properties for both nucleus and heterochromatin
        ms_nuc = measure(mask,img,{'size','mean','p2a','Skewness','ExcessKurtosis'});
        ms_het = measure(uint8(proba_mask),img,{'size','mean','p2a','Skewness','ExcessKurtosis'});
        ms_het_obj = measure(uint8(proba_mask*(proba_label>0)),proba_label,{'MaxVal','MinVal'});
        % Add image name to structure output for reference
         ms_struct.image = repmat({file_list(i_img).name(1:end-4)},1,size(ms_nuc.ID,2));
        % Output properties into ms_struct
        ms_struct.ID = ms_nuc.ID;
        ms_struct.nuc_size = ms_nuc.size;
        ms_struct.het_size = nan(1,num_nuc);
        ms_struct.het_size(ms_het.ID) = ms_het.size;
        ms_struct.het_num_obj = nan(1,num_nuc);
        if ~isempty(ms_het_obj)
            ms_struct.het_num_obj(ms_het_obj.ID) = (ms_het_obj.MaxVal-ms_het_obj.MinVal+1);
        end
        ms_struct.nuc_mean = ms_nuc.mean;
        ms_struct.het_mean = nan(1,num_nuc);
        ms_struct.het_mean(ms_het.ID) = ms_het.mean;
        ms_struct.nuc_p2a = ms_nuc.p2a;
        ms_struct.het_p2a = nan(1,num_nuc);
        ms_struct.het_p2a(ms_het.ID) = ms_het.p2a;
        ms_struct.nuc_skew = ms_nuc.skewness;
        ms_struct.het_skew = nan(1,num_nuc);
        ms_struct.het_skew(ms_het.ID) = ms_het.skewness;
        ms_struct.nuc_kurtosis = ms_nuc.ExcessKurtosis;
        ms_struct.het_kurtosis = nan(1,num_nuc);
        ms_struct.het_kurtosis(ms_het.ID) = ms_het.ExcessKurtosis;
        
        %output
        if (i_img == 1) % print header with output if first time run
            nuc_sum_fh = fopen(['nuc_summary_' current_dir '.txt'], 'w');
            struct_print(nuc_sum_fh,ms_struct,1);
        else
            nuc_sum_fh = fopen(['nuc_summary_' current_dir '.txt'], 'at');
            struct_print(nuc_sum_fh,ms_struct,0);
        end
        clear ms_struct
        fclose(nuc_sum_fh);
        
        % save display of het and nuc together
        overlay_img = overlay(stretch(img)*1.5,xor(bdilation(proba_mask>0,2),bdilation(proba_mask>0)),[255 0 0]);
        overlay_img = overlay(overlay_img,xor(bdilation(mask>0,2),bdilation(mask>0)),[255 255 0])
        
        % Look up coordinates of nuc
        msn = measure(mask,[],{'Minimum'});
        % Label nuclei with their numbers
        for i_label=1:size(msn,1)
            try
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',10)
            end
        end
        
        diptruesize(gcf,disp_size)
        saveas(gcf,[output_dir slash_str file_list(i_img).name(1:end-4) '_check.jpg'],'jpg');
        delete(gcf);
        
        % save display of nuc with contour in log scale
        overlay_img = overlay(stretch(log(img)),xor(bdilation(mask>0,2),bdilation(mask>0)),[255 255 0])
        % Label nuclei with their numbers
        for i_label=1:size(msn,1)
            try
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',10)
            end
        end
        
        diptruesize(gcf,disp_size)
        saveas(gcf,[output_dir slash_str file_list(i_img).name(1:end-4) '_check_nuc.jpg'],'jpg');
        delete(gcf);
    end
end
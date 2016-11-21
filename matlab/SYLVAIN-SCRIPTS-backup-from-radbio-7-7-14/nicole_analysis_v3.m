% Version for Nicole, which will first process nuclei manually and then run
% all nuclei at once, from reading a mask directory created where images
% are stored ("nuc_mask"). S. Costes, Jan 2012
% Version 3, removes automatic nuclear segmentation, and create an
% additional step where the software look at the lowest 5th percentile
% intensity in the nucleus and uses this as a background value for each
% nucleus to be subtracted.  S. Costes, Sept. 2012
%
% NOTE on output. S. Costes, Sept 2011
%
% I have two summary files you can upload in excel. The foci_summary, show a bunch of information for each individual foci detected (I rarely use it...). The one I am going to focus on here is the nuc_summary.txt file.
% This one gives you a summary on foci per nucleus:
% So the header looks like that
% nucID 	nfoci 	n_size 	foci_size 	n_mean 	f_mean 	foci_mean 	Rdna 	Rgrad 	foci_dist 	numPfoci 	numNfoci 	size_DB 	mean_DB 	nuc_dist 	image
% 1 	8 	64991 	32.5 	142.5014 	252.2909 	311.4106 	1.158713 	0.740005 	-13.8602 	0 	8 	1314 	341.5383 	4.774285 	A040511-14
%
% This lines means that nucleus ID 1 in image A040511-14 had 8 foci. The average focus size was 32.5 pixels. The mean intensity in the full nucleus for DAPI was n_mean (142.5) and the mean intensity in the full nucleus for the foci channel was f_mean (252.3). Now, the mean intensity of the focus channel just at the position of the detected foci was foci_mean (311.4). Of course, foci_mean should be larger than f_mean. Unless you are curious, Rdna and Rgrad are parameters from previous work that I carry along. Now, I also compute the average distance of all foci with respect to the boundary of DAPI Bright. In the case of nuc ID 1, the foci were far from the heterochromatin (on average 13.8 pixel away). The closer to 0 that number, the closer the foci are seen on average with the heterochromatin edges (green boundaries).  One can also count the number of foci detected inside a green domain (heterochromatin). In this nucleus, none were inside (numPfoci=0 and numNfoci=8). Finally, size_DB indicates the total volume in pixel occupied by DAPI bright. In this case it's 1314, which is much less than the full nuclear volume (n_size = 64991).  The mean intensity of DAPI inside DAPI_bright is 341.5 (mean_DB) which should be more than the mean intensity of the full nucleus (n_mean = 142.5). Finally, the average distance of all foci with respect to the nuclear boundaries is shown as nuc_dist (4.77 pixel). This last number is tricky as typically in 3D the top and bottom layer of the nucleus is only a few slices away from any foci. So, that number is way too small. To be accurate, you would have to sample on your microscope in Z at the same resolution as in X,Y (which would be crazy)... So, disregard this number or use it with caution.
%indices are set for tn061809tn
% CHANGE HERE for different starting number!!!
clear;
start_img_num = 1;
disp_size = 150;
nuc_segmentation = 1; % IF 1, then, user needs to segment all nuclei first before analysis is done. Set it to 0 if this is already done.

output_dir = uigetdir('','Choose output directory');

% Need to finish Texas Red
%USER INPUT INFO:
%target dir:

if ~exist('target_dir')
    target_dir = uigetdir('','Choose directory with images');
    target_dir = [target_dir,'\'];
    keep_parameter = 0;
else
    target_dir = [target_dir,'\'];
end
if ~exist('error_list')
    error_list = 1;
    batch_i = 1;
end
%experiment name:
%exp_name = '6_10_09_hp1a_rnai_5days_HP1a_pH2Av';

%buffer, from deconvolution:
buffer = 25;

if isunix %if unix, make sure all slash are in the right direction or it wont find the file...
    rep_ind = findstr(target_dir,'\');
    for i=1:length(rep_ind)
        target_dir(rep_ind) = '/';
    end
    slash_str = '/';
else
    slash_str = '\';
end


%load parameters from the template filled out by user.
if keep_parameter == 0
    params = load_params([target_dir 'test_params.txt']);
    params.fitc_max_foci_size = 1;
    params.txred_max_foci_size = 1;
    
    params.target_dir = target_dir;
    %params.exp_str = exp_name;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ANALYSIS:
% Get file listing for directory. Depending on imaging platform
switch lower(params.media)
    case {'delta'}
        file_list = dir([target_dir '*.dv']);
    case {'meta'}
        file_list = dir([target_dir '*_D*.*']);
    case {'lsm'}
        file_list = dir([target_dir '*.lsm']);
    case {'zvi'}
        file_list = dir([target_dir '*.zvi']);
    otherwise
        file_list = dir(target_dir);
end


%get rid of directories
ix = [file_list.isdir];
file_list = file_list(~ix);
file_list = {file_list.name};

%for output
dot_index = findstr(file_list{1}, '.');
params.suffix = file_list{1}(dot_index+1:end);
params.range_low = 1;
params.range_high = length(file_list);

cd(target_dir);
current_dir = pwd;
if ~isempty(params.fitc_index)
    if isunix
        slash_ind = findstr('/',current_dir);
        processed_str = '/processed_jc/';
        fitc_str = '/processed_jc/fitc/';
    else
        slash_ind = findstr('\',current_dir);
        processed_str = '\processed_jc\';
        fitc_str = '\processed_jc\fitc\';
    end
end
if ~isempty(params.txred_index)
    if isunix
        slash_ind = findstr('/',current_dir);
        processed_str = '/processed_jc/';
        txred_str = '/processed_jc/txred/';
    else
        slash_ind = findstr('\',current_dir);
        processed_str = '\processed_jc\';
        txred_str = '\processed_jc\txred\';
    end
end
current_dir = current_dir((slash_ind(end)+1):end);


if ~isempty(params.fitc_index)
    mkdir([output_dir processed_str]);
    mkdir([output_dir fitc_str]);
    log_file = fopen([output_dir fitc_str 'run_log_' current_dir '.txt'], 'w');
end
if ~isempty(params.txred_index)
    mkdir([output_dir processed_str]);
    mkdir([output_dir txred_str]);
    log_file = fopen([output_dir txred_str 'run_log_' current_dir '.txt'], 'w');
end

% Do all nuclear segmentation first, only if parameter is set to 1
if nuc_segmentation
    process_manual_nuclei(target_dir,output_dir,file_list,params,buffer,disp_size);
end

%for i = error_list(batch_i):length(file_list)
for i = start_img_num:length(file_list)
    %read image
    switch lower(params.media)
        case {'delta'}
            img = bfopen3([target_dir file_list{i}]);
            nuc = img{params.dapi_index}(buffer:end-buffer,buffer:end-buffer,:);
            if (isfield(params, 'fitc_index'))
                %fitc data is input. analyze this channel
                fitc_img = img{params.fitc_index}(buffer:end-buffer,buffer:end-buffer,:);
            end
            if (isfield(params, 'txred_index'))
                if ~isempty(params.txred_index)
                    %txred data is input. analyze this channel
                    txred_img = img{params.txred_index}(buffer:end-buffer,buffer:end-buffer,:);
                end
            end
        case {'meta'}
            nuc = read_gray_stack([target_dir file_list{i}]);
            try
                fitc_img = read_gray_stack([target_dir file_list{i}(1:end-8) 'F' file_list{i}(end-6:end)]);
            catch
                %params=rmfield(params,'fitc_index');
            end
            try
                txred_img = read_gray_stack([target_dir file_list{i}(1:end-8) 'T' file_list{i}(end-6:end)]);
            catch
                %params=rmfield(params,'txred_index');
            end
        otherwise
            img = bfopen3([target_dir file_list{i}]);
            nuc = img{params.dapi_index};
            if (isfield(params, 'fitc_index'))
                %fitc data is input. analyze this channel
                fitc_img = img{params.fitc_index};
            end
            if (isfield(params, 'txred_index'))
                %txred data is input. analyze this channel
                txred_img = img{params.txred_index};
            end
    end
    if (length(size(nuc)) == 3)
        dimen = 3;
    else
        dimen = 2;
    end
    % Fix illumination problem
    if (dimen == 3)
        % Fix illumination problem
        tmp = gaussf(max(nuc,[],3),200);
        nuc = nuc - repmat(squeeze(tmp),1,1,size(nuc,3));
    else
        tmp = gaussf(nuc,200);
        nuc = nuc - tmp;
        
    end
    
    
    %segment image
    fprintf('segmenting nuclei in %s\n',[target_dir file_list{i}]);
    fprintf(log_file,'segmenting nuclei in %s\n',[target_dir file_list{i}]);
    mask = readim([output_dir slash_str 'nuc_mask' slash_str file_list{i}(1:end-4) 'nuc_mask.ics']);
    
    %% Process FITC
    if ~isempty(params.fitc_index)
        fprintf('Spot detection\n');
        [spot_struct,spot_mask,label_nuc,full_spot,trim_full_spot,sphase_indices, return_wps_arr]= james_spot_detection6_sc(fitc_img, mask, params.fitc_max_foci_size, 100, params.fitc_min, params.fitc_k_val, 2, 1);
        if exist('ms_nuc')
            clear ms_nuc;
        end
        ms = measure(label_nuc,full_spot,'MaxVal');
        ms_nuc.nucID = ms.ID;
        ms_nuc.num_foci = ms.MaxVal;
        ms = measure(label_nuc,nuc,{'size','sum','mean'});
        ms_nuc.nuc_size = ms.size;
        ms_nuc.mean_DAPI = ms.mean;
        ms_nuc.total_DAPI = ms.sum;
        ms = measure(label_nuc,(full_spot>0)*fitc_img,'sum');
        tmp_fociI = ms.sum;
        ms = measure(label_nuc,(full_spot==0)*fitc_img,'mean');
        tmp_bgdI = ms.mean;
        ms_nuc.mean_bgd_intensity_foci = tmp_bgdI;
        ms = measure(label_nuc,1.0*(full_spot>0),'sum');
        ms_nuc.total_area_foci = ms.sum;
        ms_nuc.total_BgdCorrected_intensity_foci = tmp_fociI - ms.sum.*tmp_bgdI;
        ms = measure(label_nuc,fitc_img,'sum');
        ms_nuc.total_fitc_intensity = ms.sum;
        ms_nuc.total_BgdCorrected_fitc_intensity = ms.sum - ms_nuc.nuc_size.*tmp_bgdI;
        
        % Add image name to structure output for reference
        ms_nuc.image = repmat({file_list{i}(1:end-4)},1,size(ms_nuc.nucID,2));
        %output
        if (i == 1) % print header with output if first time run
            nuc_sum_fh = fopen([output_dir fitc_str 'nuc_summary_' current_dir '.txt'], 'w');
            struct_print(nuc_sum_fh,ms_nuc,1);
        else
            nuc_sum_fh = fopen([output_dir fitc_str 'nuc_summary_' current_dir '.txt'], 'at');
            struct_print(nuc_sum_fh,ms_nuc,0);
        end
        fclose(nuc_sum_fh);
        
        
        % Prepare output image
        % Project 3D images on 2D plane
        if size(nuc,3) > 1
            fitc_img = squeeze(max(fitc_img,[],3));
            spot_mask = squeeze(max(spot_mask,[],3));
            mask_out = squeeze(max(mask,[],3));
            nuc_out = squeeze(max(nuc,[],3));
        end
        
        fitc_img = stretch(clip(fitc_img,params.fitc_max_stretch,params.fitc_min_stretch)-params.fitc_min_stretch); % Stretch all fitc images the same way
        overlay_img = overlay(fitc_img,spot_mask);
        edge = newim(size(mask_out));
        edge = (insert_crop(mask_out(1:end,:),edge,[0,size(mask_out,1)-2;0,size(mask_out,2)-1]) - mask_out)^2 + ...
            (insert_crop(mask_out(:,1:end),edge,[0,size(mask_out,1)-1;0,size(mask_out,2)-2]) - mask_out)^2;
        edge = edge>0;
        overlay_img = overlay(overlay_img,edge,[0 0 255])
        % Look up coordinates of nuc
        msn = measure(mask_out,[],{'Minimum'});
        % Label nuclei with their numbers
        for i_label=1:size(msn,1)
            try
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',10)
            catch
                fprintf('Nucleus %d overlap with another nucleus and it is lost in projection...\n',i_label);
                fprintf(log_file,'Nucleus %d overlap with another nucleus and it is lost in projection...\n',i_label);
            end
        end
        diptruesize(gcf,70)
        saveas(gcf,[output_dir fitc_str  file_list{i}(1:end-4) '_spot_check.tif'],'tif');
        delete(gcf);
        overlay_img = overlay(stretch(nuc_out),spot_mask);
        overlay_img = overlay(overlay_img,edge>0,[0 0 255])
        % Label nuclei with their numbers
        for i_label=1:size(msn,1)
            try
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',10)
            catch
                fprintf('Nucleus %d overlap with another nucleus and it is lost in projection...\n',i_label);
                fprintf(log_file,'Nucleus %d overlap with another nucleus and it is lost in projection...\n',i_label);
            end
        end
        diptruesize(gcf,70)
        saveas(gcf,[output_dir fitc_str  file_list{i}(1:end-4) '_spot_dapibright_check.tif'],'tif');
        delete(gcf);
        
        if (dimen == 3)
            overlay_img = overlay(fitc_img, squeeze(max(full_spot,[],3)));
            overlay_img = overlay(overlay_img,edge,[0 0 255])
        else
            overlay_img = overlay(fitc_img, full_spot);
            overlay_img = overlay(overlay_img,edge,[0 0 255])
        end
        for i_label=1:size(msn,1)
            try
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',10)
            catch
                fprintf('Nucleus %d overlap with another nucleus and it is lost in projection...\n',i_label);
                fprintf(log_file,'Nucleus %d overlap with another nucleus and it is lost in projection...\n',i_label);
            end
        end
        diptruesize(gcf,70)
        saveas(gcf,[output_dir fitc_str  file_list{i}(1:end-4) '_full_spot_check.tif'],'tif');
        delete(gcf);
    end
    
    
    %% Process TXRED
    if ~isempty(params.txred_index)
        fprintf('Spot detection\n');
        [spot_struct,spot_mask,label_nuc,full_spot,trim_full_spot,sphase_indices, return_wps_arr]= james_spot_detection6_sc(txred_img, mask, params.txred_max_foci_size, 100, params.txred_min, params.txred_k_val, 2, 1);
        if exist('ms_nuc')
            clear ms_nuc;
        end
        ms = measure(label_nuc,full_spot,'MaxVal');
        ms_nuc.nucID = ms.ID;
        ms_nuc.num_foci = ms.MaxVal;
        ms = measure(label_nuc,nuc,{'size','sum','mean'});
        ms_nuc.nuc_size = ms.size;
        ms_nuc.mean_DAPI = ms.mean;
        ms_nuc.total_DAPI = ms.sum;
        ms = measure(label_nuc,(full_spot>0)*txred_img,'sum');
        tmp_fociI = ms.sum;
        ms = measure(label_nuc,(full_spot==0)*txred_img,'mean');
        tmp_bgdI = ms.mean;
        ms_nuc.mean_bgd_intensity_foci = tmp_bgdI;
        ms = measure(label_nuc,1.0*(full_spot>0),'sum');
        ms_nuc.total_area_foci = ms.sum;
        ms_nuc.total_BgdCorrected_intensity_foci = tmp_fociI - ms.sum.*tmp_bgdI;
        ms = measure(label_nuc,txred_img,'sum');
        ms_nuc.total_txred_intensity = ms.sum;
        ms_nuc.total_BgdCorrected_txred_intensity = ms.sum - ms_nuc.nuc_size.*tmp_bgdI;
        
        % Add image name to structure output for reference
        ms_nuc.image = repmat({file_list{i}(1:end-4)},1,size(ms_nuc.nucID,2));
        %output
        if (i == 1) % print header with output if first time run
            nuc_sum_fh = fopen([output_dir txred_str 'nuc_summary_' current_dir '.txt'], 'w');
            struct_print(nuc_sum_fh,ms_nuc,1);
        else
            nuc_sum_fh = fopen([output_dir txred_str 'nuc_summary_' current_dir '.txt'], 'at');
            struct_print(nuc_sum_fh,ms_nuc,0);
        end
        fclose(nuc_sum_fh);
        
        
        % Prepare output image
        % Project 3D images on 2D plane
        if size(nuc,3) > 1
            txred_img = squeeze(max(txred_img,[],3));
            spot_mask = squeeze(max(spot_mask,[],3));
            mask = squeeze(max(mask,[],3));
            nuc = squeeze(max(nuc,[],3));
        end
        txred_img = stretch(clip(txred_img,params.txred_max_stretch,params.txred_min_stretch)-params.txred_min_stretch); % Stretch all txred images the same way
        overlay_img = overlay(txred_img,spot_mask);
        edge = newim(size(mask));
        edge = (insert_crop(mask(1:end,:),edge,[0,size(mask,1)-2;0,size(mask,2)-1]) - mask)^2 + ...
            (insert_crop(mask(:,1:end),edge,[0,size(mask,1)-1;0,size(mask,2)-2]) - mask)^2;
        edge = edge>0;
        overlay_img = overlay(overlay_img,edge,[0 0 255])
        % Look up coordinates of nuc
        msn = measure(mask,[],{'Minimum'});
        % Label nuclei with their numbers
        for i_label=1:size(msn,1)
            try
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',10)
            catch
                fprintf('Nucleus %d overlap with another nucleus and it is lost in projection...\n',i_label);
                fprintf(log_file,'Nucleus %d overlap with another nucleus and it is lost in projection...\n',i_label);
            end
        end
        diptruesize(gcf,70)
        saveas(gcf,[output_dir txred_str  file_list{i}(1:end-4) '_spot_check.tif'],'tif');
        delete(gcf);
        overlay_img = overlay(stretch(nuc),spot_mask);
        overlay_img = overlay(overlay_img,edge>0,[0 0 255])
        % Label nuclei with their numbers
        for i_label=1:size(msn,1)
            try
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',10)
            catch
                fprintf('Nucleus %d overlap with another nucleus and it is lost in projection...\n',i_label);
                fprintf(log_file,'Nucleus %d overlap with another nucleus and it is lost in projection...\n',i_label);
            end
        end
        diptruesize(gcf,70)
        saveas(gcf,[output_dir txred_str  file_list{i}(1:end-4) '_spot_dapibright_check.tif'],'tif');
        delete(gcf);
        
        
        if (dimen == 3)
            overlay_img = overlay(txred_img, squeeze(max(full_spot,[],3)));
            overlay_img = overlay(overlay_img,edge,[0 0 255])
        else
            overlay_img = overlay(txred_img, full_spot);
            overlay_img = overlay(overlay_img,edge,[0 0 255])
        end
        for i_label=1:size(msn,1)
            try
                text(msn(i_label).Minimum(1),msn(i_label).Minimum(2),sprintf('%d',i_label),'color','yellow','FontSize',10)
            catch
                fprintf('Nucleus %d overlap with another nucleus and it is lost in projection...\n',i_label);
                fprintf(log_file,'Nucleus %d overlap with another nucleus and it is lost in projection...\n',i_label);
            end
        end
        diptruesize(gcf,70)
        saveas(gcf,[output_dir txred_str  file_list{i}(1:end-4) '_full_spot_check.tif'],'tif');
        delete(gcf);
    end
end
fclose(log_file);
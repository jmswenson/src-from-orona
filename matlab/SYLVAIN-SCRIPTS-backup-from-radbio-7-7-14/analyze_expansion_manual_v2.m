% This scripts expects one channel Hp1A type of 3D images. They can be
% mutliple time points or single one. The system expects that each nuclei
% have been separately prior, so that each image is one nucleus.
% It will zoom the image very widely, so if not single nuclei, hard to see
% anything...
% S. Costes, January 2011, LBNL
%
target_dir = '/data/Collaborations/Karpen/Master_Joel/Joel/12_15_10_RNAi/deconv_no_frap/brown/';
%output_dir = '/mnt/orona/IRENE/Volume Quantification/ATM_ATR/ctrl/';
output_dir = '/data2/home/jswenson/12_15_10_RNAi/';
% target_dir ='\\radbio\data\Collaborations\Irene\expansion\09_06_17_testRad51_HP1_Hygro/';
% output_dir ='\\radbio\data\Collaborations\Irene\expansion\09_06_17_testRad51_HP1_Hygro/test/';
normalized = 0; % If positive, then load ics files generated by Imaris for normalization
append_mode = 0; % Set to 0 if start all over.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS SETTINGS %%%%%%%%%%%%%%%%%%%
if normalized
    list = dir([target_dir '*.ics']);
else
    list = dir([target_dir '*.dv']);
end

% Start 0pening files
if append_mode
    ofp = fopen([output_dir 'size_summary.xls'],'a');
    i_ini =inputdlg('Enter starting image #','You are appending to existing file');
    i_ini = str2double(i_ini);
else
    i_ini = 1;
    ofp = fopen([output_dir 'size_summary.xls'],'w');
    fprintf(ofp,'Time Step:\t');
end
num_img = length(list);
col_ar = jet(num_img);
figure;hold
for i_img = i_ini:num_img
    fprintf('Processing img#%d: %s\n',i_img,list(i_img).name)
    if normalized
        irene = readim([target_dir list(i_img).name]);
        irene = squeeze(irene);
    else
        irene = bfopen3([target_dir list(i_img).name]);
        irene = squeeze(irene);
    end
    dim_i = size(irene);
    z_size = dim_i(3);
    if length(dim_i)>3
        t_length  = dim_i(4);
    else
        t_length = 1;
    end
    if i_img == 1
        fprintf(ofp,'%d\t',1:t_length);
        fprintf(ofp,'\n');
    end
    mask = newim(dim_i);
    size_mask = zeros(1,t_length);
    size_mask2D = zeros(1,t_length);
    th = zeros(t_length);
    for i =1:t_length % loop on each time point and let user select ROI where boundary is located
        if t_length==1
            Ir2D = squeeze(max(irene,[],3));
        else
            Ir2D = squeeze(max(irene(:,:,:,i-1),[],3));
        end
        dipshow(100,Ir2D,'lin');
        set(gcf,'Position',[20,300,300,300])
        diptruesize(600)
        roi_flag = 1;
        keyboard_mode = 0;
        while roi_flag % Confirm with users threshold is right
            switch keyboard_mode % Switch on keyboard mode
                case 0 % keyboard_mode off
                    sm_mask = dipcrop;
                    [o,t]=threshold(sm_mask);
                    edge = squeeze(Ir2D>t);
                    edge = bdilation(edge)-edge;
                    dipshow(101,overlay(stretch(Ir2D),edge,[0,0,255]),'lin');
                    set(gcf,'Position',[20,300,300,300])
                    diptruesize(600)
                    ButtonName = questdlg('Keep mask?','Confirm Mask');
                    switch ButtonName
                        case 'Yes'
                            if t_length == 1
                                mask = irene>t;
                            else
                                mask(:,:,:,i-1) = irene(:,:,:,i-1)>t;
                            end
                            th(i) = t;
                            roi_flag = 0;
                            delete(100);
                        otherwise
                            keyboard_mode = 1;
                            delete(100);
                    end
                otherwise % keyboard_mode on
                    %key_press = lower(input('','s'));
                    waitfor(101, 'CurrentCharacter');
                    key_press = get(101, 'CurrentCharacter')
                    fprintf('%s\n',key_press);
                    switch key_press
                        case 'd'
                            t = 0.95*t;
                            set(101,'CurrentCharacter','o'); %force change to allow constant update
                        case 'f'
                            t = 1.05*t;
                            set(101,'CurrentCharacter','o'); %force change to allow constant update
                        case 'q'
                            if t_length == 1
                                mask = irene>t;
                            else
                                mask(:,:,:,i-1) = irene(:,:,:,i-1)>t;
                            end
                            th(i) = t;
                            roi_flag = 0;
                    end
                    edge = squeeze(Ir2D>t);
                    edge = bdilation(edge)-edge;
                    dipshow(101,overlay(stretch(Ir2D),edge,[0,0,255]),'lin');
                    set(gcf,'Position',[20,300,300,300])
                    diptruesize(600)
            end % keyboard switch
        end % interactive threshold
        delete(gcf)
    end % loop on different time points
    for i =1:t_length % threshold images based on fitted threhsold
        if t_length == 1
            size_mask(i) = sum(mask);
            size_mask2D(i) = sum(max(mask,[],3));
        else
            size_mask(i) = sum(mask(:,:,:,i-1));
            size_mask2D(i) = sum(max(mask(:,:,:,i-1),[],3));
        end
    end
    mask = dip_image(uint16(mask>0));
    writeim(mask,[output_dir list(i_img).name(1:end-3) '_mask.ics'],'ICSv1',0);
    plot(size_mask/mean(size_mask(1:4)),'o','color',col_ar(i_img,:));
    fprintf(ofp,'%s\t',list(i_img).name);
    fprintf(ofp,'%5.2f\t',size_mask);
    fprintf(ofp,'%5.2f\t',th);
    fprintf(ofp,'\n');
end
fclose('all');
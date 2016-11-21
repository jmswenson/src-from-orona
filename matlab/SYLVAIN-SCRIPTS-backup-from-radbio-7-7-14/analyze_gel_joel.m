% a = readim('\\radbio\data\Collaborations\Karpen\6_28_10_purification#33EA44_crop.tif');
target_dir = '//Volumes/data-1/Collaborations/Karpen/';
a = readim([target_dir '6_28_10_purification#33EA44_crop.tif']);
a = a{1};
N = 7; % Number of ROI to quantify
% Enter dimension of box
w = 170;
h = 60;
dipshow(1,a,'log')
diptruesize(25)
mask = newim(size(a));
for i=1:N
    coord = dipgetcoords;
    mask(coord(1):min((coord(1)+w),size(a,1)-1),coord(2):min((coord(2)+h),size(a,2)-1))=i;
    dip_img = overlay(stretch(log(a)),mask-erosion(mask));
    delete(1);
    dipshow(1,dip_img);
    diptruesize(25)
end
mask = dip_image(uint8(mask));
ms = measure(mask,a,{'sum','size','mean'});
ofp = fopen([target_dir 'gel_computation.csv'],'w');
struct_print(ofp,ms,1);
fclose('all');
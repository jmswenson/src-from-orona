a = readim('\\radbio\data\Collaborations\Karpen\6_28_10_purification#33EA44_crop.tif');
a = a{1};
N = 10; % Number of ROI to quantify
dipshow(a,'log')
diptruesize(25)
mask = newim(size(a));
for i=1:N
    mask = mask+diproi*i;
end
mask = dip_image(uint8(mask));

ms = measure(mask,a,{'sum','size','mean'});
dip_img = overlay(stretch(log(a)),mask-erosion(mask))
dip_truesize(25)
struct_print
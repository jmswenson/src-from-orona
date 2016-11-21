a = newim(100,100,100);
a(50,50,50) = 1;
b = gaussf(a,20);
b = round(stretch(b));
db = b>250;
nuc = b>25;
d_img = dt(db)-dt(~db)*nuc;
N = 200;
max_dist = 60;
dist1 = zeros(1,max_dist+1);
dist2 = zeros(1,max_dist+1);

for i = 1:N
    rand_img = dip_image(rand(100,100,100));
    foci1 = ((rand_img>0.99995)*nuc)>0;
    % foci2b = ((rand_img>0.9999)*db)>0;  % I want the 10 min timepoint (foci1) to have more foci in db than foci2, but not just by random change
    foci2 = ((rand_img>0.999945)*nuc)>0;
    %ms2= measure(or(foci2,foci2b),d_img,'mean');  % Delete "| foci1b" to return it to Sylvain's original version (and delete above commented line)
    ms2 = measure(foci2,d_img,'mean');
    ms1 = measure(foci1,d_img,'mean');
    for j=0:-1:-max_dist
        pos1 = sum(ms1.mean>j);
        pos2 = sum(ms2.mean>j);
        dist1(-j+1) = pos1 + dist1(-j+1);
        dist2(-j+1) = pos2 + dist2(-j+1);
    end
end
dist1 = dist1/N;
dist2 = dist2/N;

plot((0:max_dist).^3,dist1)
hold;plot((0:max_dist).^3,dist2,'r')

plot((0:max_dist).^2,dist1)
hold;plot((0:max_dist).^2,dist2,'r')

plot((0:max_dist).^1,dist1)
hold;plot((0:max_dist).^1,dist2,'r')


ratio_dist = dist2./dist1;
figure
plot(-max_dist:0,ratio_dist(end:-1:1))


a = newim(100,100,100);
a(50,50,50) = 1;
b = gaussf(a,20);
b = round(stretch(b));
nuc = b>25;
small_nuc = b>250;
N = 200;
max_dist = 100;
dist1 = zeros(1,max_dist+1);
dist2 = zeros(1,max_dist+1);

for i = 1:N
    % Create random DB image
    rand_img = dip_image(rand(100,100,100));
    [maxr,maxi]=max(rand_img*small_nuc);
    a(:) = 0;
    a(maxi(1),maxi(2),maxi(3)) = 1;
    a = stretch(gaussf(a,20)*nuc);
    db = a>250;
    d_img = dt(db)-dt(~db)*nuc;
    % Create random foci
    rand_img = dip_image(rand(100,100,100));
    foci1 = ((rand_img>0.99996)*nuc)>0;
    foci2 = ((rand_img>0.999955)*nuc)>0;
    ms2= measure(foci2,d_img,'mean'); 
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

figure
plot((0:max_dist).^3,dist1/max(dist1))
hold;plot((0:max_dist).^3,dist2/max(dist2),'r')

figure
plot((0:20).^3,dist1(1:21)/max(dist1))
hold;plot((0:20).^3,dist2(1:21)/max(dist2),'r')

ratio_dist = dist2./dist1;
figure
plot(-max_dist:0,ratio_dist(end:-1:1))

figure; hold; % simulations done with three different small nuc. First: b>75, Second: b>35 and last b>250
plot(0:0.07:6,dist1_db_inside(1:86)/max(dist1_db_inside),'r')
plot(0:0.06:6,dist1_db_anywhere(1:101)/max(dist1_db_anywhere),'g')
plot(0:0.07:6,dist1_db_center(1:86)/max(dist1_db_center),'b')
% Load real data from Joel's analysis
data=importdata('/data/Collaborations/Karpen/Master_Joel/Joel/for_sylvain.csv');
dist_real = data(1,:)
plot(-dist_real,data(2,:)/max(data(2,:)),'ko')
plot(-dist_real,data(3,:)/max(data(3,:)),'ko')
plot(-dist_real,data(4,:)/max(data(4,:)),'kd')
plot(-dist_real,data(5,:)/max(data(5,:)),'kd')
 

 




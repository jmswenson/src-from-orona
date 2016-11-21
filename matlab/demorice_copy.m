%DEMORICE
% This is the sequence of commands in the Getting Started
% chapter of the DIPimage manual.
%%%%% Sylvain went through this

a = readim('/home/sylvain/Documents/images/rice.tif')
bg = gaussf(a,25) % Use the size of the boject you want to disappear (roughly), danger if you go too high is that you flatten everything
% if you have 'spiky' signal you use median filter or Fourier
% transformation
a = a-bg
diphist(a,[]);
b = a>10
b = brmedgeobjs(b) % removes objects touching the edge
l = label(b,2);
dipshow(l,'labels');
N = max(l) % will give the number of objects

data = measure(l,a,{'size','feret'}) %%using the labelled image 'l' and measures 'a' (optional)
% can use 'mean' instead of 'feret'
data.size
hist(data.size)
ind = find(data.size==max(data.size)) % to find index of biggest object
data(23).size
data(23).ID
l_rem = l==23;
l = l - l_rem*23 %23 is the object ID... or could have done: and(b,~l_rem)
%%% often time if you work with a labelled image you need to bring the
%%% labells back otherwise you get an error
small_label = l*and(b,~l_rm);
data = measure(uint16(small_label(small_label),a,{'size','mean'})  %% this is how to relabel an image: newer versions uint is now int
% measurehelp
%%%  dipimage has cubical pixel size and this often is not true.  Imaris is
%%%  the best for true 3D pixels

data(33).ID
data.ID(33)
data.size(33)

% Another way to remove touching obects
berosion(b) % erodes the boolean
berosion(b,3) % helps to seperate objects
berosion(b,2) % erode based on the boolean
label(ans) % label everything
dilation(ans) % on dilate the labelled image.  watershed is better, get center (seeds) then apply to the boolean image

%% msobj = msr2obj(l,data,'size')  %%% lets you label based on sixe, so the larger ones have a whiter value
%% msobj>300









%%%%%%%%% below is stuff Sylvain didn't get to

feret = data.feret;
figure; scatter(feret(1,:),feret(2,:))
xlabel('largest object diameter (pixels)')
ylabel('smallest object diameter (pixels)')
%text(feret(1,:)+0.2,feret(2,:)+0.1,num2str([1:N]'))

sz = data.size;
figure; scatter(feret(1,:),sz)
xlabel('object length (pixels^2)')
ylabel('object area (pixels^2)')
%text(feret(1,:)+0.3,sz+5,num2str([1:N]'))

calc = pi*feret(1,:).*feret(2,:)/4;
figure; scatter(sz,calc)
hold on; plot([180,360],[180,360],'k--')
axis equal
box on
xlabel('object area   (pixels^2)')
ylabel('\pi{\cdot}a{\cdot}b   (pixels^2)')
%text(sz+3,calc+5,num2str([1:N]'))

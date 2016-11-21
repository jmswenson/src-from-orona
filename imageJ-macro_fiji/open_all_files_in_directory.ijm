dir1 = getDirectory("Select Directory where you want to open all images ending in R-inverted");
list1 = getFileList(dir1+"*R-inverted.png");
firstfile = dir1+list1[0];
for (i=0; i<list1.length; i++) {
	open(dir1+list1[i]);
	wait(100);
}


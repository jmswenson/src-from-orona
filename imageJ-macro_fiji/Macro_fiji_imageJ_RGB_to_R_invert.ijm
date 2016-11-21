dir1 = getDirectory("Select Directory where you want to convert all pngs from RGB to R and then invert");
list1 = getFileList(dir1);
firstfile = dir1+list1[0];
for (i=0; i<list1.length; i++) {
	open(dir1+list1[i]);
	wait(100);
	run("RGB Stack");
	wait(100);
	run("Next Slice [>]");
	run("Delete Slice");
	run("Next Slice [>]");
	run("Delete Slice");
	run("Invert");
	wait(100);
	saveAs("PNG", dir1+list1[i]+"RGB-to-R-inverted.png");
	wait(100);
	close();
}


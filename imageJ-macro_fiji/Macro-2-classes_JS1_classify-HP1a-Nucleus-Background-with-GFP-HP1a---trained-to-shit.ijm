// This is a ImageJ macro script which loads a classifier and data previously trained and applies the classification to an entire directory
// This classifier works on my 6-10-13 HP1a mutants… uses two classes
dir1 = getDirectory("Tiffs for HP1a and Background based on GFP-HP1a"); // Allows user to select a directory to run the macro on
list1 = getFileList(dir1); // Gets files in directory
firstfile = dir1+list1[0];
run("Trainable Weka Segmentation","open="+firstfile+" color_mode=Default quiet view =Hyperstack stack_order=XYCZT");
wait(100);
call("trainableSegmentation.Weka_Segmentation.loadClassifier", "/mnt/orona/jswenson/6-10-13-transient-HP1a-mutant-test-Mirus/simple-trained-to-shit-classifier.model");
call("trainableSegmentation.Weka_Segmentation.loadData", "/mnt/orona/jswenson/6-10-13-transient-HP1a-mutant-test-Mirus/simple-data-trained-to-shit.arff");
wait(10000);
for (i=0; i<list1.length; i++) {
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", dir1, list1[i], "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	wait(50000); // Have to wait for above to finish, my need to be increased for large images or complex classifiers
	selectWindow(list1[i]);
	close();
	selectWindow("Classification result");
	run("Stack to Images");
//	print(dir1+"/fiji_output/"+list1[i]+"masks.tif");
	saveAs("Tiff", dir1+"/fiji_output/"+list1[i]+"background_masks.tif");
	close();
	saveAs("Tiff", dir1+"/fiji_output/"+list1[i]+"HP1a_masks.tif");
	close();
}



//selectWindow("6-10-13_transient-HP1a-mutant-test-Mirus_WT-L_2_R3D_D3D_PRJ_02_CPY.dv");




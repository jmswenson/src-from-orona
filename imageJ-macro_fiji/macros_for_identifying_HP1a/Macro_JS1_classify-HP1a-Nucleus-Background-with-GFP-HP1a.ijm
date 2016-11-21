// This is a ImageJ macro script which loads a classifier and data previously trained and applies the classification to an entire directory
dir1 = getDirectory("Tiffs for HP1a, Nucleus and Background based on GFP-HP1a");
list1 = getFileList(dir1);
firstfile = dir1+list1[0];
run("Trainable Weka Segmentation","open="+firstfile+" color_mode=Default quiet view =Hyperstack stack_order=XYCZT");
wait(100);
call("trainableSegmentation.Weka_Segmentation.createNewClass", "background");
call("trainableSegmentation.Weka_Segmentation.loadClassifier", "/mnt/orona/jswenson/6-10-13-transient-HP1a-mutant-test-Mirus/cropped-deconv-projections/testclassifier.model");
call("trainableSegmentation.Weka_Segmentation.loadData", "/mnt/orona/jswenson/6-10-13-transient-HP1a-mutant-test-Mirus/cropped-deconv-projections/testdata.arff");
wait(10000);
for (i=0; i<list1.length; i++) {
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", dir1, list1[i], "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	wait(50000);
	selectWindow(list1[i]);
	close();
	selectWindow("Classification result");
	run("Stack to Images");
//	print(dir1+"/fiji_output/"+list1[i]+"masks.tif");
	saveAs("Tiff", dir1+"/fiji_output/"+list1[i]+"background_masks.tif");
	close();
	saveAs("Tiff", dir1+"/fiji_output/"+list1[i]+"nuc_masks.tif");
	close();
	saveAs("Tiff", dir1+"/fiji_output/"+list1[i]+"HP1a_masks.tif");
	close();
}



//selectWindow("6-10-13_transient-HP1a-mutant-test-Mirus_WT-L_2_R3D_D3D_PRJ_02_CPY.dv");




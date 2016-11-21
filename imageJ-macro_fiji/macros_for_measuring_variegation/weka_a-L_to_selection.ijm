// This script runs on a whole image and doesn't do any segmentation.  It is more for testing purposes.
// See make_ROIs_and_do_again_batch-off_yellow-var--weka-subtraction.ijm

// Macro converts a single image to Lab colorspace, removes the b portion and then loads and runs
// a Weka classifier to segment the yellow portion of the fly butts.  Script works as advertised,
// but model isn't quite right for yellow variegation.  

// Convert to Lab Stack, make 8-bit, get rid of b stack since it isn't very helpful
run("Lab Stack");
run("8-bit");
run("Next Slice [>]");
run("Next Slice [>]");
run("Delete Slice", "delete=channel");
selectWindow("yellow_var_test---CG7357_last2segmentsonly-1.tif");
selectWindow("yellow_var_test---CG7357_last2segmentsonly-2.tif");


// Open segmentation, load classifier and get result
run("Trainable Weka Segmentation");
selectWindow("Trainable Weka Segmentation v2.2.1");
call("trainableSegmentation.Weka_Segmentation.loadClassifier", "/Users/joel/Desktop/variegation_with_SC/yellow_variegation/classifier_La-1.model");
call("trainableSegmentation.Weka_Segmentation.getResult");

// Convert the two classified images into binary images and subtract L from a (a-L)
selectWindow("Classified image");
run("8-bit");
run("Auto Threshold", "method=Default white");
run("Make Binary", "method=Default background=Dark calculate");
run("Stack to Images");
imageCalculator("Subtract create", "Classified-0002","Classified-0001");
selectWindow("Result of Classified-0002");
run("Create Selection");
//measure
selectWindow("yellow_var_test---CG7357_last2segmentsonly-1.tif");
run("Restore Selection");





/*

run("Duplicate...", " ");
run("Lab Stack");
run("8-bit");
run("Next Slice [>]");
run("Next Slice [>]");
run("Delete Slice", "delete=channel");
run("8-bit");
//close();
run("Duplicate...", " ");
run("Invert");
setAutoThreshold("Moments dark");
//setThreshold(50, 255);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Create Selection");

*/
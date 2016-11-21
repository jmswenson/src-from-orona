// Implementation works fine, but model might need to be improved to accurately call yellow var

/* Input for script is a collage of all fly butts (last two segments) of a given genotype
How I made collages:
In Fiji do:
1.
File, New, Image
Name: KV108_no-bal_MTA1-like
Type: RGB
Fill with: Black
Width: 1280 pixels
Height 960 pixels
Slices: 1

2. Open all the images of a certain genotype by selecting them all in Finder and dragging them to the Fiji Menu Bar.
3. Use the "Freehand selections" tool to circle the last two segments, copy it, paste it into the file you created in step 1.
Note that within Fiji you can use Command+w to close the file.
4. Repeat for all butts within a genotype making sure they don't overlap (as discussed above)
5. In Fiji use File, Save As, Tiff
6. Repeat for other genotypes.
*/

/* Script opens collage tiff, segments and numbers each fly butt.  For each fly butt
it 1. Measures the butt size
2. converts it to Lab Stack, make 8-bit, get rid of b stack since it isn't very helpful
3. uses a Weka classifier to identify body hairs (bristles) in the L channel and identifies
yellow gene product and bristles in the a channel
4. Subtracts the bristles from the yellow gene product and bristles...leaving only the yellow gene product
5. Measures the result of step 4
*/

// Note that if you get weird errors first try increasing the wait time around all Weka steps...ImageJ doesnt seem to wait for Weka to finish before trying to proceed

// Script outputs two values per fly butt: 1. Size of fly butt, 2. Size of _variegated_ (actually what Weka calls variegation) area on butt

dir1=getDirectory("image");
setBatchMode(true); // Controls whether images are visible or hidden during macro execution. If arg is 'true', the interpreter enters batch mode and newly opened images are not displayed. If arg is 'false', exits batch mode and disposes of all hidden images except for the active image, which is displayed in a window. The interpreter also exits batch mode when the macro terminates, disposing of all hidden images.

run("Clear Results");// Added by JMS
run("Select None"); // Added by JMS

roiManager("reset");
if (isOpen("ROI Manager")) {
	selectWindow("ROI Manager");
	run("Close");
}
imgName=getTitle(); // Added by JMS
run("Select None"); // Added by JMS
run("Duplicate...", "title=1.tif");// Added by JMS...so that you can mask it later.  See http://imagej.1557.x6.nabble.com/Threshold-Colour-select-macro-question-td5000412.html
imgNameA=getTitle();

// Color Thresholder 2.0.0-rc-31/1.49v
// Autogenerated macro, single images only!
//  Segment the fly bodies from a black background, this is quicker than using Weka Segmentation // Added by JMS
min=newArray(3);
max=newArray(3);
filter=newArray(3);
a=getTitle();
run("HSB Stack");
run("Convert Stack to Images");
selectWindow("Hue");
rename("0");
selectWindow("Saturation");
rename("1");
selectWindow("Brightness");
rename("2");
min[0]=0;
max[0]=255;
filter[0]="pass";
min[1]=0;
max[1]=255;
filter[1]="pass";
min[2]=1;
max[2]=255;
filter[2]="pass";
for (i=0;i<3;i++){
  selectWindow(""+i);
  setThreshold(min[i], max[i]);
  run("Convert to Mask");
  if (filter[i]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (i=0;i<3;i++){
  selectWindow(""+i);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
rename(a);
// Colour Thresholding Done-------------



// Below code is modified from: https://digital.bsd.uchicago.edu/imagej_macros/use%20ROI%20manager%20to%20analyze%20more%20than%20one%20image.txt

// Loop the ROI manager to analyze more than one image.
// Process and make binary your image to create ROIs (example, dapi stained nuclei) 
// add the following code to create the list in ROI manager and then analyze additional
// images.  Additional analysis can include drawing the ROI onto the analyzed image 
// or not.  Set Measurements can be used to change the Results given.


// The following code creates a list of ROIs in the ROI manager.  Code to process image
//  into a binary image must be added above this section!!

run("Analyze Particles...", "minimum=0 maximum=Infinity  show=Nothing record");    //     
o = nResults;;
for (i=0; i<o; i++) {
	x = getResult('XStart', i);
	y = getResult('YStart', i);
	doWand(x,y);			// this step does the tracing, next builds the ROI list
	roiManager("add");
}


// This code will switch to a second window, measure within each ROI to create a results table and then 
// draw the ROI onto the measured image + give each ROI a number. 
// For measurement without ROI drawing, see the second batch of code below.
// Image processing steps can be put in between the selectWindow command and the run("Set Measurements") command.  
// Note the image selected should NOT be thresholded or binary


selectWindow(imgName);     // Switches to second image for measurements within ROI boundaries, fill in name of image between " "
run("Set Measurements...", "area mean centroid min integrated skewness limit display redirect=None decimal=0");  // change this to fit your needs

n = roiManager("count");
print(n);
run("Colors...", "foreground=white background=black selection=yellow");
roiManager("deselect");

for (i=0; i<n; i++) {
	roiManager("select", i);
	run("Measure");		  //this  measures pixel intensity in ROI
	x = getResult('X');			// use centroids for labels
	y = getResult('Y');
//
///////////// BREAK TO USE WEKA SEGMENTATION TO IDENTIFY yellow GENE PRODUCT
	close("\\Others"); // Closes all windows except the front image	
	roiManager("select", i);
	run("Duplicate...", "title=delete2.tif");
	imgNameAA=getTitle(); // Added by JMS
	run("Duplicate...", "title=delete1.tif");
	imgNameA=getTitle(); // Added by JMS
	run("Select None"); // Added by JMS
//	run("Measure");	// Added by JMS - get area of entire window

// Convert to Lab Stack, make 8-bit, get rid of b stack since it isn't very helpful
run("Lab Stack");
run("8-bit");
run("Next Slice [>]");
run("Next Slice [>]");
run("Delete Slice", "delete=channel");
wait(500);
selectWindow("delete1.tif");

//	run("Duplicate...", "duplicate");// Added by JMS...so that you can mask it later.  See http://imagej.1557.x6.nabble.com/Threshold-Colour-select-macro-question-td5000412.html


	run("Trainable Weka Segmentation");
	wait(50);
	selectWindow("Trainable Weka Segmentation v2.2.1");
wait(1000);
	call("trainableSegmentation.Weka_Segmentation.loadClassifier", "/Users/joel/Desktop/variegation_with_SC/yellow_variegation/classifier_La-5.model");
//	call("trainableSegmentation.Weka_Segmentation.loadData", "~/Desktop/variegation_with_SC/yellow_variegation/yellow_data3.arff"); // You do not need to load the data to apply the classifier
//	call("trainableSegmentation.Weka_Segmentation.getProbability");
wait(6000);
	call("trainableSegmentation.Weka_Segmentation.getResult");
wait(15000);
//	selectWindow("Classified image");
	selectWindow("Trainable Weka Segmentation v2.2.1");
	close();

// Convert the two classified images into binary images and subtract L from a (a-L)
selectWindow("Classified image");
run("8-bit");
run("Auto Threshold", "method=Default white");
run("Make Binary", "method=Default background=Dark calculate");
run("Stack to Images");
imageCalculator("Subtract create", "Classified-0002","Classified-0001");
selectWindow("Result of Classified-0002");
run("Create Selection");




	close();
	selectWindow(imgNameAA); // Added by JMS
	run("Restore Selection");
	run("Measure"); // Measure the _variegated_ part of the eyes

	run("Flatten");
	outputPath="/masked_outputs/";
	if (!File.exists(dir1+outputPath)) {File.makeDirectory(dir1+outputPath)}; // check if outputPath exists, if not make it
	saveAs("Jpeg", dir1+outputPath+imgName+"__butt_"+toString(i)+"__yellow_var-labeled.jpg");
//selectWindow(imgNameDD); // Added by JMS
//run("Remove Overlay");
//run("Select None"); // Added by JMS
//close("\\Others"); // Closes all windows except the front image	



	selectWindow(imgName);
	L = toString(i);			// create label from iteration
	getVoxelSize(width, height, depth, unit);	//convert locale back to pixels
	setFont("SansSerif",50, "bold");
	drawString(L, x/width, y/height);	//draw ROI label
	roiManager("draw");		// draw outline on second image

	close("\\Others"); // Closes all windows except the front image	
	// BREAK TO CALCULATE AREA WITHIN EYE ABOVE A CERTAIN THRESHOLD IS OVER --- added by JMS

	roiManager("deselect");
  }
//dir1=getDirectory("image");
saveAs("Jpeg", dir1+"masked_outputs/"+imgName+"-labeled.jpg");
roiManager("delete"); // Added by JMS
roiManager("reset");
close("*");


//  Works great for white variegation 

// 9-2-15 Joel Mathew Swenson, LBL.  Code was adopted for my purposes from many different sources and using the macro recorder.
// Run using Fiji by first opening a single collage and then Plugins, Macros, Run or Install
// Ran using Fiji 2.0.0-rc-31/1.49v; Java 1.6.0_65 [64-bit]

// This script outputs 3 measurements per eye in the following order: 1. Area of segmented eye, 
// 2.  area of eye + black background, 3.  portion of eye counted as variegated + black background.
// Use math to determine fraction of eye that is variegated.

// Note that quantitation can be screwed up is there is another eye within BoxA.  BoxA is defined Xmin to Xmax and Ymin to Ymax of a given eye.
// Basically don't put two eyes too close to each other.

/* Input for script is a collage of all eyes of a given genotype
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
3. Use the "Freehand selections" tool to circle the eye, copy it, paste it into the file you created in step 1.
Note that within Fiji you can use Command+w to close the file.
4. Repeat for all eyes within a genotype making sure they don't overlap (as discussed above)
5. In Fiji use File, Save As, Tiff
6. Repeat for other genotypes.
*/

/* Areas to target for improvement:
1. Represent segmentation more clearly in the output, 
2. Write the output automatically instead copying and pasting from the Results section
3. Automatically segment eyes (shouldn't be too hard using Weka Segmentation)
4. Enable script to run on an entire directory instead of one image at a time
5. Use PCA or Kmeans to automatically detect RGB values corresponding to variegated pixels (or other colorspace, e.g. HSB, Lab)
6. Calculate the distance (on a pixel basis) in RGB space from a _variegated_ pixel (as determined in step 5) probably with different weights on different colors
NOTE THAT STEPS 5 AND 6 MAY PROVE PROBLEMATIC BECAUSE VERY VARIEGATED AND SLIGHTLY VARIEGATED MAY NOT BE PROPORTIONAL IN RGB OR ANOTHER COLORSPACE
Note: RGB Measure Plus plugin and ShapeLogic may prove useful
*/




// Set RGB values that you want to count as _variegated_
// Determine values using Color inspector 3D, which is a great tool for determining how 
// 		different colors are represented in different color spaces…histogram is useful within that plugin.
// NOTE YOU MAY NEED TO ADJUST VALUES BASED ON YOUR CAMERA SET-UP/GENETIC BACKGROUND (of your flies, not you)
// Special note if you don't use RGB colorspace: Color Threshold appears to have some bugs so be careful

Rmin=0;
Rmax=255;
Gmin=0;
Gmax=90;
Bmin=0;
Bmax=20; // (0-255, 0-90, 0-20) used for Heterochromatin paper (2016 in prep)

run("Clear Results");
run("Select None");


setBatchMode(true); // Controls whether images are visible or hidden during macro execution. If arg is 'true', the interpreter enters batch mode and newly opened images are not displayed. If arg is 'false', exits batch mode and disposes of all hidden images except for the active image, which is displayed in a window. The interpreter also exits batch mode when the macro terminates, disposing of all hidden images.

/////////////////////////////////
// SAVE TIF OF WHAT GETS COUNTED AS VARIEGATED, note that variegated is contiguous with the black background //////////////////////////////
 
imgNameDD=getTitle(); 
run("Duplicate...", "title=1.tif");// Added so that you can mask it later.  See http://imagej.1557.x6.nabble.com/Threshold-Colour-select-macro-question-td5000412.html
imgNameAA=getTitle();
 
// Color Thresholder 2.0.0-rc-31/1.49v
// Autogenerated macro, single images only!
// Segment the _variegated_ part of the eyes
min=newArray(3);
max=newArray(3);
filter=newArray(3);
a=getTitle();
run("RGB Stack");
run("Convert Stack to Images");
selectWindow("Red");
rename("0");
selectWindow("Green");
rename("1");
selectWindow("Blue");
rename("2");
min[0]=Rmin;
max[0]=Rmax;
filter[0]="pass";
min[1]=Gmin;
max[1]=Gmax;
filter[1]="pass";
min[2]=Bmin;
max[2]=Bmax;
filter[2]="pass";
for (j=0;j<3;j++){
  selectWindow(""+j);
  setThreshold(min[j], max[j]);
  run("Convert to Mask");
  if (filter[j]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (j=0;j<3;j++){
  selectWindow(""+j);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
rename(a);
// End of Color Segmentation


run("Create Selection");  
close();
selectWindow(imgNameDD);
dir1=getDirectory("image");
run("Restore Selection");
run("Add Selection...");
run("Flatten");
outputPath="/masked_outputs/";
if (!File.exists(dir1+outputPath)) {File.makeDirectory(dir1+outputPath)}; // check if outputPath exists, if not make it
saveAs("Jpeg", dir1+outputPath+imgNameDD+"RGB"+Rmin+"-"+Rmax+"_"+Gmin+"-"+Gmax+"_"+Bmin+"-"+Bmax+"_var-labeled.jpg");
selectWindow(imgNameDD);
run("Remove Overlay");
run("Select None");
close("\\Others"); // Closes all windows except the front image	

// END OF SAVE TIF OF WHAT GETS COUNTED AS VARIEGATED //////////////////////////////
/////////////////////////////////

roiManager("reset");
if (isOpen("ROI Manager")) {
	selectWindow("ROI Manager");
	run("Close");
}
imgName=getTitle(); 
run("Select None"); 
run("Duplicate...", "title=1.tif");// Added so that you can mask it later.  See http://imagej.1557.x6.nabble.com/Threshold-Colour-select-macro-question-td5000412.html
imgNameA=getTitle();

// Color Thresholder 2.0.0-rc-31/1.49v
// Autogenerated macro, single images only!
//  Segment the eyes from a black background 
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
	// BREAK TO CALCULATE AREA WITHIN EYE ABOVE A CERTAIN THRESHOLD 

	roiManager("select", i);
	run("Duplicate...", "title=delete1.tif");
	imgNameA=getTitle();
	run("Select None"); 


	run("Measure");	//  get area of entire window
	run("Duplicate...", "title=1.tif");// Added so that you can mask it later.  See http://imagej.1557.x6.nabble.com/Threshold-Colour-select-macro-question-td5000412.html

	// Color Thresholder 2.0.0-rc-31/1.49v
	// Autogenerated macro, single images only!
	// Segment the _variegated_ part of the eyes
	min=newArray(3);
	max=newArray(3);
	filter=newArray(3);
	a=getTitle();
	run("RGB Stack");
	run("Convert Stack to Images");
	selectWindow("Red");
	rename("0");
	selectWindow("Green");
	rename("1");
	selectWindow("Blue");
	rename("2");
	min[0]=Rmin;
	max[0]=Rmax;
	filter[0]="pass";
	min[1]=Gmin;
	max[1]=Gmax;
	filter[1]="pass";
	min[2]=Bmin;
	max[2]=Bmax;
	filter[2]="pass";
	for (j=0;j<3;j++){
	  selectWindow(""+j);
	  setThreshold(min[j], max[j]);
	  run("Convert to Mask");
	  if (filter[j]=="stop")  run("Invert");
	}
	imageCalculator("AND create", "0","1");
	imageCalculator("AND create", "Result of 0","2");
	for (j=0;j<3;j++){
	  selectWindow(""+j);
	  close();
	}
	selectWindow("Result of 0");
	close();
	selectWindow("Result of Result of 0");
	rename(a);
//
	// Colour Thresholding-------------
	run("Create Selection");  
	selectWindow(imgNameA); 
	run("Restore Selection"); 
	run("Measure"); // Measure the _variegated_ part of the eyes



	selectWindow(imgName);
	L = toString(i);			// create label from iteration
	getVoxelSize(width, height, depth, unit);	//convert locale back to pixels
	drawString(L, x/width, y/height);	//draw ROI label
	roiManager("draw");		// draw outline on second image

	close("\\Others"); // Closes all windows except the front image	
	// BREAK TO CALCULATE AREA WITHIN EYE ABOVE A CERTAIN THRESHOLD IS OVER 

	roiManager("deselect");
  }
dir1=getDirectory("image");
saveAs("Jpeg", dir1+"masked_outputs/"+imgName+"-labeled.jpg");
roiManager("delete"); 
roiManager("reset");
close("*");


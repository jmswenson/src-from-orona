// Below is from: https://digital.bsd.uchicago.edu/imagej_macros/Area%20measure%20from%20full%20color%20image%20with%20batch%20processing.txt
//  https://digital.bsd.uchicago.edu/docs/imagej_macros/Area%20measure%20from%20full%20color%20image%20with%20batch%20processing.txt

//  Macro for measuring area of brown from a full color histology image.
//  This macro has two parts, one for white balance and one for measurements.
//  To use, install both macros at the same time by choosing Macros --> Install Macros.  

//  Once that's done, use Macros --> White Balance and choose the folder where the 
// images live to run white balance on all images in that 
//  folder (balanced images will be saved to the new folder with name  + balanced). 

//  Then run Macros --> Measurements on the same folder or on a new folder with just the 
//  balanced pictures transferred there.  Overlay images from the Measurements macro will 
//  save as .jpeg images in the same folder.   
// White balance by Vytas Bindokas, Measurements by by Christine Labno, UChicago, April 2013


macro "White balance" {
dir = getDirectory("Choose a Directory ");
    list = getFileList(dir);
print(list.length, ' files in this folder');
 setFont("SansSerif", 24);
 start = getTime();

//setBatchMode(true); // runs up to 6 times faster

for (f=0; f<list.length; f++) {	//main files loop
        path = dir+list[f];
       // showProgress(f, list.length);
 if (!endsWith(path,"/") && endsWith(path,"f")) open(path);   //do only TIF files
 print(path);
  if (nImages>=1) {

run("Colors...", "foreground=white background=black selection=yellow");
setTool("rectangle");
waitForUser("draw rectangle for white balance, then hit OK");

// beginning of inserted white balance macro code

ti=getTitle;
run("Set Measurements...", "  mean redirect=None decimal=3");
roiManager("add");
                if (roiManager("count")==0)
               exit("you must draw region first");
roiManager("deselect");
run("RGB Stack");
roiManager("select",0);
setSlice(1);
run("Measure");
R=getResult("Mean");   
setSlice(2);
run("Measure");
G=getResult("Mean");
setSlice(3);
run("Measure");
B=getResult("Mean");
print(B);
roiManager("reset");
run("Select None");
run("16-bit");
run("32-bit");
t=((R+G+B)/3);

setSlice(1);
dR=R-t;
if (dR<0){
run("Add...", "slice value="+abs(dR));
} else if (dR>0) {
run("Subtract...", "slice value="+abs(dR));
}

setSlice(2);
dG=G-t;
if (dG<0){
run("Add...", "slice value="+abs(dG));
} else if (dG>0) {
run("Subtract...", "slice value="+abs(dG));
}
setSlice(3);
dB=B-t;
if (dB<0){
run("Add...", "slice value="+abs(dB));
} else if (dB>0) {
run("Subtract...", "slice value="+abs(dB));
}
run("16-bit");
run("Convert Stack to RGB");
run("Flip Vertically");
s=lastIndexOf(path, '.');
r=substring(path, 0,s);
n=r+" balanced.tif";
save(n);
close();
selectWindow("ROI Manager");
run("Close");
selectWindow("Results");
run("Close");
selectWindow("Log");
run("Close");
//selectImage(1);
//run("Convert Stack to RGB");
//rename("original");
//selectWindow(ti);
close();

//  end white balance macro code

          } 
      }
  }


macro "Measurements" {
dir = getDirectory("Choose a Directory ");
    list = getFileList(dir);
print(list.length, ' files in this folder');
 setFont("SansSerif", 24);
 start = getTime();

//setBatchMode(true); // runs up to 6 times faster

for (f=0; f<list.length; f++) {	//main files loop
        path = dir+list[f];
       // showProgress(f, list.length);
 if (!endsWith(path,"/") && endsWith(path,"f")) open(path);   //do only TIF files
 print(path);
  if (nImages>=1) {


// PROPERTIES ASSUME A 20X IMAGE
run("Properties...", "channels=1 slices=1 frames=1 unit=um pixel_width=0.33 pixel_height=0.33 voxel_depth=0 frame=[0 sec] origin=0,0");   

t=getTitle;
rename("image"); 
run("Split Channels");

imageCalculator("Subtract create 32-bit", "image (red)","image (blue)");

selectWindow("Result of image (red)");

run("Invert");
run("Conversions...", "scale");
run("16-bit");

run("Gaussian Blur...", "sigma=0.5 scaled");

setAutoThreshold("Default");
//run("Threshold...");

waitForUser("set your threshold and press OK");

rename(t);
run("Set Measurements...", "area area_fraction limit display redirect=None decimal=2");
run("Measure");

run("Create Selection");
run("Colors...", "foreground=yellow background=black selection=yellow");  //change color here
run("Draw");

s=lastIndexOf(path, '.');
r=substring(path, 0,s);
t2=r+" outlines";
//save(t2);
saveAs("Jpeg", t2);

close();
close();
close();
close();

        }
     }
  }


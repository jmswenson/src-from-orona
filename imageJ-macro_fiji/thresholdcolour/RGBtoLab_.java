import ij.*;
import ij.plugin.filter.PlugInFilter;
import ij.process.*;

//             v1.0 Initial release
// 8/May/2015  v1.1 fixed to use sRGB and match the ColorSpaceConverter

public class RGBtoLab_ implements PlugInFilter {

	public int setup(String arg, ImagePlus imp) {
		if (arg.equals("about"))
			{showAbout(); return DONE;}
		return DOES_RGB;
	}


	public void run(ImageProcessor ip) {


			ColorSpaceConverter converter = new ColorSpaceConverter();
			int[] pixels = (int[])ip.getPixels();
			for (int i=0; i<pixels.length; i++) {
				double[] values = converter.RGBtoLAB(pixels[i]);
				int L1 = (int) (values[0] * 2.55);
				int a1 = (int) (Math.floor((1.0625 * values[1] + 128) + 0.5));
				int b1 = (int) (Math.floor((1.0625 * values[2] + 128) + 0.5));
				pixels[i]=(int)(((L1&0xff)<<16)+((a1&0xff)<<8)+(b1&0xff));

			}
		}

/*
run("RGB Stack");
run("Convert Stack to Images");
selectWindow("Red");
run("Rename...", "title=L");
selectWindow("Green");
run("Rename...", "title=a");
selectWindow("Blue");
run("Rename...", "title=b");
run("LUT... ", "open=/home/gabriel/ImageJ/Lab_a.lut");
run("LUT... ", "open=/home/gabriel/ImageJ/Lab_b.lut");
*/

	void showAbout() {
		IJ.showMessage("About RGBtoLab...",
		"RGBtoLab v1.1 by Gabriel Landini,  G.Landini@bham.ac.uk\n"+
		"Converts from RGB to CIE L*a*b* and stores the results in the same\n"+
		"RGB image R=L*, G=a*, B=b*. Values are therfore offset and rescaled.");
	}

}

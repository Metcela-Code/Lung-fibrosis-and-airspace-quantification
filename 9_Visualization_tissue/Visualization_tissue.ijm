/*
 * The macro allows to assemble a vizualization of ROI in the sample.
 * The macro requires files generated at previous steps.
 * The present file must be copied to the "plugins" folder of ImageJ/Fiji.
 */

//Integration to ImageJ/Fiji menu
macro"Visualization_tissue"{

//Input files definition
//Opening of sample image
Dialog.create("Input file #1 (1/6)");
Dialog.addMessage("Open sample image");
Dialog.show();
open();
SampleImage = File.nameWithoutExtension;
rename(SampleImage);
run("Select All");
selectWindow(SampleImage);
run("Duplicate...", "title=[SampleImage_copy]");
close(SampleImage);

//Applying parenchyma selection
Dialog.create("Input files #2 (2/6)");
Dialog.addMessage("Open parenchyma ROI set");
Dialog.show();
open();
roiManager("Select", roiManager("Count") - 1);
roiManager("Set Fill Color", "yellow");
roiManager("Show All without labels");
selectWindow("SampleImage_copy");
run("From ROI Manager");
run("Flatten");
selectWindow("SampleImage_copy-1");
rename("Overlay_1");
selectWindow("ROI Manager");
run("Close");
run("Select None");

//Applying sample border selection
Dialog.create("Input files #3 (3/6)");
Dialog.addMessage("Open sample border ROI set");
Dialog.show();
open();
roiManager("Select", roiManager("Count") - 1);
roiManager("Set Fill Color", "green");
roiManager("Show All without labels");
selectWindow("Overlay_1");
run("From ROI Manager");
run("Flatten");
selectWindow("Overlay_1-1");
rename("Overlay_2");
selectWindow("ROI Manager");
run("Close");
run("Select None");

//Applying air ducts walls selection
Dialog.create("Input files #4 (4/6)");
Dialog.addMessage("Open air ducts walls ROI set");
Dialog.show();
open();
roiManager("Select", roiManager("Count") - 1);
roiManager("Set Fill Color", "green");
roiManager("Show All without labels");
selectWindow("Overlay_2");
run("From ROI Manager");
run("Flatten");
selectWindow("Overlay_2-1");
rename("Overlay_3");
selectWindow("ROI Manager");
run("Close");
run("Select None");

//Applying air ducts selection
Dialog.create("Input files #5 (5/6)");
Dialog.addMessage("Open air ducts ROI set");
Dialog.show();
open();
roiManager("Select", roiManager("Count") - 1);
roiManager("Set Fill Color", "cyan");
roiManager("Show All without labels");
selectWindow("Overlay_3");
run("From ROI Manager");
run("Flatten");
selectWindow("Overlay_3-1");
rename("Overlay_4");
selectWindow("ROI Manager");
run("Close");
run("Select None");

//Applying fibrosis selection
Dialog.create("Input files #6 (6/6)");
Dialog.addMessage("Open fibrosis ROI set:");
Dialog.show();
open();
roiManager("Select", roiManager("Count") - 1);
roiManager("Set Fill Color", "red");
roiManager("Show All without labels");
selectWindow("Overlay_4");
run("From ROI Manager");
run("Flatten");
selectWindow("Overlay_4-1");
rename("Visualization_tissue");
selectWindow("ROI Manager");
run("Close");
run("Select None");

//Legend
//Parenchyma
setColor("yellow");
x = 0; y = 50;
setFont("SansSerif", 50, "antiliased");
drawString("Parenchyma", x, y, "black");
//Border
setColor("green");
y += 50;
setFont("SansSerif", 50, "antiliased");
drawString("Border", x, y, "black");
//Air ducts walls
setColor("green");
y += 50;
setFont("SansSerif", 50, "antiliased");
drawString("Air ducts walls", x, y, "black");
//Air ducts
setColor("cyan");
y += 50;
setFont("SansSerif", 50, "antiliased");
drawString("Air ducts", x, y, "black");
//Fibrosis
setColor("red");
y += 50;
setFont("SansSerif", 50, "antiliased");
drawString("Fibrosis", x, y, "black");

//Deletion of intermediate files
close("Overlay_1");
close("Overlay_2");
close("Overlay_3");
close("Overlay_4");

//Ouput
	//Save dialog
	Dialog.create("Save output files");
	Dialog.addCheckbox("Save?", false);
	Dialog.show();
	
	save_output = Dialog.getCheckbox();
		if (save_output == true) {

			//Image
			selectWindow("Visualization_tissue");
			saveAs("Tiff");
		}

//Close all windows dialog
	Dialog.create("End of analysis");
	Dialog.addCheckbox("Close all windows?", false);
	Dialog.show();

	close_all = Dialog.getCheckbox();
		if (close_all == true) {
			close("*");
		}

//END
}

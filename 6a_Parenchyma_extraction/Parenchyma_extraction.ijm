/*
 * The macro allows to extract the parenchyma from the sample. 
 * The macro requires files generated at previous steps. 
 * The present file must be copied to the "plugins" folder of ImageJ/Fiji.
 */

//Integration to ImageJ/Fiji menu
macro"Parenchyma_extraction"{

//Input files definition
//Opening of sample image
Dialog.create("Input file #1 (1/4)");
Dialog.addMessage("Open sample image");
Dialog.show();
open();
SampleImage = File.nameWithoutExtension;
rename(SampleImage);
run("Select All");
//Opening of clean mask
Dialog.create("Input file #2 (2/4)");
Dialog.addMessage("Open clean mask");
Dialog.show();
open();
CleanMask = File.nameWithoutExtension;
rename(CleanMask);
//Opening of sample border ROI set
Dialog.create("Input files #3 (3/4)");
Dialog.addMessage("Open sample border ROI set");
Dialog.show();
open();

//Deletion of the border from mask
selectWindow(CleanMask);
roiManager("Select", roiManager("Count") - 1);
setBackgroundColor(251, 251, 251);
run("Clear", "slice");
roiManager("Set Fill Color", "red");
selectWindow("ROI Manager");
run("Close");
run("Select None");

//Opening of air ducts walls ROI set
Dialog.create("Input files #4 (4/4)");
Dialog.addMessage("Open air ducts walls ROI set");
Dialog.show();
open();

//Deletion of air ducts walls from mask
selectWindow(CleanMask);
roiManager("Select", roiManager("Count") - 1);
setBackgroundColor(251, 251, 251);
run("Clear", "slice");
roiManager("Set Fill Color", "red");
selectWindow("ROI Manager");
run("Close");
run("Select None");

//Creation of parenchyma ROI
selectWindow(CleanMask);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Create Selection");
roiManager("Add");
roiManager("Select", roiManager("Count") - 1);
roiManager("Rename", "Parenchyma");

//Extraction of parenchyma from original image
selectWindow(SampleImage);
run("Duplicate...", "title=[SampleImage_copy]");
close(SampleImage);
selectWindow("SampleImage_copy");
roiManager("Select", roiManager("Count") - 1);
setBackgroundColor(251, 251, 251);
run("Clear Outside");
run("Select None");
rename(SampleImage+"_parenchyma")

//Analysis of parenchyma
//Scaling
//Initialization
px = 1;
um = 1;
//Scaling dialog
Dialog.create("Image scaling");
Dialog.addNumber("Distance (px):", px);
Dialog.addNumber("Known distance (um):", um);
Dialog.show();
//Update	
px = Dialog.getNumber();
um = Dialog.getNumber();
run("Set Scale...", "distance=px known=um unit=um");

//Measurement
roiManager("Select", roiManager("Count") - 1);
roiManager("Multi Measure");

//Ouput
	//Save dialog
	Dialog.create("Save output files");
	Dialog.addCheckbox("Save?", false);
	Dialog.show();
	
	save_output = Dialog.getCheckbox();
		if (save_output == true) {

			//Image
			selectWindow(SampleImage + "_parenchyma");
			saveAs("Tiff");
			//ROI
			selectWindow("ROI Manager");
			roiManager("save", File.getDefaultDir + "ROI_set_parenchyma.zip");
			run("Close");
			//Results
			selectWindow("Results");
			saveAs("Results", File.getDefaultDir + "Results.csv");
			run("Close");
			//Settings
			print("Analysis of: " + SampleImage);
			print("Scale: " + px + " px / " + um + " um");
			selectWindow("Log");
			saveAs("Text", File.getDefaultDir + "Settings.txt");
			run("Close");
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

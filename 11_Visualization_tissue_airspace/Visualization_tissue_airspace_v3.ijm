/*
 * The macro allows to assemble a vizualization of ROI in the sample.
 * The macro requires files generated at previous steps.
 * The present file must be copied to the "plugins" folder of ImageJ/Fiji.
 */

//Integration to ImageJ/Fiji menu
macro"Visualization_tissue_airspace"{

//Input files definition
//Opening of tissue visualization
Dialog.create("Input file #1 (1/2)");
Dialog.addMessage("Open tissue visualization image");
Dialog.show();
open();
TissueVisuImage = File.nameWithoutExtension;
rename(TissueVisuImage);
run("Select All");
selectWindow(TissueVisuImage);
run("Duplicate...", "title=[TissueVisuImage_copy]");
close(TissueVisuImage);

//Applying airspace selection
Dialog.create("Input files #2 (2/2)");
Dialog.addMessage("Open airspace ROI set");
Dialog.show();
open();
roiManager("Select", roiManager("Count") - 1);
roiManager("Set Fill Color", "blue");
roiManager("Show All without labels");
selectWindow("TissueVisuImage_copy");
run("From ROI Manager");
run("Flatten");
selectWindow("TissueVisuImage_copy-1");
rename("Visualization_tissue_airspace");
selectWindow("ROI Manager");
run("Close");
run("Select None");

//Legend
//airspace
setColor("blue");
x = 0; y = 300;
setFont("SansSerif", 50, "antiliased");
drawString("Airspace", x, y, "black");

//Deletion of intermediate files
//close("Overlay_1");

//Ouput
	//Save dialog
	Dialog.create("Save output files");
	Dialog.addCheckbox("Save?", false);
	Dialog.show();
	
	save_output = Dialog.getCheckbox();
		if (save_output == true) {

			//Image
			selectWindow("Visualization_tissue_airspace");
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
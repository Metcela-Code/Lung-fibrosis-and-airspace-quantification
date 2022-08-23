/*
 * The macro allows to detect the airspace in the sample.
 * The macro requires files generated at previous steps.
 * The present file must be copied to the "plugins" folder of ImageJ/Fiji.
 */

//Integration to ImageJ/Fiji menu
macro"Airspace_detection"{

//Input files definition
//Opening of parenchyma image
Dialog.create("Input file #1 (1/3)");
Dialog.addMessage("Open parenchyma image");
Dialog.show();
open();
ParenchymaImage = File.nameWithoutExtension;
rename(ParenchymaImage);
run("Select All");
selectWindow(ParenchymaImage);
run("Select None");
run("Duplicate...", "title=[Parenchyma_copy]");
close(ParenchymaImage);


//Closing of the parenchyma external limit
Dialog.create("Input files #2 (2/3)");
Dialog.addMessage("Open sample border ROI set");
Dialog.show();
open();
roiManager("Select", roiManager("Count") - 1);
selectWindow("Parenchyma_copy");
run("From ROI Manager");
run("Flatten");
selectWindow("Parenchyma_copy-1");
rename("Slice_closed");
selectWindow("ROI Manager");
run("Close");
run("Select None");

//Creation of the filled mask
selectWindow("Slice_closed")
run("Duplicate...", "title=[Slice_filled]");
run("Convert to Mask");
run("Fill Holes");

//Creation of the tissue selection
selectWindow("Slice_closed")
run("Duplicate...", "title=[Slice_tissue]");
run("8-bit");
setAutoThreshold("Default");
run("Threshold...");
setThreshold(0, 250);
selectWindow("Threshold");
run("Close");
run("Convert to Mask");
run("Create Selection");
roiManager("Add");
roiManager("Select", roiManager("Count") - 1);
roiManager("Rename", "Slice_tissue");
run("Select None");

//Creation of the airspace mask
selectWindow("Slice_filled");
roiManager("Select", roiManager("Count") - 1);
run("Clear", "slice");
run("Select None");
selectWindow("Slice_filled");
rename("Airspace_all");
selectWindow("ROI Manager");
run("Close");

//Removal of air ducts from airspace selection
Dialog.create("Input files #3 (3/3)");
Dialog.addMessage("Open air ducts walls ROI set");
Dialog.show();
open();
roiManager("Select", roiManager("Count") - 1);
selectWindow("Airspace_all");
run("Clear", "slice");
run("Select None");
selectWindow("Airspace_all");
rename("Airspace");
run("Convert to Mask");
run("Duplicate...", "title=[Airspace_copy]");
selectWindow("ROI Manager");
run("Close");

//Filtration of non-alveolar airspace
//Definition of default analysis parameters
run("Set Measurements...", "area perimeter limit display redirect=None decimal=3");
run("Create Selection");
run("Measure");
close("Log");
area = getResult("Area", 0);
close("Results");
run("Select None");
size_default_min = 0;
size_default_max = area;
circ_default_min = 0.00;
circ_default_max = 1.00;

//Particle filter settings dialog
//Initialization
confirm = false;
auto = false;
size_current_min = size_default_min;
size_current_max = size_default_max;
circ_current_min = circ_default_min;
circ_current_max = circ_default_max;
test = 0;

//Update
		while (confirm == false) {

		//Reset
			if (auto == true) {
				close("Airspace_filter");
				close("Mask of Airspace_filter");
				close("Airspace_copy_1");
				close("Overlay_airspace");
				close("Results");
				close("Summary");
				size_current_min = size_default_min;
				size_current_max = size_default_max;
				circ_current_min = circ_default_min;
				circ_current_max = circ_default_max;
				test = 0;
			}

		//Deletion of intermediate files
			if (test != 0) {
				close("Airspace_filter");
				close("Mask of Airspace_filter");
				close("Airspace_copy_1");
				close("Overlay_airspace");
				close("Results");
				close("Summary");
			}

		//Particles measurements
			selectWindow("Airspace");
			run("Duplicate...", "title=[Airspace_filter]");
			selectWindow("Airspace_filter");
			run("Convert to Mask");
			run("Analyze Particles...", "size=size_current_min-size_current_max circularity=circ_current_min-circ_current_max show=Masks display clear summarize add");

		//Visualization
			selectWindow("Airspace_copy");
			run("Duplicate...", "title=[Airspace_copy_1]");
			selectWindow("Mask of Airspace_filter");
			run("Create Selection");
			roiManager("Add");
			roiManager("Select", roiManager("Count") - 1);
			roiManager("Rename", "Airspace_filter");
			roiManager("Set Fill Color", "blue");
			roiManager("Show All without labels");
			selectWindow("Airspace_copy_1");
			run("From ROI Manager");
			run("Flatten");
			//Legend
				setColor("blue");
				x = 0; y = 50;
				setFont("SansSerif", 50, "antiliased");
				drawString("Airspace", x, y, "black");
			selectWindow("Airspace_copy_1-1");
			rename("Overlay_airspace");

		//Filter dialog
			ParticlesCount = roiManager("Count") - 1;
			Dialog.create("Setting of airspace filter");
			Dialog.addString("Applies to:", ParenchymaImage);
			Dialog.addString("Test #:", test);
			Dialog.addString("Particles count:", ParticlesCount);
			Dialog.addMessage("Filter parameter: Size (um^2)");
			Dialog.addNumber("Minimum:", size_current_min);
			Dialog.addNumber("Maximum:", size_current_max);
			Dialog.addMessage("Filter parameter: Circularity");
			Dialog.addNumber("Minimum:", circ_current_min);
			Dialog.addNumber("Maximum:", circ_current_max);
			options = newArray("Test settings", "Confirm settings", "Reset (default: Size: " + size_default_min + " um^2, " + size_default_max + " um^2; Circularity: " + circ_default_min + ", "+circ_default_max + ")");
			Dialog.addRadioButtonGroup("Options:", options, 3, 1, "Test settings");
			Dialog.show();
			
		//Values update
			test = test + 1;
			size_current_min = Dialog.getNumber();
			if (size_current_min < 0) {
				size_current_min = size_default_min;
			}
			if (size_current_min > area) {
				size_current_min = size_default_min;
			}
			size_current_max = Dialog.getNumber();
			if (size_current_max < 0) {
				size_current_max = size_default_max;
			}
			if (size_current_max > area) {
				size_current_max = size_default_max;
			}
			circ_current_min = Dialog.getNumber();
			if (circ_current_min < 0.00) {
				circ_current_min = circ_default_min;
			}
			if (circ_current_min > 1.00) {
				circ_current_min = circ_default_min;
			}
			circ_current_max = Dialog.getNumber();
			if (circ_current_max < 0.00) {
				circ_current_max = circ_default_max;
			}
			if (circ_current_max > 1.00) {
				circ_current_max = circ_default_max;
			}			
			select = Dialog.getRadioButton();
			if (select == "Test settings") {
				confirm = false;
				auto = false;
			}
			if (select == "Confirm settings") {
				confirm = true;
				auto = false;	
			}
			if (select == "Reset (default: Size: " + size_default_min + " um^2, " + size_default_max + " um^2; Circularity: " + circ_default_min + ", "+circ_default_max + ")") {
				confirm = false;
				auto = true;
			}
	
		}

//Output
	//Save dialog
	Dialog.create("Save output files");
	Dialog.addCheckbox("Save?", false);
	Dialog.show();
	
	save_output = Dialog.getCheckbox();
		if (save_output == true) {
			//Mask
			selectWindow("Mask of Airspace_filter");
			rename("Mask_airspace");
			roiManager("Show All without labels");
			saveAs("Tiff");
			//Overlay
			selectWindow("Overlay_airspace");
			saveAs("Tiff", File.getDefaultDir + "Overlay_airspace.tif");
			//ROI
			selectWindow("ROI Manager");
			roiManager("save", File.getDefaultDir + "ROI_set_airspace.zip");
			run("Close");
			//Results
			selectWindow("Results");
			saveAs("Results", File.getDefaultDir + "Results.csv");
			run("Close");
			//Summary
			selectWindow("Summary");
			saveAs("Results", File.getDefaultDir + "Summary.csv");
			run("Close");
			//Settings
			print("Analysis of: " + ParenchymaImage);
			print("Minimum particle size: " + size_current_min + " um^2");
			print("Maximum particle size: " + size_current_max + " um^2");
			print("Minimum particle circularity: " + circ_current_min);
			print("Maximum particle circularity: " + circ_current_max);
			print("Number of particles: " + ParticlesCount);
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
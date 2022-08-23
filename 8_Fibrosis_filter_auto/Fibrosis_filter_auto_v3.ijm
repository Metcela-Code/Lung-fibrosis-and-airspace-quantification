/*
 * The macro allows to filter particles according to their area.
 * The macro can be applied to any binary image.
 * The present file must be copied to the "plugins" folder of ImageJ/Fiji.
 */

//Integration to ImageJ/Fiji menu
macro"Fibrosis_filter_auto"{

//Input image name
Title = File.nameWithoutExtension;
rename(Title);
run("Select All");

//Duplication of image
selectWindow(Title);
run("Duplicate...", "title=[Mask_1]");
run("Duplicate...", "title=[Mask]");
close(Title);

//Definition of default analysis parameters
run("Set Measurements...", "area perimeter limit display redirect=None decimal=3");
run("Create Selection");
run("Measure");
close("Log");
area = getResult("Area", 0);
close("Results");
run("Select None");
default_min = 0;
default_max = area;

//Manual filter setting dialog
//Initialization
confirm = false;
auto = false;
current_min = default_min;
current_max = default_max;
test = 0;

//Update
		while (confirm == false) {

		//Reset
			if (auto == true) {
				close("Mask_filter");
				close("Mask of Mask_filter");
				close("Mask_1_duplicate");
				close("Overlay_filter");
				close("Results");
				close("Summary");
				close("ROI Manager");
				current_min = default_min;
				current_max = default_max;
				test = 0;
			}

		//Deletion of intermediate files
			if (test != 0) {
				close("Mask_filter");
				close("Mask of Mask_filter");
				close("Mask_1_duplicate");
				close("Overlay_filter");
				close("Results");
				close("Summary");
				close("ROI Manager");
			}

		//Particles measurements
			selectWindow("Mask");
			run("Duplicate...", "title=[Mask_filter]");
			selectWindow("Mask_filter");
			run("Analyze Particles...", "size=current_min-current_max show=Masks display clear summarize add");

		//Visualization
			selectWindow("Mask_1");
			run("Duplicate...", "title=[Mask_1_duplicate]");
			selectWindow("Mask of Mask_filter");
			run("Create Selection");
			roiManager("Add");
			roiManager("Select", roiManager("Count") - 1);
			roiManager("Rename", "Filter");
//			RoiManager.setGroup(0);
//			RoiManager.setPosition(0);
			roiManager("Set Fill Color", "magenta");
			roiManager("Show All without labels");
			selectWindow("Mask_1_duplicate");
			run("From ROI Manager");
			run("Flatten");
			//Legend
				setColor("magenta");
				x = 0; y = 50;
				setFont("SansSerif", 50, "antiliased");
				drawString("Filter", x, y, "black");
			selectWindow("Mask_1_duplicate-1");
			rename("Overlay_filter");

		//Filter dialog
			ParticlesCount = roiManager("Count") - 1;
			Dialog.create("Setting of filter");
			Dialog.addString("Applies to:", Title);
			Dialog.addString("Test #:", test);
			Dialog.addString("Particles count:", ParticlesCount);
			Dialog.addMessage("Filter parameters: Size (um^2)");
			Dialog.addNumber("Minimum:", current_min);
			Dialog.addNumber("Maximum:", current_max);
			options = newArray("Test settings", "Confirm settings", "Reset (default: " + default_min + " um^2, " + default_max + " um^2)");
			Dialog.addRadioButtonGroup("Options:", options, 3, 1, "Test settings");
			Dialog.show();
		
		//Values update
			test = test + 1;
			current_min = Dialog.getNumber();			
			if (current_min < 0) {
				current_min = default_min;
			}
			if (current_min > area) {
				current_min = default_min;
			}
			current_max = Dialog.getNumber();
			if (current_max < 0) {
				current_max = default_max;
			}
			if (current_max > area) {
				current_max = default_max;
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
			if (select == "Reset (default: " + default_min + " um^2, " + default_max + " um^2)") {
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
			selectWindow("Mask of Mask_filter");
			rename("Mask_filter");
			roiManager("Show All without labels");
			saveAs("Tiff");
			//Overlay
			selectWindow("Overlay_filter");
			saveAs("Tiff", File.getDefaultDir + "Overlay_filter.tif");
			//ROI
			selectWindow("ROI Manager");
			roiManager("save", File.getDefaultDir + "ROI_set_filter.zip");
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
			print("Analysis of: " + Title);
			print("Minimum particle size: " + current_min + " um^2");
			print("Maximum particle size: " + current_max + " um^2");
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
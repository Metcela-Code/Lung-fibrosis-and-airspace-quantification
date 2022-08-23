/*
 * The macro allows to delete particles identified by the user.
 * The macro can be applied to any binary image.
 * The present file must be copied to the "plugins" folder of ImageJ/Fiji.
 */

//Integration to ImageJ/Fiji menu
macro"Particle_filter_manual"{

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

//Particle cleaning dialog
//Initialization
setBackgroundColor(211, 211, 211);
confirm = false;
test = 0;

//Update
	while (confirm == false) {

	//Deletion of iintermediate files
		if (test != 0) {
			close("Mask_clean");
			close("Mask of Mask_clean");
			close("Mask_1_duplicate");
			close("Overlay_clean");
			close("Results");
			close("Summary");
			close("ROI Manager");
		}

	//Cleaning dialog
		selectWindow("Mask");
		waitForUser("Select and delete undesired particles");
		run("Select All");
		run("Convert to Mask");

	//Particles measurements
		selectWindow("Mask");
		run("Duplicate...", "title=[Mask_clean]");
		selectWindow("Mask_clean");
		run("Analyze Particles...", "  show=Masks display clear summarize add");

	//Visualization
		selectWindow("Mask_1");
		run("Duplicate...", "title=[Mask_1_duplicate]");
		selectWindow("Mask_clean");
		run("Create Selection");
		roiManager("Add");
		roiManager("Select", roiManager("Count") - 1);
		roiManager("Rename", "Clean");
//		RoiManager.setGroup(0);
//		RoiManager.setPosition(0);
		roiManager("Set Fill Color", "magenta");
		roiManager("Show All without labels");
		selectWindow("Mask_1_duplicate");
		run("From ROI Manager");
		run("Flatten");
		//Legend
			setColor("magenta");
			x = 0; y = 50;
			setFont("SansSerif", 50, "antiliased");
			drawString("Clean", x, y, "black");
		selectWindow("Mask_1_duplicate-1");
		rename("Overlay_clean");

	//Cleaning dialog
		ParticlesCount=roiManager("Count") - 1;
		Dialog.create("Cleaning of undesired particles");
		Dialog.addString("Applies to:", Title);
		Dialog.addString("test #:", test);
		Dialog.addString("Particles count:", ParticlesCount);
		options = newArray("Continue cleaning", "Confirm cleaning");
		Dialog.addRadioButtonGroup("Options:", options, 2, 1, "Continue cleaning");
		Dialog.show();
		
	//Values update
		test = test + 1;
		select = Dialog.getRadioButton();
			if (select == "Continue cleaning") {
				confirm = false;
			}
			if (select == "Confirm cleaning") {
				confirm = true;	
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
			selectWindow("Mask_clean");
			rename("Mask_clean");
			roiManager("Show All without labels");
			saveAs("Tiff");
			//Overlay
			selectWindow("Overlay_clean");
			saveAs("Tiff", File.getDefaultDir + "Overlay_clean.tif");
			//ROI
			selectWindow("ROI Manager");
			roiManager("save", File.getDefaultDir + "ROI_set_clean.zip");
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